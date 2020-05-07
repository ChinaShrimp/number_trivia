import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class NumberTriviaControlWidget extends StatefulWidget {
  NumberTriviaControlWidget({Key key}) : super(key: key);

  @override
  _NumberTriviaControlWidgetState createState() =>
      _NumberTriviaControlWidgetState();
}

class _NumberTriviaControlWidgetState extends State<NumberTriviaControlWidget> {
  TextEditingController controller = TextEditingController();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '请输入数字',
            ),
            onChanged: (value) {
              setState(() {
                inputStr = value;
              });
            },
            onSubmitted: (_) {
              getConcreteNumberTrivia();
            },
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: getConcreteNumberTrivia,
                  textTheme: ButtonTextTheme.primary,
                  color: Theme.of(context).accentColor,
                  child: Text('搜索'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: RaisedButton(
                onPressed: getRandomNumberTrivia,
                child: Text('试试手气'),
              ))
            ],
          )
        ],
      ),
    );
  }

  void getConcreteNumberTrivia() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .dispatch(GetTriviaForConcreteNumber(inputStr));
  }

  void getRandomNumberTrivia() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .dispatch(GetTriviaForRandomNumber());
  }
}
