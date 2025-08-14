


import 'package:myntora_app/features/fichas/domain/domain.dart';

class FichasRepositoryImpl extends FichasRepository{

  final FichasDatasource datasource;
  FichasRepositoryImpl({required this.datasource});

  @override
  Future<List<Ficha>> getFichas( String token ) {
    return datasource.getFichas( token );
  }

  @override
  Future<Ficha> updateFicha(String token, int idFicha, Ficha nuevaFicha) {
    return datasource.updateFicha(token, idFicha, nuevaFicha);
  }

}