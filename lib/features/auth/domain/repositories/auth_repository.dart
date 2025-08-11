

import 'package:myntora_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {

  Future<User> login( String email, String password );

  Future<User> checkLogin( String token );

}