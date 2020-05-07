import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widget.dart';

class NumberTriviaPage extends StatefulWidget {
  NumberTriviaPage({Key key}) : super(key: key);

  @override
  _NumberTriviaPageState createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(title: Text('你不知道的数字')),
      body: buildBody(),
    ));
  }

  BlocProvider<NumberTriviaBloc> buildBody() {
    return BlocProvider(
      builder: (_) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            //! top half
            buildNumberTriviaDisplayWidget(context),
            SizedBox(height: 50),
            //! bottom half
            NumberTriviaControlWidget()
          ],
        ),
      ),
    );
  }

  Widget buildNumberTriviaDisplayWidget(context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
          builder: (context, state) {
        if (state is Empty) {
          return MessageDisplay(message: '请输入数字进行搜索或者点击试试手气');
        } else if (state is Loading) {
          return LoadingWidget();
        } else if (state is Loaded) {
          return TriviaDisplayWidget(trivia: state.trivia);
        } else if (state is Error) {
          return MessageDisplay(message: state.message);
        }
        return Placeholder();
      }),
    );
  }
}
