import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapp/model/chat_user.dart';
import 'package:mapp/utilities/my_date_util.dart';

class viewprofile extends StatefulWidget {
  final Chatuser user;
  const viewprofile({super.key, required this.user});

  @override
  State<viewprofile> createState() => _viewprofileState();
}

class _viewprofileState extends State<viewprofile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(widget.user.name),
            elevation: 5,
            shadowColor: Colors.black87,
            backgroundColor: Colors.green[400],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined on:',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              Text(
                MyDateUtil.getlastmessagetime(
                    context: context,
                    time: widget.user.createdAt,
                    showYear: true),
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) =>const CircleAvatar(child:  Icon(CupertinoIcons.person))
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About:',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(
                        widget.user.about,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
