import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:fl_chart/fl_chart.dart';
import 'package:meditation4/GraphList.dart';
import 'package:meditation4/widgets/youtube_frame.dart';

import 'TimeMachine.dart';

class DataItem {
  int x;
  double y1;
  double y2;
  double y3;
  DataItem(
      {required this.x, required this.y1, required this.y2, required this.y3});
}

//make global variable so that it can be used everywhere
//need to initialize with default constructor
GraphList graphList2 = GraphList();

//do we need stateful. ?
class Charts extends StatefulWidget {
  final String listName;
  const Charts({required this.listName, Key? key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  User? user = FirebaseAuth.instance.currentUser;
  //initState - call all async wait functions to get the data from firestore
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TimeMachine timeMachine = TimeMachine();

    int time7daysago = timeMachine.getTimeInMilliseconds7DaysAgo();
    // developer.log(time7daysago.toString(), name: "ALMOST4");

    DateTime getPastTime = DateTime.fromMillisecondsSinceEpoch(time7daysago);
    GraphList graphList = GraphList.withDate(getPastTime, DateTime.now());
    //Future(()

    //if you dont bind the future to the widget, the build may happen before
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      graphList2 = await timeMachine.getRecordsGreaterThanTimestamp(
          getPastTime, user!.uid, graphList);
      setState(() {});
    });

    //get rid of all this log- checking if it initializes the graphList
    for (int i = 0; i < 7; i++) {
      developer.log(graphList2.dataList![i].totalMinutes.toString(),
          name: "GRAPHLIST");
      developer.log(graphList2.dataList![i].endOfDay.toString(),
          name: "GRAPHLIST");
      developer.log(graphList2.dataList![i].startOfDay.toString(),
          name: "GRAPHLIST");
      developer.log(graphList2.dataList![i].dayOfWeek.toString(),
          name: "GRAPHLIST");
    }
    ;
  }

  //developer.log(time7daysago.toString(), name: "ALMOST4");
  //developer.debugger();
