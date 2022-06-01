import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  final String content;
  const CenterText({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        content,
        textAlign: TextAlign.center,
      ),
    );
  }
}
