

import 'package:dio/dio.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
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

}