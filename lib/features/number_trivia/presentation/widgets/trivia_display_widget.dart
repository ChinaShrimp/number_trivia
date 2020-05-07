import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplayWidget extends StatelessWidget {
  final NumberTrivia trivia;

  const TriviaDisplayWidget({@required this.trivia});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            trivia.number.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
              child: Text(
            trivia.text,
            style: TextStyle(fontSize: 25),
          ))
        ],
      ),
    );
  }
}
