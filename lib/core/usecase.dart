import 'package:dartz/dartz.dart';

abstract class UseCase<Params> {
  Future<Either> execute({Params params});
}
