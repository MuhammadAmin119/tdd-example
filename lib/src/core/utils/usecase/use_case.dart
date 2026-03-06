import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tdd_example/src/core/utils/either/either.dart';
import 'package:tdd_example/src/core/utils/failure/failure.dart';



abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

class SortNextParams extends Equatable {
  final Map<String, String> sortType;
  final String? next;

  const SortNextParams({required this.next, required this.sortType});

  @override
  List<Object?> get props => [next, sortType];
}

class TypeNextParams extends Equatable {
  final List type;
  final String contentType;
  final String? next;
  final int id;

  const TypeNextParams(
      {required this.next,
      required this.id,
      required this.type,
       this.contentType=''});

  @override
  List<Object?> get props => [
        next,
        type,
        id,
      ];
}