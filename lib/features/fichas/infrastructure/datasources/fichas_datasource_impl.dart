

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/infrastructure/mappers/ficha_mapper.dart';
import 'package:myntora_app/features/fichas/infrastructure/mappers/fichas_mapper.dart';

class FichasDatasourceImpl extends FichasDatasource{

  final dio = Dio( BaseOptions( baseUrl: Environment.apiUrl ) );

  @override
  Future<List<Ficha>> getFichas( String token ) async{
    try {
      final response = await dio.get('/myntora/fichas', options: Options(
        headers: {
          'x-token': token
        }
      ));
      final fichas = FichasMapper.jsonListToEntity(response.data['fichas']);
      return fichas;

    } on DioException catch (e) {
      if( e.response?.statusCode == 404 ) {
        CustomError('Error al cargar las fichas');
      }
      throw Exception('Error: $e');
    }

  }

  @override
  Future<Ficha> updateFicha(String token, int idFicha, Ficha nuevaFicha) async{
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    try {
      final response = await dio.put('/myntora/actualizarficha/$idFicha',
          data: {
            "id_programa_formacion": nuevaFicha.idProgramaFormacion,
            "jornada": nuevaFicha.jornada,
            "fecha_inicio": formatter.format(nuevaFicha.fechaInicio),
            "fecha_fin": formatter.format(nuevaFicha.fechaFin),
            "modalidad": nuevaFicha.modalidad,
            "etapa": nuevaFicha.etapa,
            "jefe_ficha": nuevaFicha.jefeFicha,
            "oferta": nuevaFicha.oferta
          },
          options: Options(
              headers: {
                'x-token': token
              }
          )
      );
      print( response.data['fichaActualizada']['ficha'] );
      final ficha = FichaMapper.jsonToEntity( response.data['fichaActualizada']['ficha'] );
      return ficha;

    } on DioException catch (e) {
      if( e.response?.statusCode == 400 ) {
        throw CustomError('Datos inválidos');
      }
      if( e.response?.statusCode == 401 ){
        throw CustomError('No permitido');
      }
      throw Exception();
    } catch (e) {
      throw Exception('Error actualizando ficha: $e');
    }
  }

  @override
  Future<void> createFicha(String token, Ficha ficha, File aprendices) async{
    try {
      
      final formData = FormData.fromMap({
        'id': ficha.id,
        'id_programa_formacion': ficha.idProgramaFormacion,
        'jornada': ficha.jornada,
        'fecha_inicio': ficha.fechaInicio,
        'fecha_fin': ficha.fechaFin,
        'modalidad': ficha.modalidad,
        'etapa': ficha.etapa,
        'jefe_ficha': ficha.jefeFicha,
        'oferta': ficha.oferta,
        'aprendices': await MultipartFile.fromFile(
          aprendices.path,
          filename: aprendices.path.split('/').last,
        ),
      });

      await dio.post('/myntora/nuevaficha',
        data: formData,
        options: Options(
          headers: {
            'x-token': token,
            'Content/Type': 'multipart/form-data'
          }    
        )
      );

    } on DioException catch(e) {
      
      if( e.response?.statusCode == 400 ) {
        throw CustomError('Datos inválidos');
      }
      if( e.response?.statusCode == 401 ){
        throw CustomError('No permitido');
      }
      throw Exception('Error: $e');
    } catch (e) {
      throw Exception('Error: $e');
    }
    
  }

}