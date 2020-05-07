import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25),
      ),
    ));
  }
}
