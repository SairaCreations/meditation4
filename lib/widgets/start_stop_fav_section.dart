import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation4/TimeMachine.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:developer' as developer;
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../GraphList.dart';

///
class StartStopFavBar extends StatefulWidget {
  StartStopFavBar();

  @override
  // ignore: library_private_types_in_public_api
  _StartStopFavBar createState() {
    return _StartStopFavBar();
  }
}

class _StartStopFavBar extends State {
  //final ValueNotifier<bool> _isMuted = ValueNotifier(false);

  User? user = FirebaseAuth.instance.currentUser;
  static Stopwatch stopwatch = Stopwatch();
  static bool visStart = true;
  static bool visStop = false;
  static Duration duration = Duration();
  static Timer? timer;
  bool countDown = false;

  @override
  void initState() {
    super.initState();
    developer.log('Saira log initstate callled ', name: 'SEVERE');

    /// bool visStart, visStop;
    // print("initstate called");

    // final bool visStart, visStop;
  }

  //StartStopFavBar({super.key});
  @override
  Widget build(BuildContext context) {
    String focusImagePath = "assets/focus.svg";
    String relaxImagePath = "assets/relax.svg";

    return LayoutBuilder(
      builder: (context, constraints) {
        if ((constraints.maxWidth > 500)) {
          return Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //   buttonItem(25, "Start", "Start", MediaQuery.of(context).size.width / 2,   focusImagePath),

                  Visibility(
                      visible: visStart,
                      //child: ElevatedButton(
                      //  onPressed: () {
                      //  changeText("Start");
                      //},
                      child: buttonItem(
                          25,
                          "Start",
                          "Start",
                          MediaQuery.of(context).size.width / 3,
                          focusImagePath)),

                  Visibility(
                    visible: visStop,
                    /*  child: ElevatedButton(
                onPressed: () {
                  changeText("Stop");
                },
                child: const Text("Stop"),*/
                    child: buttonItem(25, "Stop", "Stop",
                        MediaQuery.of(context).size.width / 3, relaxImagePath),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTime(),
                        //SizedBox(
                        //  height: 80,
                        //  ),
                        //buildButtons()
                      ],
                    ),
                  ),
                ]),
          );
        }
        return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //   buttonItem(25, "Start", "Start", MediaQuery.of(context).size.width / 2,   focusImagePath),

                Visibility(
                    visible: visStart,
                    //child: ElevatedButton(
                    //  onPressed: () {
                    //  changeText("Start");
                    //},
                    child: buttonItem(15, "Start", "Start",
                        MediaQuery.of(context).size.width / 2, focusImagePath)),

                Visibility(
                  visible: visStop,
                  /*  child: ElevatedButton(
                onPressed: () {
                  changeText("Stop");
                },
                child: const Text("Stop"),*/
                  child: buttonItem(15, "Stop", "Stop",
                      MediaQuery.of(context).size.width / 2, relaxImagePath),
                ),
                const SizedBox(height: 40),
                buildTime()
                /* Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildTime(),
                      //SizedBox(
                      //  height: 80,
                      //  ),
                      //buildButtons()
                    ],
                  ),
                ),*/
              ]),
        );
      },
    );
  }

  Widget buttonItem(double size, String buttonName, String action,
      double overallWidth, String imagepath) {
    return InkWell(
      onTap: () {
        changeText(action);
        /*final snackBar = SnackBar(
            content: Text(stopwatch.elapsed.toString()),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ));*/

        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        width: overallWidth - 60,
        height: 60,
        child: Card(
          color: Color.fromARGB(30, 226, 240, 246),
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  buttonName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changeText(String action) async {
    if ((action == "Stop") && (stopwatch.isRunning)) {
      setState(() {
        visStart = true;
        visStop = false;

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

        stopwatch.stop();
        stopTimer();
        reset();
        stopwatch.reset();
      });
    } else if ((action == "Start") && (!stopwatch.isRunning)) {
      setState(() {
        visStart = false;
        visStop = true;
        stopwatch.start();
        startTimer();
      });
      // developer.debugger();
      TimeMachine timeMachine = TimeMachine();
      int time7daysago = timeMachine.getTimeInMilliseconds7DaysAgo();
      developer.log(time7daysago.toString(), name: "ALMOST4");
      //developer.debugger();
      DateTime getPastTime = DateTime.fromMillisecondsSinceEpoch(time7daysago);
      GraphList graphList = GraphList.withDate(getPastTime, DateTime.now());
      await timeMachine.getRecordsGreaterThanTimestamp(
          getPastTime, user!.uid, graphList);
    }
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  void reset() {
    setState(() => duration = Duration());
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'HOURS'),
      SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(header, style: const TextStyle(color: Colors.black45)),
        ],
      );
}
