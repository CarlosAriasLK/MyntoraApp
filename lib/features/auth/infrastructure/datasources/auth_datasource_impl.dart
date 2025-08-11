

import 'package:dio/dio.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/features/auth/domain/domain.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthDatasourceImpl extends AuthDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );


  @override
  Future<User> login(String email, String password) async{
    
    try {
      final response = await dio.post('/auth/login', data: {
          'correo_institucional': email,
          'password': password
        }
      );

      final user = UserMapper.responseToEntity( response.data['login'] );
      return user;

    } on DioException catch (e) {
      if( e.response?.statusCode == 500 ){
        throw CustomError( e.response?.data['ERROR'] );
      }
      throw Exception();
    }
  }

  @override
  Future<User> checkLogin(String token) async{
    
    try {
      
      final response = await dio.get('/auth/renew',
        options: Options(
          headers: {
            'x-token': token
          }
        )
      );
      
      final user = UserMapper.responseToEntity( response.data['resultadoValidacion'] );
      return user;

    } catch (e) {
      throw Exception(e);
    }

  }

}