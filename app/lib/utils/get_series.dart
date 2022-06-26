import 'package:charts_flutter/flutter.dart' as charts;
import 'package:save_your_ass/model/sit.dart';
import 'package:save_your_ass/model/sit_type.dart';

List<charts.Series<Sit, String>>? getSeriesData(List<Sit> data) {
  List<charts.Series<Sit, String>> series = [
    charts.Series(
        id: "Sit",
        data: data,
        domainFn: (Sit grades, _) => grades.type,
        measureFn: (Sit grades, _) => grades.hour,
        colorFn: (Sit grades, _) => grades.color)
  ];
  return series;
}

List<charts.Series<SitType, String>>? getBarData(List<SitType> data) {
  List<charts.Series<SitType, String>> series = [
    charts.Series(
        id: "Past",
        data: data,
        domainFn: (SitType sitInfo, _) => sitInfo.typeName,
        measureFn: (SitType sitInfo, _) => sitInfo.percent,
        labelAccessorFn: (SitType sitInfo, _) => sitInfo.percent.toString(),
        colorFn: (SitType sitInfo, _) =>
        const charts.Color(r: 118, g: 186, b: 153)),
  ];
  return series;
}
