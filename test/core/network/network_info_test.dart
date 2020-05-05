import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
        'should forward checking to hasConnection when checking data connection',
        () async {
      // arrange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      // act
      final result = await networkInfoImpl.isConnected;

      // assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, true);
    });

    test('should return false when there is no connection', () async {
      // arrange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);

      // act
      final result = await networkInfoImpl.isConnected;

      // assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, false);
    });
  });
}
