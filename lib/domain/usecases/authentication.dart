import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String user;
  final String secret;

  AuthenticationParams({
    required this.user,
    required this.secret
  });

  Map toJson() => {'email': user, 'password': secret};
}