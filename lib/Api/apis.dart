import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:mapp/model/chat_user.dart';
import 'package:mapp/model/message.dart';

import 'notification_access_token.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static late Chatuser me;
  static User get user => auth.currentUser!;
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessagingToken() async {
    await fmessaging.requestPermission();

    await fmessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   log('Got a message whilst in the foreground!');
//   log('Message data: ${message.data}');

//   if (message.notification != null) {
//     log('Message also contained a notification: ${message.notification}');
//   }
// });
  }

  static Future<void> sendPushNotification(
      Chatuser chatUser, String msg) async {
    try {
      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": me.name,
            "body": msg,
            "android_channel_id": "chats",
          },
          "data": {
            "some_data": "User Id: ${me.id}",
          },
        }
      };

      const projectID = 'mapp-df3dc';

      final bearerToken = await NotificationAccessToken.getToken;

      log('bearerToken: $bearerToken');

      if (bearerToken == null) return;

      var res = await post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );

      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      log('data:${data.docs}');
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      return false;
    }
  }

  static Future<void> getselfinfo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then(
      (user) async {
        if (user.exists) {
          me = Chatuser.fromJson(user.data()!);
          await getFirebaseMessagingToken();
          Apis.updateActivestatus(true);
          log('My Data: ${user.data()}');
        } else {
          await createuser().then(
            (value) => getselfinfo(),
          );
        }
      },
    );
  }

  static Future<void> createuser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = Chatuser(
        name: user.displayName.toString(),
        about: "Hey iam using Mapp",
        pushToken: '',
        isOnline: false,
        createdAt: time,
        email: user.email.toString(),
        lastActive: time,
        id: user.uid,
        image: user.photoURL.toString());
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusers(
      List<String> userIds) {
    log('\nUserids: $userIds');
    return firestore
        .collection('users')
        .where('id', whereIn: userIds.isEmpty?['']:userIds)
        //.where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> sendFirstMessage(
      Chatuser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then(
      (value) => sendmessage(chatUser, msg, type),
    );
  }

  static Future<void> updateuserinfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilepicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = storage.ref().child('profilepictures/${user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
      (p0) {
        log('Data Transferred:${p0.bytesTransferred / 1000}kb');
      },
    );
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserinfo(
      Chatuser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActivestatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  ///************** Chat screen Related APIS **************
  static String getconversationid(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      Chatuser user) {
    return firestore
        .collection('chats/${getconversationid(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendmessage(
      Chatuser chatUser, String msg, Type type) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final Message message = Message(
        toid: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        sent: time,
        fromid: user.uid);
    final ref = firestore
        .collection('chats/${getconversationid(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadstatus(Message message) async {
    firestore
        .collection('chats/${getconversationid(message.fromid)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      Chatuser user) {
    return firestore
        .collection('chats/${getconversationid(user.id)}/messages/')
        .limit(1)
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendchatimage(Chatuser chatUser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'images/${getconversationid(chatUser.id)}/${DateTime.now().microsecondsSinceEpoch}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
      (p0) {
        log('Data Transferred:${p0.bytesTransferred / 1000}kb');
      },
    );
    final imageUrl = await ref.getDownloadURL();
    await sendmessage(chatUser, imageUrl, Type.image);
  }

  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getconversationid(message.toid)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  static Future<void> updateMessage(Message message, String updatedmsg) async {
    await firestore
        .collection('chats/${getconversationid(message.toid)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedmsg});
  }
}
