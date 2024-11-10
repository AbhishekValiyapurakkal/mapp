import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapp/Screens/viewprofile.dart';
import 'package:mapp/model/chat_user.dart';

class ProfileDialogs extends StatelessWidget {
  const ProfileDialogs({super.key, required this.user});
  final Chatuser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: 60,
        height: 250,
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        )),
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              width: 160,
              child: Text(user.name,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.w500)),
            ),
            Positioned(
                right: 8,
                top: 6,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => viewprofile(user: user),
                        ));
                  },
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
