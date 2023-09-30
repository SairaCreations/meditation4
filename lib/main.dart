import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation4/HomePage.dart';
import 'package:meditation4/Service/Auth_Service.dart';
import 'package:meditation4/SignUpPage.dart';
import 'package:meditation4/firebase_options.dart';
import 'package:meditation4/widgets/youtube_frame.dart';

//import 'carousel.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
late final TextEditingController _emailController;
late final TextEditingController _passwordController;
late final StreamSubscription _firebaseStreamEvents;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = const SignUpPage(null);
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        currentPage = HomePage();
        //  currentPage = Carousel();
        // currentPage = YoutubeApp();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage,
    );
  }
}
