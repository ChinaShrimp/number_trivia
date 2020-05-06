import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  void setupMockHttpResponseSucess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpResponseFailure403() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Unauthorized', 403));
  }

  group('getConcreteNumberTrivia', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should visit remote endpoint with correct url and application 
      header when getting concrete number trivia''', () async {
      // arrange
      setupMockHttpResponseSucess200();

      // act
      await dataSourceImpl.getConcreteNumberTrivia(tNumber);

      // assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('''should return data when status code is 200''', () async {
      // arrange
      setupMockHttpResponseSucess200();

      // act
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('''should throws ServerException when status code is not 200''',
        () async {
      // arrange
      setupMockHttpResponseFailure403();

      // act
      final call = dataSourceImpl.getConcreteNumberTrivia;

      // assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should visit remote endpoint with correct url and application 
      header when getting random number trivia''', () async {
      // arrange
      setupMockHttpResponseSucess200();

      // act
      await dataSourceImpl.getRandomNumberTrivia();

      // assert
      verify(mockHttpClient.get('http://numbersapi.com/random', headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('''should return data when status code is 200''', () async {
      // arrange
      setupMockHttpResponseSucess200();

      // act
      final result = await dataSourceImpl.getRandomNumberTrivia();

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('''should throws ServerException when status code is not 200''',
        () async {
      // arrange
      setupMockHttpResponseFailure403();

      // act
      final call = dataSourceImpl.getRandomNumberTrivia;

      // assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
