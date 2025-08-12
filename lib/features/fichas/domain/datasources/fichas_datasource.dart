



import 'package:myntora_app/features/fichas/domain/domain.dart';

abstract class FichasDatasource {

  Future<List<Ficha>> getFichas( String token );

}