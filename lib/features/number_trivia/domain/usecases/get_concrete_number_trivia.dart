import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia
    implements UseCase<NumberTrivia, GetConcreteNumberTriviaParams> {
  final NumberTriviaRepository respository;

  GetConcreteNumberTrivia(this.respository);

  @override
  Future<Either<Failure, NumberTrivia>> call(
      GetConcreteNumberTriviaParams params) async {
    return await respository.getConcreteNumberTrivia(params.number);
  }
}

class GetConcreteNumberTriviaParams extends Equatable {
  final int number;

  GetConcreteNumberTriviaParams({@required this.number}) : super([number]);
}
