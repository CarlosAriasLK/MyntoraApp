

import 'dart:io';

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

      return ProgramasMapper.jsonListToEntity( response.data['programas'] );

    } on DioException catch (e) {
      if( e.response?.statusCode == 401 ){
        throw CustomError('No permitido');
      }
      throw Exception("Error: $e");
    } catch (e) {
      throw Exception("Error: $e");
    }

  }
  
  @override
  Future<void> createPrograma(String token, String nombrePrograma, String nivelPrograma, File competenciasyresultados ) async{
    try {

      final formData = FormData.fromMap({
        'nombre_programa': nombrePrograma,
        'nivel': nivelPrograma,
        'competenciasyresultados': await MultipartFile.fromFile(
          competenciasyresultados.path,
          filename: competenciasyresultados.path.split('/').last,
        ),
      });
      
      await dio.post('/myntora/nuevoprograma', 
        data: formData,
        options: Options(
          headers: {
            'x-token': token,
            'Content-Type': 'multipart/form-data'
          }
        )
      );

    } on DioException catch(e) {
      if( e.response?.statusCode == 400) {
        throw CustomError('Datos invalidos');
      }
      if( e.response?.statusCode == 401 ){
        throw CustomError('No permitido');
      }
      throw Exception("Error: $e");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
  
  @override
  Future<Programa> updateProgramas(String token, Programa programa) async{
    
    try {

      final response = await dio.put('/myntora/actualizarprograma/${programa.id}',
        data: {
          "nombre_programa": programa.nombre,
          "nivel": programa.nivel,
          "estado": programa.estado
        },
        options: Options(
          headers: {
            "x-token": token
          }
        )
      );

      return ProgramasMapper.jsonToEntity( response.data['programaActualizado']['programa'] );

    } on DioException catch(e) {
      if( e.response?.statusCode == 400 ){
        throw CustomError('Programa no encontrado');
      }
      if( e.response?.statusCode == 401 ){
        throw CustomError('No autorizado (token)');
      }
      throw Exception('Error: $e');
    } catch (e) {
      throw Exception('Error: $e');
      
    }


  }
  
}