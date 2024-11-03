import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapp/Screens/chat.dart';
import 'package:mapp/model/chat_user.dart';

class ChatCard extends StatefulWidget {
  final Chatuser user;
  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
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
            child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    width: 55,
                    height: 55,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                title: Text(widget.user.name),
                subtitle: Text(
                  widget.user.about,
                  maxLines: 1,
                ),
                trailing: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightGreenAccent.shade400,
                  ),
                )
                // trailing: const Text(
                //   "12:00pm",
                //   style: TextStyle(color: Colors.black54),
                // ),
                ),
          )),
    );
  }
}
