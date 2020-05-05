import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    final jsonString = json.encode(triviaToCache.toJson());

    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final cachedTrivia = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (cachedTrivia == null) {
      throw CacheException();
    }

    return Future.value(NumberTriviaModel.fromJson(json.decode(cachedTrivia)));
  }
}
