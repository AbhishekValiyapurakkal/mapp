import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/Screens/Home.dart';
import 'package:mapp/utilities/dialoges.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  Future googlesignin() async {
    try {
      await InternetAddress.lookup('google.com');
      final google = GoogleSignIn();
      // ignore: body_might_complete_normally_catch_error
      final user = await google.signIn().catchError((error) {});
      if (user == null) return;
      final auth = await user.authentication;
      final credential = await GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      if ((await Apis.userExists())) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      } else {
        Apis.createuser().then(
          (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ));
          },
        );
      }
    } catch (e) {
      log('\n_googlesignin:$e');
      Dialoges.showSnackbar(context, 'Something went wrong check internet!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MAPP",
          style: GoogleFonts.montserrat(
              fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black54),
        ),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        backgroundColor: Colors.green[400],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
          ),
          Center(
              child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset('lib/assets/Animation.json'))),
          //Image.asset('lib/image/bird.jpg'),
          SizedBox(
            height: 10,
            width: 600,
          ),
          ElevatedButton.icon(
            onPressed: () {
              googlesignin();
            },
            style: ElevatedButton.styleFrom(
                maximumSize: Size(230, 50),
                minimumSize: Size(230, 50),
                backgroundColor: Colors.green[300],
                elevation: 10,
                shadowColor: Colors.black87,
                shape: StadiumBorder()),
            label: Text(
              "Login with Google",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            icon: Image.asset(
              'lib/image/google_logo_2.webp',
              scale: 50,
            ),
          )
        ],
      ),
    );
  }
}
