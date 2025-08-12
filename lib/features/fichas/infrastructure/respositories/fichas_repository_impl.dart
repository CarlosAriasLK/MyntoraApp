


import 'package:myntora_app/features/fichas/domain/domain.dart';

class FichasRepositoryImpl extends FichasRepository{

  final FichasDatasource datasource;
  FichasRepositoryImpl({required this.datasource});

  @override
  Future<List<Ficha>> getFichas( String token ) {
    return datasource.getFichas( token );
  }

}