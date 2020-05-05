import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends Equatable {
  final NumberTriviaRepository respository;

  GetConcreteNumberTrivia(this.respository);

  Future<Either<Failure, NumberTrivia>> execute({@required int number}) async {
    return await respository.getConcreteNumberTrivia(number);
  }
}
