

import 'package:myntora_app/features/auth/domain/domain.dart';
import 'package:myntora_app/features/auth/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthDatasource datasource;

  AuthRepositoryImpl({
    AuthDatasource? datasource
  }): datasource = datasource ?? AuthDatasourceImpl();
  

  @override
  Future<User> checkLogin(String token) {
    return datasource.checkLogin(token);
  }

  @override
  Future<User> login(String email, String password) {
    return datasource.login(email, password);
  }
  
  @override
  Future<void> changePasword(String token, String newPassword) {
    return datasource.changePasword(token, newPassword);
  }

}