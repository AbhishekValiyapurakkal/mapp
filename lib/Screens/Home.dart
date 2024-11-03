import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/Screens/profile.dart';
import 'package:mapp/model/chat_user.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });

            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'name,E mail,...'),
                    autofocus: true,
                    style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (val) {
                      _searchlist.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
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
            onPressed: () async {
              await Apis.auth.signOut();
              await GoogleSignIn().signOut();
            },
            child: Icon(Icons.add_comment),
          ),
          body: StreamBuilder(
              stream: Apis.getAllusers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data
                            ?.map((e) => Chatuser.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (list.isNotEmpty) {
                      return ListView.builder(
                        itemCount:
                            _isSearching ? _searchlist.length : list.length,
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
                      return const Center(
                        child: Text(
                          'No Connection found!',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
              }),
        ),
      ),
    );
  }
}
