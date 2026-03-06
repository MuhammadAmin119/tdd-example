import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final String code;
  final String errorCode;

  const Failure({this.message = '', this.code = '',this.errorCode=''});

  @override
  List<Object> get props => [
    errorCode,code
  ];
}

class ServerFailure extends Failure {
  final num statusCode;
  final String errorMessage;


  ServerFailure({this.errorMessage = '', this.statusCode = 0,super.errorCode=''})
      : super(message: errorMessage, code: statusCode.toString(),);
}

class DioFailure extends Failure {
  final String? errorMessage;
  final bool? exists;
  final String errorCode;

  const DioFailure({this.errorMessage, this.exists,this.errorCode=''})
      : super(message: errorMessage ?? '',errorCode: errorCode);
}

class ParsingFailure extends Failure {
  final String? errorMessage;

  const ParsingFailure({this.errorMessage = ''})
      : super(message: errorMessage ?? '');
}

class IOFailure extends Failure {
  final String errorMessage;

  const IOFailure({this.errorMessage = ''})
      : super(message: errorMessage ?? '');
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
class QueryFailure extends Failure {

  const QueryFailure({required super.message});
}