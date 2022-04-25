import 'package:flutter_test/flutter_test.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tdd_flutter/domain/helpers/helpers.dart';
import 'package:tdd_flutter/domain/usecases/usecases.dart';

import 'package:tdd_flutter/data/http/http.dart';
import 'package:tdd_flutter/data/usecases/usecase.dart';


class HttpClientSpy extends Mock implements HttpClient{} 

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

  setUp((){
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    params = AuthenticationParams(user: faker.internet.email(), secret: faker.internet.password());
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test("Should call HttpClient with correct values", () async {
    await sut.auth(params);
    verify(() => httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.user,
        'password': params.secret
      },
    ));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method'), body: any(named: 'body')))
    .thenThrow(HttpError.badRequest);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method'), body: any(named: 'body')))
    .thenThrow(HttpError.notFound);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 500", () async {
    when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method'), body: any(named: 'body')))
    .thenThrow(HttpError.serverError);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });
}