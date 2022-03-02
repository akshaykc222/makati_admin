import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makati_admin/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCw8xZ502B-jBUt9djJpG17LWL676_65Ts",
          appId: "1:530380727559:web:355e8a086bb1b99bfd51a2",
          messagingSenderId: "530380727559",
          storageBucket: "makati-c6b82.appspot.com",
          authDomain: "makati-c6b82.firebaseapp.com",
          measurementId: "G-37CB8JFEQP",
          projectId: "makati-c6b82"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mackati admin',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