//dont need, this is from the fl_charts code
  final List<DataItem> _myData = List.generate(
      30,
      (index) => DataItem(
            x: index,
            y1: Random().nextInt(20) + Random().nextDouble(),
            y2: Random().nextInt(20) + Random().nextDouble(),
            y3: Random().nextInt(20) + Random().nextDouble(),
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 27, 40, 62),
          title: const Text(
            'Your Weekly Progress:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(context))
          /*  onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (builder) => YoutubeAppDemo(
                          listName: listName,
                        )),
                (route) => false)*/

          ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 27, 40, 62),
              Color.fromARGB(255, 146, 110, 124)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 2,
              child: BarChart(BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(
                      show: true,
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: getBottomTitles))),
                  borderData: FlBorderData(show: false),
                  /*FlBorderData(
                      border: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide(width: 1),
                    bottom: BorderSide(width: 1),
                  )),*/
                  groupsSpace: 10,
                  barGroups: [
                    BarChartGroupData(
                        x: (graphList2.dataList![0].dayOfWeek),
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              //toY: 20,
                              toY: graphList2.dataList![0].totalMinutes
                                  .toDouble(),
                              width: 25,
                              color: const Color.fromARGB(255, 27, 40, 62),
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: graphList2.dataList![0].totalMinutes
                                      .toDouble(),
                                  color:
                                      const Color.fromARGB(153, 38, 55, 86))),
                        ]),
                    BarChartGroupData(
                        x: (graphList2.dataList![1].dayOfWeek),
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              //toY: 20,
                              toY: graphList2.dataList![1].totalMinutes
                                  .toDouble(),
                              width: 25,
                              color: const Color.fromARGB(255, 27, 40, 62),
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: graphList2.dataList![0].totalMinutes
                                      .toDouble(),
                                  color:
                                      const Color.fromARGB(153, 38, 55, 86))),
                        ]),
                    BarChartGroupData(
                        x: (graphList2.dataList![2].dayOfWeek),
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              //toY: 20,
                              toY: graphList2.dataList![2].totalMinutes
                                  .toDouble(),
                              width: 25,
                              color: const Color.fromARGB(255, 27, 40, 62),
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: graphList2.dataList![0].totalMinutes
                                      .toDouble(),
                                  color:
                                      const Color.fromARGB(153, 38, 55, 86))),
                        ]),
                    BarChartGroupData(
                        x: (graphList2.dataList![3].dayOfWeek),
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              //toY: 20,
                              toY: graphList2.dataList![3].totalMinutes
                                  .toDouble(),
                              width: 25,
                              color: const Color.fromARGB(255, 27, 40, 62),
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: graphList2.dataList![0].totalMinutes
                                      .toDouble(),
                                  color:
                                      const Color.fromARGB(153, 38, 55, 86))),
                        ]),
                    BarChartGroupData(
                        x: (graphList2.dataList![4].dayOfWeek),
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              //toY: 20,
                              toY: graphList2.dataList![4].totalMinutes
                                  .toDouble(),
                              width: 25,
                              color: const Color.fromARGB(255, 27, 40, 62),
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: graphList2.dataList![0].totalMinutes
                                      .toDouble(),
                                  color:
                                      const Color.fromARGB(153, 38, 55, 86))),
                        ]),
                    BarChartGroupData(
                        x: (graphList2.dataList![5].dayOfWeek),
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              //toY: 20,
                              toY: graphList2.dataList![5].totalMinutes
                                  .toDouble(),
                              width: 25,
                              color: const Color.fromARGB(255, 27, 40, 62),
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: graphList2.dataList![0].totalMinutes
                                      .toDouble(),
                                  color:
                                      const Color.fromARGB(153, 38, 55, 86))),
                        ]),
                    BarChartGroupData(
                        x: (graphList2.dataList![6].dayOfWeek),
                        barRods: [
                          BarChartRodData(
                              fromY: 0,
                              //toY: 20,
                              toY: graphList2.dataList![6].totalMinutes
                                  .toDouble(),
                              width: 25,
                              color: const Color.fromARGB(255, 27, 40, 62),
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: graphList2.dataList![0].totalMinutes
                                      .toDouble(),
                                  color:
                                      const Color.fromARGB(153, 38, 55, 86))),
                        ]),
                    /* BarChartGroupData(x: graphList2.dataList![0].dayOfWeek, barRods: [
                      BarChartRodData(
                          toY: graphList2.dataList![0].totalMinutes.toDouble(),
                          width: 15,
                          color: Colors.amber)
                    ]),
                    BarChartGroupData(x: graphList2.dataList![1].dayOfWeek, barRods: [
                      BarChartRodData(
                          toY: graphList2.dataList![1].totalMinutes.toDouble(),
                          width: 15,
                          color: Colors.amber)
                    ]),
                    BarChartGroupData(x: graphList2.dataList![2].dayOfWeek, barRods: [
                      BarChartRodData(
                          toY: graphList2.dataList![2].totalMinutes.toDouble(),
                          width: 15,
                          color: Colors.amber)
                    ]),
                    BarChartGroupData(x: graphList2.dataList![3].dayOfWeek, barRods: [
                      BarChartRodData(
                          toY: graphList2.dataList![3].totalMinutes.toDouble(),
                          width: 15,
                          color: Colors.amber)
                    ]),
                    BarChartGroupData(x: graphList2.dataList![4].dayOfWeek, barRods: [
                      BarChartRodData(
                          toY: graphList2.dataList![4].totalMinutes.toDouble(),
                          width: 15,
                          color: Colors.amber)
                    ]),
                    BarChartGroupData(x: graphList2.dataList![5].dayOfWeek, barRods: [
                      BarChartRodData(
                          toY: graphList2.dataList![5].totalMinutes.toDouble(),
                          width: 15,
                          color: Colors.amber)
                    ]),
                    */

                    /* BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                          fromY: 0, toY: 10, width: 15, color: Colors.amber),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                          fromY: 0, toY: 10, width: 15, color: Colors.amber),
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(
                          fromY: 0, toY: 15, width: 15, color: Colors.amber),
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(
                          fromY: 0, toY: 10, width: 15, color: Colors.amber),
                    ]),
                    BarChartGroupData(x: 5, barRods: [
                      BarChartRodData(
                          fromY: 0, toY: 11, width: 15, color: Colors.amber),
                    ]),
                    BarChartGroupData(x: 6, barRods: [
                      BarChartRodData(
                          fromY: 0, toY: 10, width: 15, color: Colors.amber),
                    ]),
                    BarChartGroupData(x: 7, barRods: [
                      BarChartRodData(
                          fromY: 0, toY: 10, width: 15, color: Colors.amber),
                    ]),
                    BarChartGroupData(x: 8, barRods: [
                      BarChartRodData(
                          fromY: 0, toY: 10, width: 15, color: Colors.amber),
                    ]),*/
                  ])),
            ),
          ),
        ),
      ),
    );
  }

//tried to create function to put string instead of 1 ,2,3 but didnt work
  /*String dayOfWeek(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "Invalid day";
    }
  }*/
}

Widget getBottomTitles(double dayNumber, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  switch (dayNumber.toInt()) {
    case 1:
      text = const Text('M', style: style);
      break;
    //return "M";
    case 2:
      //return "T";
      text = const Text('T', style: style);
      break;

    case 3:
      // return "W";
      text = const Text('W', style: style);
      break;

    case 4:
      //return "T";
      text = const Text('T', style: style);
      break;

    case 5:
      //return "F";
      text = const Text('F', style: style);
      break;

    case 6:
      // return "S";
      text = const Text('S', style: style);
      break;

    case 7:
      //return "S";
      text = const Text('S', style: style);
      break;

    default:
      text = const Text('', style: style);
      break;

    // return "Invalid day";
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
