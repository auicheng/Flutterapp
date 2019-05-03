
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'const.dart';
import 'audio.dart';
import 'data_model.dart';



class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withSampleData(List<OrdinalGender> datag) {

    return new HorizontalBarChart(
      _createSampleData(datag),
      animate: false,
    );
  }

  @override
    // For horizontal bar charts, set the [vertical] flag to false.
    Widget build(context){
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalGender, String>> _createSampleData(List<OrdinalGender> datag) {
     final data = datag;

    return [
      new charts.Series<OrdinalGender, String>(
        id: 'Gender',
        domainFn: (OrdinalGender sex, _) => sex.gender,
        measureFn: (OrdinalGender sex, _) => sex.pob,
        data: datag,
      )
    ];
  }
}

