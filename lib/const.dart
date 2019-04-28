import 'package:flutter/material.dart';

const YELLOW = Color(0xfffbed96);
const BLUE = Color(0xffabecd6);

const LinearGradient BACKGROUND = LinearGradient(
  begin: FractionalOffset(0.0, 0.4), end: FractionalOffset(0.9, 0.7),
  // Add one stop for each color. Stops should increase from 0 to 1
  stops: [0.1, 0.9], colors: [YELLOW, BLUE],
);