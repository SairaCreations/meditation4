import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation4/Service/Auth_Service.dart';
import 'package:meditation4/SignUpPage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //AuthClass authClass = AuthClass();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Stopwatch stopwatch = Stopwatch();
  late String text;
  late String image;
  String imagepath = "assets/focus.svg";
  String buttonName = "Start Focus Task";
  bool timerRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthClass().signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const SignUpPage(null)),
                    (route) => false);
              }),
        ]),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),*/

              const SizedBox(
                height: 20,
              ),

              // buttonItem(image, text, 25)

              const Text("Hi"),

              buttonItem(25)
            ],
          ),
        ));
  }

  Widget buttonItem(double size) {
    return InkWell(
      onTap: () {
        /*final snackBar = SnackBar(
            content: Text(stopwatch.elapsed.toString()),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ));*/
        changeText();
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.blueGrey,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changeText() async {
    setState(() {
      if (stopwatch.isRunning) {
        var now = DateTime.now();
        Duration duration = stopwatch.elapsed;
        int hours = duration.inHours;
        int minutes = duration.inMinutes.remainder(60);
        FirebaseFirestore.instance.collection("TimeWorked").add({
          "user": user?.uid,
          "dateWorked": now,
          "hours": hours,
          "minutes": minutes
        });

        final snackBar = SnackBar(
            content: Text(stopwatch.elapsed.toString()),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        stopwatch.stop();
        stopwatch.reset();

        imagepath = "assets/focus.svg";
        buttonName = "Start Focus Task";
      } else {
        imagepath = "assets/relax.svg";
        buttonName = "Stop Focus Task";

        stopwatch.start();
      }
    });
  }
}
