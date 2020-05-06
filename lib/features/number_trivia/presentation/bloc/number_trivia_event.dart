part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumber implements NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString);

  @override
  List get props => null;
}

class GetTriviaForRandomNumber implements NumberTriviaEvent {
  @override
  // TODO: implement props
  List get props => null;
}
