import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day1_try6_jam/firebase_options.dart';
import 'package:wsmb_day1_try6_jam/pages/LoginPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = 
  const Settings(persistenceEnabled: true);
  runApp(const MyApp(home:LoginPage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.home});
  final Widget home;

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}


