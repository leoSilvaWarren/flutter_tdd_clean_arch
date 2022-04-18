import '../entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required email, required password});
}