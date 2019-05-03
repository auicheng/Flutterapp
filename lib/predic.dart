import 'package:flutter/material.dart';
import 'const.dart';
import 'data_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'audio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class Pagethree extends StatelessWidget{
  final List<OrdinalGender> datag;

  Pagethree(this.datag);

  Widget build(context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 34.0,left: 23.0),
        decoration: BoxDecoration(gradient: BACKGROUND),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 28.0),
              child: Row(
                  children: <Widget>[
                    Image.asset('assets/pics/science-technology-10-512.png',
                      width: 75.0,
                      height: 75.0,
                    ),
                    Container(margin: EdgeInsets.only(left: 15.0)),
                    Text(
                      'Am I right?',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          letterSpacing: 4,
                          fontSize: 30.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ]
              ),
            ),
            Container(margin: EdgeInsets.only(top: 25.0)),
            Container(
              constraints: BoxConstraints(
                    maxHeight: 300.0,
                    maxWidth: 200.0,
                    minWidth: 150.0,
                    minHeight: 150.0
                ),
              child: datag == null
                ?  Center(
                child: SpinKitWave(
                    color: Colors.black87.withOpacity(0.7),
                    type: SpinKitWaveType.start),
              )
                  :new HorizontalBarChart.withSampleData(datag),
            ),
            ButtonWidget(context),
          ],
        ),
      ),
    );
  }
}


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


Widget ButtonWidget(context) {
  return Container(
    margin: EdgeInsets.only(left: 32.0, top: 52.0),
    child: Row(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PageTwo()
              ),
            );
          },
          child:
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 56.0, vertical: 16.0),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        spreadRadius: 0,
                        offset: Offset(0.0, 26.0)),
                  ],
                  borderRadius: new BorderRadius.circular(36.0),
                  gradient: LinearGradient(begin: FractionalOffset.centerLeft,
// Add one stop for each color. Stops should increase from 0 to 1
                      stops: [
                        0.2,
                        1
                      ], colors: [
                        Color(0xff000000),
                        Color(0xff434343),
                      ])),
              child: Text(
                'Retry',
                style: TextStyle(
                    color: Color(0xffF1EA94),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),)
      ],
    ),
  );
}
