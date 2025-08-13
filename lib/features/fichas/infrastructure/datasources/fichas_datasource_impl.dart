

import 'package:dio/dio.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/infrastructure/mappers/ficha_mapper.dart';
import 'package:myntora_app/features/fichas/infrastructure/mappers/fichas_mapper.dart';

class FichasDatasourceImpl extends FichasDatasource{

  final dio = Dio( BaseOptions(
    baseUrl: Environment.apiUrl
  ));

  @override
  Future<List<Ficha>> getFichas( String token ) async{
    try {
      final response = await dio.get('/myntora/fichas', options: Options(
        headers: {
          'x-token': token
        }
      ));
      final fichas = FichasMapper.jsonListToEntity( response.data['fichas'] );
      return fichas;

    } on DioException catch (e) {
      if( e.response?.statusCode == 404 ) {
        CustomError('Error al cargar las fichas');
      }
      print('Error $e');
      throw Exception();
    }

  }

  @override
  Future<Ficha> updateFicha(String token, String numeroFicha, Ficha nuevaFicha) async{
    try {
      final response = await dio.put('/myntora/actualizarficha/$numeroFicha',
          data: {
            "id_programa_formacion": nuevaFicha.id_programa_formacion,
            "jornada": nuevaFicha.jornada,
            "fecha_inicio": nuevaFicha.fecha_inicio,
            "fecha_fin": nuevaFicha.fecha_fin,
            "modalidad": nuevaFicha.modalidad,
            "etapa": nuevaFicha.etapa,
            "jefe_ficha": nuevaFicha.jefe_ficha,
            "oferta": nuevaFicha.oferta
          },
          options: Options(
              headers: {
                'x-token': token
              }
          )
      );

      final ficha = FichaMapper.jsonToEntity( response.data['fichaActualizada']['ficha'] );
      return ficha;

    } on DioException catch (e) {
      if( e.response!.statusCode == 400 ) {
        throw CustomError('No existe la ficha');
      }
      throw Exception();
    } catch (e) {
      throw Exception('Error actualizando ficha: $e');
    }
  }

}