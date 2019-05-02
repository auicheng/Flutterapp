import 'package:flutter/material.dart';
import 'const.dart';
import 'audio.dart';

class Home extends StatelessWidget{
  Widget build(context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 74.0),
        decoration: BoxDecoration(gradient: BACKGROUND),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
          Center(
                  child: Image.asset(
                  'assets/pics/science-technology-10-512.png',
                  width: 135.0,
                  height: 135.0,
                  fit: BoxFit.cover,
                  ),
                ),
            headlinesWidget(),
            ButtonWidget(context),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget headlinesWidget() {
  return Container(
    margin: EdgeInsets.only(left: 48.0, top: 52.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'WELCOME!!',
          textAlign: TextAlign.left,
          style: TextStyle(
              letterSpacing: 4,
              fontSize: 30.0,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 48.0),
          child: Text(
            'I\'ll guess your gender  \nby voice.',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
            ),
          ),
        )
      ],
    ),
  );
}

Widget footer() {
  return Container(
    margin: EdgeInsets.only(right: 18.0, top: 68.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Image.asset('assets/pics/lab.png',
                  width: 45.0,
                  height: 45.0,
        ),
        // Text('production',
        // style: TextStyle(
        //   color: Colors.blueGrey[400],
        //   fontSize: 15,
        // ),
        // )
      ],
    ),
  );
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
              'Get start',
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

}