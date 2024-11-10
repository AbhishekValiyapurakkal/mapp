import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/Auth/login.dart';
import 'package:mapp/model/chat_user.dart';
import 'package:mapp/utilities/dialoges.dart';

class profile extends StatefulWidget {
  final Chatuser user;
  const profile({super.key, required this.user});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final _formkey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Profile",
              style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.black54),
            ),
            elevation: 5,
            shadowColor: Colors.black87,
            backgroundColor: Colors.green[400],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            elevation: 10,
            hoverColor: Colors.green[600],
            onPressed: () async {
              Dialoges.showProgressbar(context);
              await Apis.updateActivestatus(false);
              await Apis.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then(
                  (value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Apis.auth = FirebaseAuth.instance;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => login(),
                        ));
                  },
                );
              });
            },
            label: const Text("Logout"),
            icon: const Icon(Icons.logout_rounded),
          ),
          body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 30,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  File(_image!),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomsheet();
                            },
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      widget.user.email,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => Apis.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required field',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14)),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: "Eg: Nimisha",
                        labelText: "Name",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => Apis.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required field',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14)),
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        hintText: "Eg: Feeling happy",
                        labelText: "About",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: const Size(60, 55)),
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          Apis.updateuserinfo().then(
                            (value) {
                              Dialoges.showSnackbar(
                                  context, "Profile updated successfully");
                            },
                          );
                        }
                      },
                      label: const Text(
                        "UPDATE",
                        style: TextStyle(fontSize: 16),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        size: 28,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomsheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 30, bottom: 50),
          children: [
            const Text(
              "Pick profile picture",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.white,
                        fixedSize: Size(150, 60)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        log('image path: ${image.path} -- Mime type: ${image.mimeType}');
                        setState(() {
                          _image = image.path;
                        });
                        Apis.updateProfilepicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset('lib/image/add_image.png')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 60),
                        shape: CircleBorder(),
                        backgroundColor: Colors.white,
                        fixedSize: Size(150, 60)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        log('image path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });
                        Apis.updateProfilepicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset('lib/image/camera.png'))
              ],
            )
          ],
        );
      },
    );
  }

}
