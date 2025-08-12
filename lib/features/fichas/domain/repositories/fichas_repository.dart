


import 'package:myntora_app/features/fichas/domain/domain.dart';

abstract class FichasRepository {

  Future<List<Ficha>> getFichas( String token );

}