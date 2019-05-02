import 'dart:io' as io;
import 'dart:math';
import 'dart:async';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:audio_recorder2/audio_recorder2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import 'const.dart';
import 'animation.dart';
import 'data_model.dart';
import 'dart:convert';

import 'package:dio/dio.dart';



class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => new _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: BoxDecoration(gradient: BACKGROUND),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0,left: 32.0),
              child: 
                Text(
                'Record your voice and \n press Predict button.',
                textAlign: TextAlign.left,
                style: TextStyle(
                letterSpacing: 4,
                fontSize: 24.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
                ),
            ),
            Container(margin: EdgeInsets.only(top: 65.0)),
            new AppBody(),
          ],
          //   Container(margin: EdgeInsets.only(top: 25.0)),
          //   Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //       _buildRecordingStatus(),
          //       _buildTimerText(),
          //       _buildButtonRow(context),
          //       ButtonWidget(context),
          //     new Text("File path of the record: ${_recording.path}"),
          //     new Text("Format: ${_recording.audioOutputFormat}"),
          //     new Text("Extension : ${_recording.extension}"),
          //     new Text(
          //         "Audio recording duration : ${_recording.duration.toString()}")
          //     ],
          //   ),
          // ],
        ),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AppBody({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new AppBodyState();
}

class AppBodyState extends State<AppBody> {
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();
  Stopwatch stopwatch = Stopwatch();
  List<OrdinalGender> dataforgender = [];

  void predict() async{ 
       var dio = new Dio(BaseOptions(connectTimeout: 5000));
        dio.interceptors.add(LogInterceptor(responseBody: true));

      var audioFile = new io.File("${_recording.path}");

      // var body = json.encode(value)
      // var response = await client
      //   .post(
      //     'url'
      //   ).whenComplete(client.close);

      var response = await dio.post(
        "url",
        data: audioFile.openRead(),
      );
        // if(!mounted)
      var ordinalgender = OrdinalGender.fromJson(json.decode(response.data));

      setState(() {
        dataforgender.add(ordinalgender);
      });

  }

  @override
  Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  _buildRecordingStatus(),
                  _buildTimerText(), ],
              ),
              Row(children: <Widget>[
              Container(
                width: size.width * 0.5,
                alignment: Alignment.center,
                child: FlatButton(
                onPressed: _isRecording ? null : _start,
                child: new Text("Start",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                    ),  
                ),
                color: Colors.green,
              ) ,
              ),
              new FlatButton(
                onPressed: _isRecording ? _stop : null,
                child: new Text("Stop",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),  
                ),
                color: Colors.red,
              ),
              ],),
              // new RaisedButton(
              //    onPressed: () => {
              //         Navigator.push(context,
              //               MaterialPageRoute(
              //               builder: (BuildContext context) => new HorizontalBarChart.withSampleData(dataforgender)
              //       ),)
              //    },
              // )
              ButtonWidget(context, dataforgender,predict),
              // new TextField(
              //   controller: _controller,
              //   decoration: new InputDecoration(
              //     hintText: 'Enter a custom path',
              //   ),
              // ),
              // new Text("File path of the record: ${_recording.path}"),
              // new Text("Format: ${_recording.audioOutputFormat}"),
              // new Text("Extension : ${_recording.extension}"),
              // new Text(
              //     "Audio recording duration : ${_recording.duration.toString()}")
            ]),
      ),
    );
  }


  Widget _buildTimerText() {
    return Container(
        height: 200.0,
        child: Center(
          child: TimerText(stopwatch: stopwatch),
        ));
  }

    Widget _buildRecordingStatus() {
    return Container(
        height: 100.0,
        width: 100.0,
        child: stopwatch.isRunning
            ? Center(
                child: SpinKitWave(
                    color: Colors.black87.withOpacity(0.7),
                    type: SpinKitWaveType.start),
              )
            : Image.asset("assets/pics/recorder.png"));
  }

  _start() async {
    try {
      if (await AudioRecorder2.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = _controller.text;
          if (!_controller.text.contains('/')) {
            io.Directory appDocDirectory =
            await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _controller.text;
          }
          print("Start recording: $path");
          await AudioRecorder2.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          await AudioRecorder2.start();
        }
        bool isRecording = await AudioRecorder2.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;

          if (!stopwatch.isRunning) {
            stopwatch.start();
          }
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder2.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder2.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;

      if (stopwatch.isRunning) {
            stopwatch.stop();
      }
    });
    _controller.text = recording.path;
  }

}

Widget ButtonWidget(context,dataforgender,callback) {
  return Container(
    margin: EdgeInsets.only(left: 55.0, top: 22.0),
    child: Row(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            callback;
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => new HorizontalBarChart.withSampleData(dataforgender)
                    ),
            );                  
          },
          child:         
          InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 95.0, vertical: 16.0),
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
              'Predict',
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


class TimerText extends StatefulWidget {
  TimerText({this.stopwatch});
  final Stopwatch stopwatch;

  TimerTextState createState() => TimerTextState(stopwatch: stopwatch);
}

class TimerTextState extends State<TimerText> {
  Timer timer;
  final Stopwatch stopwatch;

  TimerTextState({this.stopwatch}) {
    timer = Timer.periodic(Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final TextStyle timerTextStyle = const TextStyle(
      fontSize: 60.0,
      fontFamily: "Open Sans",
      fontWeight: FontWeight.w300,
      color: Colors.black87,
    );
    List<String> formattedTime =
        TimerTextFormatter.format(stopwatch.elapsedMilliseconds);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Container(
        //   child: Text(
        //     "${formattedTime[0]}:",
        //     style: timerTextStyle,
        //   ),
        //   width: width / 4.0,
        // ),
        Container(
          child: Text(
            "${formattedTime[1]}:",
            style: timerTextStyle,
          ),
          width: width / 4.1,
        ),
        Container(
          child: Text(
            "${formattedTime[2]}",
            style: timerTextStyle,
          ),
          width: width / 4.6,
        ),
      ],
    );
  }
}

class TimerTextFormatter {
  static List<String> format(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return [minutesStr, secondsStr, hundredsStr];
//    return "$minutesStr:$secondsStr:$hundredsStr";
  }
}






