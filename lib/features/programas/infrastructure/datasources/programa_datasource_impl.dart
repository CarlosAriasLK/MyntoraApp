

import 'package:dio/dio.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/programas/domain/datasources/programa_datasource.dart';
import 'package:myntora_app/features/programas/domain/entities/programa.dart';
import 'package:myntora_app/features/programas/infrastructure/mappers/programas_mapper.dart';

class ProgramaDatasourceImpl extends ProgramaDatasource {
  
  final dio = Dio( BaseOptions( baseUrl: Environment.apiUrl ) );
  
  @override
  Future<List<Programa>> getProgramas( String token ) async{
    
    try {
      final response = await dio.get('/myntora/programas',
        options: Options(
          headers: {
            'x-token': token,
          }
        )
      );

      final programas = ProgramasMapper.jsonListToEntity( response.data['programas'] );

      return programas;

    } on DioException catch (e) {
      if( e.response?.statusCode == 401 ){
        CustomError('Token no valido');
      }
      throw Exception();
    }

  }
  
}