import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation4/TimeMachine.dart';
import 'dart:developer' as developer;
import 'GraphData.dart';

class GraphList {
  List<GraphData>? dataList;

  GraphList() {
    dataList = [
      GraphData(),
      GraphData(),
      GraphData(),
      GraphData(),
      GraphData(),
      GraphData(),
      GraphData(),
    ];
  }

  GraphList.withDate(DateTime start, DateTime end) {
    TimeMachine timeMachine = TimeMachine();
    dataList = [
      GraphData(),
      GraphData(),
      GraphData(),
      GraphData(),
      GraphData(),
      GraphData(),
      GraphData(),
    ];
    var midnightMilis = timeMachine.getMidnightMillisForLast7Days();

    developer.log(midnightMilis.toString(), name: "ALMOST3");
    for (int i = 0; i < 7; i++) {
      dataList?[i].startOfDay = midnightMilis[i];
      dataList?[i].endOfDay = midnightMilis[i] + 1000 * 24 * 60 * 60 - 1;
      dataList?[i].dayOfWeek =
          DateTime.fromMillisecondsSinceEpoch(midnightMilis[i]).weekday;
    }

    dataList?.sort((a, b) => a.startOfDay.compareTo(b.startOfDay));
  }

  static catchAndPopulate(
      Timestamp timestamp, int hours, int min, GraphList graphList) {
    int timeInMillis = timestamp.millisecondsSinceEpoch;
    int i = 0;
    for (i = 0; i < 7; i++) {
      if ((timeInMillis < graphList.dataList![i].endOfDay) &&
          (timeInMillis > graphList.dataList![i].startOfDay)) {
        break;
      }
    }
    graphList.dataList![i].totalMinutes += hours * 60 + min;
  }
}
