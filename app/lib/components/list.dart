import "package:flutter/material.dart";
import 'package:save_your_ass/constant.dart';

class ListLabel extends StatelessWidget {
  final String title;
  final String trailing;

  ListLabel({required this.title, required this.trailing});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: kLabelStyle),
        SizedBox(
          width: 10,
        ),
        Text(trailing, style: kNumStyle,)
      ],
    );
  }
}
