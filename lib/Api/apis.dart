import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mapp/model/chat_user.dart';
import 'package:mapp/model/message.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static late Chatuser me;
  static User get user => auth.currentUser!;
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
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

  ///************** Chat screen Related APIS **************
  static String getconversationid(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      Chatuser user) {
    return firestore
        .collection('chats/${getconversationid(user.id)}/messages/')
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
}
