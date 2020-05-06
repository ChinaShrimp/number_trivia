import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INPUT_FAILURE_MESSAGE =
    'Input Error - input number must be positive or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetTriviaForConcreteNumber getTriviaForConcreteNumber;
  final GetTriviaForRandomNumber getTriviaForRandomNumber;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetTriviaForConcreteNumber concrete,
      @required GetTriviaForRandomNumber random,
      @required this.inputConverter})
      : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getTriviaForConcreteNumber = concrete,
        getTriviaForRandomNumber = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final either = inputConverter.stringToUnsignedInteger(event.numberString);

      yield* either.fold((failure) async* {
        yield Error(message: INPUT_FAILURE_MESSAGE);
      }, (number) {
        throw UnimplementedError();
      });
    }
  }
}
