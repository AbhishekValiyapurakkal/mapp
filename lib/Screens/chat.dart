import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/model/chat_user.dart';
import 'package:mapp/model/message.dart';
import 'package:mapp/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final Chatuser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => CchatscreeSState();
}

class CchatscreeSState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(),
        ),
        backgroundColor: const Color.fromARGB(255, 227, 242, 228),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: Apis.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        log('Data:${jsonEncode(data![0].data())}');
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: 5),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index]);
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('Say Hi!👋',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  }),
            ),
            _chatinput()
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 2,
              ),
              const Text(
                'Last seen not available',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatinput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2.5),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey[600],
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textcontroller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: Colors.grey[600],
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.grey[600],
                      )),
                  SizedBox(
                    width: 2,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            shape: CircleBorder(),
            color: Colors.green[600],
            onPressed: () {
              if (_textcontroller.text.isNotEmpty) {
                Apis.sendmessage(widget.user, _textcontroller.text);
                _textcontroller.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 26,
            ),
          )
        ],
      ),
    );
  }
}
