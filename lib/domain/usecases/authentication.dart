import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required email, required password});
}