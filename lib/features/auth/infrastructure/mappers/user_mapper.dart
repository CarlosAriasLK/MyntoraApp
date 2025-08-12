


import 'package:myntora_app/features/auth/domain/entities/user.dart';

class UserMapper {

  static User responseToEntity( Map<String, dynamic> response ) => User(
    uid: response['uid'], 
    nombre: response['nombre'], 
    rol: response['rol'], 
    token: response['token'], 
    debeCambiarPassword: response['debeCambiarPassword'] ?? false,
  );

}