import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('should be subclass of NumberTrivia', () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from json', () {
    test('should return a valid model when json number is an integer',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when json number is an double', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('to json', () {
    test('should return json map containing proper data', () async {
      // act
      final result = tNumberTriviaModel.toJson();

      // assert
      final expectedMap = {
        "text": "Test text",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}
