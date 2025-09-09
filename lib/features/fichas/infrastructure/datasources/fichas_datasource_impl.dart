

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
      throw Exception();
    } catch (e) {
      throw Exception('Error actualizando ficha: $e');
    }
  }

}