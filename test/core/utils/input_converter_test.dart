import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

void main() {
  InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an integer when providing an integer string', () async {
      // act
      final result = converter.stringToUnsignedInteger('123');

      // assert
      expect(result, Right(123));
    });

    test(
        'should return an InvalidInputFailure when providing an invalid string',
        () async {
      // act
      final result = converter.stringToUnsignedInteger('abc');

      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test(
        'should return an InvalidInputFailure when providing a negative integer string',
        () async {
      // act
      final result = converter.stringToUnsignedInteger('-123');

      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
