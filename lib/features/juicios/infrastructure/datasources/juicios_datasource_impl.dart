
import 'package:dio/dio.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/juicios/domain/datasources/juicios_datasources.dart';
import 'package:myntora_app/features/juicios/domain/entities/juicio.dart';
import 'package:myntora_app/features/juicios/infrastructure/mappers/juicios_mapper.dart';

class JuiciosDatasourceImpl implements JuiciosDatasources{

  final dio = Dio( BaseOptions( baseUrl: Environment.apiUrl ) );

  @override
  Future<Juicio> getAprendizById(int id, String token) async{

    try {
      
      final response = await dio.get('/myntora/juicios/$id', options: Options( headers: { 'x-token': token } ));
      return JuiciosMapper.juicioToEntity( response.data['juicios'] );

    } on DioException catch(e) {
      if( e.response?.statusCode == 401 ){
        throw CustomError('No autorizado para hacer esta accion (token)');
      }
      if( e.response?.statusCode == 400 ){
        throw CustomError('No existe ficha con ese id');
      }
      throw Exception("Error: $e");
    } catch (e) {
      throw Exception("Error: $e");
      
    }

  }

}