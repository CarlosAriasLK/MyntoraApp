


import 'dart:io';

import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/infrastructure/datasources/fichas_datasource_impl.dart';

class FichasRepositoryImpl extends FichasRepository{

  final FichasDatasource datasource;
  
  FichasRepositoryImpl({
    FichasDatasource? datasource
  }): datasource = datasource ?? FichasDatasourceImpl();

  @override
  Future<List<Ficha>> getFichas( String token ) {
    return datasource.getFichas( token );
  }

  @override
  Future<Ficha> updateFicha(String token, int idFicha, Ficha nuevaFicha) {
    return datasource.updateFicha(token, idFicha, nuevaFicha);
  }

  @override
  Future<void> createFicha(String token, Ficha ficha, File aprendices) {
    return datasource.createFicha(token, ficha, aprendices);
  }

}