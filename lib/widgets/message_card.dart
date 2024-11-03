import 'package:flutter/material.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/model/message.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(4),
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
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 17, color: Colors.black87),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Text(
            widget.message.sent,
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
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              '${widget.message.read}12:00am',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(4),
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
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 17, color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
