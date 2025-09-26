import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/Screens/chat.dart';
import 'package:mapp/model/chat_user.dart';
import 'package:mapp/model/message.dart';
import 'package:mapp/utilities/my_date_util.dart';
import 'package:mapp/widgets/Dialogs/profile_dialogs.dart';

class ChatCard extends StatefulWidget {
  final Chatuser user;
  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      child: Card(
          elevation: 1,
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(user: widget.user)));
              },
              child: StreamBuilder(
                stream: Apis.getLastMessages(widget.user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => Message.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) _message = list[0];
                  return ListTile(
                    leading: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ProfileDialogs(user: widget.user,),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          width: 55,
                          height: 55,
                          imageUrl: widget.user.image,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text(widget.user.name),
                    subtitle: Text(
                      _message != null
                          ? _message!.type == Type.image
                              ? 'image'
                              : _message!.msg
                          : widget.user.about,
                      maxLines: 1,
                    ),
                    trailing: _message == null
                        ? null
                        : _message!.read.isEmpty &&
                                _message!.fromid != Apis.user.uid
                            ? Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.lightGreenAccent.shade400,
                                ),
                              )
                            : Text(
                                MyDateUtil.getlastmessagetime(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(color: Colors.black54),
                              ),
                  );
                },
              ))),
    );
  }
}
