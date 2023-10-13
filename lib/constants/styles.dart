import 'package:flutter/material.dart';

import 'colors.dart';

const TextStyle descriptionStyle = TextStyle(
  fontSize: 15,
  color: Colors.black,
  fontWeight: FontWeight.w800,
);
const TextStyle titleStyle =TextStyle(
  color: Colors.white,
   fontSize: 30,
    fontWeight: FontWeight.w800
  );

const textInputDecoration = InputDecoration(
  hintText: "email",
  hintStyle: TextStyle(color: Colors.black, fontSize: 15),
  fillColor: Colors.grey,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
  // set text color to white
  labelStyle: TextStyle(color: Colors.black),
);
