import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final jsonString = fixture('trivia_cached.json');
    final jsonMap = json.decode(jsonString);
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonMap);

    test('should return cached data when found last cached trivia', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(jsonString);

      // act
      final result = await dataSourceImpl.getLastNumberTrivia();

      // assert
      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw CacheException when found no cached trivia', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = dataSourceImpl.getLastNumberTrivia;

      // assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');

    test('should call setString with correct key when calling cacheNumberTrivia', 
      () async {
        // act
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

        dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);

        // assert
        verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
      });
  });
}
