import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import 'package:meditation4/GraphList.dart';

//class wtih helper functions
class TimeMachine {
  final store = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  int getCurrentTimeInMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

//function to get the starting point- time from where the graph is displayed ie 7 days ago
  int getTimeInMilliseconds7DaysAgo() {
    final currentTimeInMillis = getCurrentTimeInMillis();
    const sevenDaysInMilliseconds = 7 * 24 * 60 * 60 * 1000;
    final time7DaysAgo = currentTimeInMillis - sevenDaysInMilliseconds;
    return time7DaysAgo;
  }

//get a list of milllliseconds at midnight for past 7 days. This will be used to split the work done into days
  List<int> getMidnightMillisForLast7Days() {
    final List<int> midnightMillisList = [];
    final DateTime now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final DateTime midnight = DateTime(now.year, now.month, now.day - i);
      final int midnightMillis = midnight.millisecondsSinceEpoch;
      midnightMillisList.add(midnightMillis);
    }

    return midnightMillisList;

    /*
 for (int i = 0; i < 7; i++) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(midnightMillisList[i]);
    print("Midnight of ${date.toLocal()} (in milliseconds since epoch): ${midnightMillisList[i]}");
  

  */
  }

//async function to get data from firestore
  Future<GraphList> getRecordsGreaterThanTimestamp(
      DateTime timestamp, String userLocal, GraphList graphList) async {
    //GraphList graphList = GraphList.withDate(timestamp, DateTime.now());
    // GraphList graphList = GraphList();

    developer.log(graphList.toString(), name: "ALMOST2");

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('TimeWorked')
              .where('dateWorked', isGreaterThan: timestamp)
              .where('user', isEqualTo: userLocal)
              .get();

      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          //   developer.debugger();
          final Timestamp timestamp = doc['dateWorked'] as Timestamp;
          final DateTime dateWorked = timestamp.toDate();
          final int hours = doc['hours'] as int;
          final int minutes = doc['minutes'] as int;
          final String userID = doc['user'] as String;
          //once we get the snapshot of data, we need to populate the graphList with this data, so calling catchAndPopulate
          GraphList.catchAndPopulate(timestamp, hours, minutes, graphList);

          //get rid of all these log statements
          developer.log('Date Worked: $dateWorked', name: "ALMOST");
          developer.log('Hours: $hours', name: "ALMOST");
          developer.log('Minutes: $minutes', name: "ALMOST");
          //print('UserID: $userID');
          for (int i = 0; i < 7; i++) {
            developer.log(graphList.dataList![i].totalMinutes.toString(),
                name: "ALMOST ALSO");
          }
        }
        // print(graphList.toString());
      } else {
        developer.log('No records found greater than the specified timestamp.',
            name: "ALMOST");
      }
      /* FirebaseFirestore db = FirebaseFirestore.instance;
      final docRef = db.collection("TimeWorked").doc("1");
      docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          developer.log(data.toString(), name: "NOTSEVERE");
        },
        onError: (e) => print("Error getting document: $e"),
      );*/
      //

      // for (final doc in snapshot.docs) {
      // final Timestamp timestamp = doc['dateWorked'] as Timestamp;
      //final DateTime dateWorked = timestamp.toDate();
      //final double hours = doc['hours'] as double;
      //final int minutes = doc['minutes'] as int;
      //var data = doc.data();
      //String userID = data.user as String;
/*
          print('Date Worked: $dateWorked');
          print('Hours: $hours');
          print('Minutes: $minutes');
          print('UserID: $userID');
          print('---');
          */

      //developer.log( doc.toString(),name: 'NOTSEVERE');
      // developer.log('Hours:$hours', name: 'NOTSEVERE');
      // }
    } catch (e) {
      // Handle any potential errors here
      //
      print('Error fetching data: $e');
    }

    return graphList;
  }

//another function to get the minutes worked in each day for the current user
//name is a bit misleading. Not using this function anywhere
  Future<double?> getHoursWorkedForDate(
      String dateWorked, String userID) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('TimeWorked')
              .where('dateWorked', isLessThan: dateWorked)
              .where('user', isEqualTo: userID)
              .get();

      if (snapshot.docs.isNotEmpty) {
        // If there are matching documents, sum the 'hours' field
        double totalHoursWorked = 0.0;
        for (final doc in snapshot.docs) {
          totalHoursWorked += doc['minutes'] as double;
        }

        return totalHoursWorked;
      } else {
        // No matching documents found
        return null;
      }
    } catch (e) {
      // Handle any potential errors here
      print('Error fetching data: $e');
      return null;
    }
  }
}
