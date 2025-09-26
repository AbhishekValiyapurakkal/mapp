import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/Screens/viewprofile.dart';
import 'package:mapp/model/chat_user.dart';
import 'package:mapp/model/message.dart';
import 'package:mapp/utilities/my_date_util.dart';
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
  bool _showEmoji = false, _isuploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
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
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: const EdgeInsets.only(top: 5),
                              physics: const BouncingScrollPhysics(),
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
              if (_isuploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )),
              _chatinput(),
              //if (_showEmoji)
              // SizedBox(
              //   height: 35,
              //   child: EmojiPicker(
              //     textEditingController: _textcontroller,
              //     config: Config(
              //       columns: 7,
              //       emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => viewprofile(user: widget.user),
              ));
        },
        child: StreamBuilder(
            stream: Apis.getUserinfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Chatuser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black54,
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        imageUrl:
                            list.isNotEmpty ? list[0].image : widget.user.image,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                              child: Icon(CupertinoIcons.person),
                            )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.isNotEmpty ? list[0].name : widget.user.name,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? 'online'
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      )
                    ],
                  )
                ],
              );
            }));
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
                  // IconButton(
                  //     onPressed: () {
                  //       setState(() => _showEmoji = !_showEmoji);
                  //     },
                  //     icon: Icon(
                  //       Icons.emoji_emotions,
                  //       color: Colors.grey[600],
                  //     )),
                  Expanded(
                      child: TextField(
                    controller: _textcontroller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: InputDecoration(
                        hintText: '  Message',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // pickig multiple images
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var i in images) {
                          log('image path : ${i.path}');
                          setState(() => _isuploading = true);
                          await Apis.sendchatimage(widget.user, File(i.path));
                          setState(() => _isuploading = false);
                        }
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.grey[600],
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('image path: ${image.path}');
                          setState(() => _isuploading = true);
                          await Apis.sendchatimage(
                              widget.user, File(image.path));
                          setState(() => _isuploading = false);
                        }
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.grey[600],
                      )),
                  const SizedBox(
                    width: 2,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            shape: const CircleBorder(),
            color: Colors.green[600],
            onPressed: () {
              if (_textcontroller.text.isNotEmpty) {
                if(_list.isEmpty){
                 Apis.sendFirstMessage(widget.user, _textcontroller.text, Type.text);
                }else {
                  Apis.sendmessage(widget.user, _textcontroller.text, Type.text);
                }
                _textcontroller.text = '';
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            child: const Icon(
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
