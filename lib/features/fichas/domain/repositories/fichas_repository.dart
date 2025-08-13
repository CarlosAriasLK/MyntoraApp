


import 'package:myntora_app/features/fichas/domain/domain.dart';

abstract class FichasRepository {

  Future<List<Ficha>> getFichas( String token );
  Future<Ficha> updateFicha( String token, String numeroFicha, Ficha nuevaFicha );

}