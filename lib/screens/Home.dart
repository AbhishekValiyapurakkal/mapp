import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/Screens/profile.dart';
import 'package:mapp/model/chat_user.dart';
import 'package:mapp/utilities/dialoges.dart';
import 'package:mapp/widgets/chat_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Chatuser> list = [];
  final List<Chatuser> _searchlist = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    Apis.getselfinfo();

    SystemChannels.lifecycle.setMessageHandler(
      (message) {
        log('Message: $message');
        if (Apis.auth.currentUser != null) {
          if (message.toString().contains('resume')) {
            Apis.updateActivestatus(true);
          }
          if (message.toString().contains('pause')) {
            Apis.updateActivestatus(false);
          }
        }

        return Future.value(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: _isSearching
                  ? TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'name,E mail,...'),
                      autofocus: true,
                      style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                      onChanged: (val) {
                        _searchlist.clear();
                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchlist.add(i);
                            setState(() {
                              _searchlist;
                            });
                          }
                          ;
                        }
                      },
                    )
                  : Text(
                      "MAPP",
                      style: GoogleFonts.montserrat(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Colors.black54),
                    ),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(
                      _isSearching
                          ? CupertinoIcons.clear_circled_solid
                          : Icons.search,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => profile(
                              user: Apis.me,
                            ),
                          ));
                    },
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 30,
                    )),
              ],
              elevation: 5,
              shadowColor: Colors.black87,
              backgroundColor: Colors.green[400],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green[400],
              elevation: 10,
              hoverColor: Colors.green[600],
              onPressed: () {
                _addChatUserDialog();
              },
              child: Icon(Icons.add_comment),
            ),
            body: StreamBuilder(
              stream: Apis.getMyUsersId(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                        stream: Apis.getAllusers(
                            snapshot.data?.docs.map((e) => e.id).toList() ??
                                []),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                            //return const Center(
                            //  child: CircularProgressIndicator());
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              list = data
                                      ?.map((e) => Chatuser.fromJson(e.data()))
                                      .toList() ??
                                  [];
                              if (list.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: _isSearching
                                      ? _searchlist.length
                                      : list.length,
                                  padding: EdgeInsets.only(top: 5),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ChatCard(
                                        user: _isSearching
                                            ? _searchlist[index]
                                            : list[index]);
                                    // return Text('name:${list[index]}');
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    'No Connections found!',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              }
                          }
                        });
                }
              },
            )),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.person_add,
              color: Colors.blue,
              size: 28,
            ),
            Text(' Add User')
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blueGrey,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.pop(context);
              if (email.trim().isNotEmpty) {
                await Apis.addChatUser(email).then(
                  (value) {
                    if (!value) {
                      Dialoges.showSnackbar(context, 'User dose not exists!');
                    }
                  },
                );
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
