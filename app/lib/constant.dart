import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.black45),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.black45, fontSize: 20),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black54, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kUpdateFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.black45, fontSize: 20),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black54, width: 1.0),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 2.0),
  ),
);

const kNameTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.black87,
  fontFamily: "MonBold"
);

const kLabelStyle = TextStyle(
    color: Colors.black87,
    fontFamily: "MonRegular"
);

const kNumStyle = TextStyle(
    color: Colors.black87,
    fontFamily: "MonBold"
);

const kCommentStyle = TextStyle(
    color: Colors.black87,
    fontFamily: "MonBold",
    fontSize: 30.0
);

const kSubTitleStyle = TextStyle(
    color: Colors.black87,
    fontFamily: "MonRegular",
    fontSize: 20.0
);

const Map<int, String> scoreMap = {
  0: "Bad 😢",    // 0 ~ 0.25
  1: "Ok 👌",     // 0.25 ~ 0.5
  2: "Good 👍",   // 0.5 ~ 0.75
  3: "Great ⭐️",  // 0.75 ~ 1
  4: "New user",
  5: "New day",
  6: "Error 😫"
};

const List<String> sitNames = [
  "straight",
  "reclining",
  "left",
  "right",
  "cross-left",
  "cross-right"
];