import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/model/message.dart';
import 'package:mapp/utilities/my_date_util.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.fromid
        ? _greenmessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    if (widget.message.read.isNotEmpty) {
      Apis.updateMessageReadstatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 3 : 4),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 188, 217, 241),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.black87),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          errorWidget: (context, url, error) => const Icon(
                                Icons.image,
                                size: 70,
                              )),
                    ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Text(
            MyDateUtil.getformattedTime(
                context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenmessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 4,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            SizedBox(
              width: 2,
            ),
            Text(
              MyDateUtil.getformattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 3 : 4),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 168, 243, 169),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.black87),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          errorWidget: (context, url, error) => const Icon(
                                Icons.image,
                                size: 70,
                              )),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
