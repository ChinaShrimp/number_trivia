import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INPUT_FAILURE_MESSAGE =
    'Input Error - input number must be positive or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getTriviaForConcreteNumber;
  final GetRandomNumberTrivia getTriviaForRandomNumber;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
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
      }, (number) async* {
        yield Loading();

        final result = await getTriviaForConcreteNumber(
            GetConcreteNumberTriviaParams(number: number));

        yield result.fold((failure) {
          return Error(message: _mapFailureToString(failure));
        }, (trivia) {
          return Loaded(trivia: trivia);
        });
      });
    }

    if (event is GetTriviaForRandomNumber) {
      yield Loading();

      final result = await getTriviaForRandomNumber(NoParams());

      yield result.fold((failure) {
        return Error(message: _mapFailureToString(failure));
      }, (trivia) {
        return Loaded(trivia: trivia);
      });
    }
  }

  String _mapFailureToString(failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;

      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;

      default:
        return 'Unexpected error';
    }
  }
}
