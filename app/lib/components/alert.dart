import "package:flutter/material.dart";
import 'package:save_your_ass/constant.dart';

class AlertMessage extends StatelessWidget {
  final String title;
  final String message;

  AlertMessage({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK",
          style: TextStyle(
            color: Color(0xffb0d1aa),
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 25,
        color: Colors.black87,
      ),
      contentTextStyle: const TextStyle(
        color: Colors.black87,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    return alert;
  }
}

class ModifyUserAlert extends StatefulWidget {
  final String title;
  final onPress;
  final int oriValue;
  late int valueText;

  ModifyUserAlert(
      {required this.title, required this.onPress, required this.oriValue}) {
    valueText = oriValue;
  }

  @override
  State<ModifyUserAlert> createState() => _ModifyUserAlertState();
}

class _ModifyUserAlertState extends State<ModifyUserAlert> {
  @override
  Widget build(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK",
          style: TextStyle(
            color: Color(0xffb0d1aa),
          )),
      onPressed: () {
        widget.onPress(widget.valueText);
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 25,
        color: Colors.black87,
      ),
      contentTextStyle: const TextStyle(
        color: Colors.black87,
      ),
      title: Text("Update ${widget.title}"),
      content: TextField(
        onChanged: (value) {
          setState(() {
            widget.valueText = int.tryParse(value) ?? widget.oriValue;
          });
        },
        style: const TextStyle(color: Colors.black),
        decoration: kUpdateFieldDecoration.copyWith(
          hintText: "Input your ${widget.title}",
        ),
      ),
      actions: [
        okButton,
      ],
    );

    return alert;
  }
}
