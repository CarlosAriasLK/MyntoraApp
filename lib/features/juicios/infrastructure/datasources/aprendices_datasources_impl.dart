

import 'package:dio/dio.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/features/juicios/domain/datasources/aprendices_datasources.dart';
import 'package:myntora_app/features/juicios/domain/entities/aprendiz.dart';
import 'package:myntora_app/features/juicios/infrastructure/mappers/aprendiz_mapper.dart';
import 'package:myntora_app/features/shared/infrastructure/errors/errors.dart';

class AprendicesDatasourcesImpl implements AprendicesDatasources {

  final dio = Dio( BaseOptions( baseUrl: Environment.apiUrl ) );

  @override
  Future<List<Aprendiz>> getAllAprendices(int idFicha, String token) async{
    try {

      final response = await dio.get( '/myntora/aprendices/$idFicha', 
        options: Options( 
          headers: {
            'x-token': token
          }  
        )
      );

      final List aprendicesResponse = response.data['aprendices'];
      return aprendicesResponse.map( (aprendiz) => AprendizMapper.toEntity( aprendiz ) ).toList();

    } on DioException catch(e) {

      if( e.response?.statusCode == 404 ) {
        throw CustomError('Aprendices no encontrados');
      }
      if( e.response?.statusCode == 401 ) {
        throw CustomError('Token no valido');
      }
      throw Exception('Error: $e');

    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<Aprendiz> getAprendizById(int id, String token) {
    // TODO: implement getAprendizById
    throw UnimplementedError();
  }
  
}