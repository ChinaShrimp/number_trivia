import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetTriviaForConcreteNumber;
  MockGetRandomNumberTrivia mockGetTriviaForRandomNumber;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc bloc;

  setUp(() {
    mockGetTriviaForConcreteNumber = MockGetConcreteNumberTrivia();
    mockGetTriviaForRandomNumber = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetTriviaForConcreteNumber,
        random: mockGetTriviaForRandomNumber,
        inputConverter: mockInputConverter);
  });

  test('should return [Empty] as the initial state', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetConcreteNumberTrivia', () {
    final int tNumber = 1;
    final String tNumberString = '1';
    final NumberTrivia tNumberTrivia =
        NumberTrivia(number: tNumber, text: 'test trivia');

    void setUpInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumber));

    test('should call InputConverter to get unsigned int from input string',
        () async {
      // arrange
      setUpInputConverterSuccess();

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

    test('should call GetTriviaForConcreteNumber use case to retrieve trivia',
        () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetTriviaForConcreteNumber(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber('1'));

      await untilCalled(mockGetTriviaForConcreteNumber(any));
      // assert
      verify(mockGetTriviaForConcreteNumber(
          GetConcreteNumberTriviaParams(number: 1)));
    });

    test(
        'should get trivia when successfully retrieving data from remote endpoint',
        () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetTriviaForConcreteNumber(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber('1'));
    });

    test(
        'should get [Error] when failed to retrieving data from remote endpoint',
        () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetTriviaForConcreteNumber(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber('1'));
    });

    test('should get [Error] when failed to retrieving data from the cache',
        () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetTriviaForConcreteNumber(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber('1'));
    });
  });

  group('GetRandomNumberTrivia', () {
    final int tNumber = 1;
    final String tNumberString = '1';
    final NumberTrivia tNumberTrivia =
        NumberTrivia(number: tNumber, text: 'test trivia');

    test('should call GetRandomNumberTrivia use case to retrieve trivia',
        () async {
      // arrange
      when(mockGetTriviaForRandomNumber(NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.dispatch(GetTriviaForRandomNumber());

      await untilCalled(mockGetTriviaForRandomNumber(NoParams()));
      // assert
      verify(mockGetTriviaForRandomNumber(NoParams()));
    });

    test(
        'should get trivia when successfully retrieving data from remote endpoint',
        () async {
      // arrange
      when(mockGetTriviaForRandomNumber(NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test(
        'should get [Error] when failed to retrieving data from remote endpoint',
        () async {
      // arrange
      when(mockGetTriviaForRandomNumber(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test('should get [Error] when failed to retrieving data from the cache',
        () async {
      // arrange
      when(mockGetTriviaForRandomNumber(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });
  });
}
