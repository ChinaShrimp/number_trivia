import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetTriviaForConcreteNumber extends Mock
    implements GetTriviaForConcreteNumber {}

class MockGetTriviaForRandomNumber extends Mock
    implements GetTriviaForRandomNumber {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetTriviaForConcreteNumber mockGetTriviaForConcreteNumber;
  MockGetTriviaForRandomNumber mockGetTriviaForRandomNumber;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc bloc;

  setUp(() {
    mockGetTriviaForConcreteNumber = MockGetTriviaForConcreteNumber();
    mockGetTriviaForRandomNumber = MockGetTriviaForRandomNumber();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetTriviaForConcreteNumber,
        random: mockGetTriviaForRandomNumber,
        inputConverter: mockInputConverter);
  });

  test('should return [Empty] as the initial state', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final int tNumber = 1;
    final String tNumberString = '1';
    final NumberTrivia tNumberTrivia =
        NumberTrivia(number: tNumber, text: 'test trivia');

    test('should call InputConverter to get unsigned int from input string',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should return [Error] when providing an invalid input', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [Empty(), Error(message: INPUT_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber('aaa'));
    });
  });
}
