import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapp/Screens/splashscreen.dart';
import 'package:mapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (value) {
      runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splashscreen(),
  ));
    },
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
}
