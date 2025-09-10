

import 'dart:io';

import 'package:myntora_app/features/programas/domain/domain.dart';
import 'package:myntora_app/features/programas/infrastructure/datasources/programa_datasource_impl.dart';

class ProgramaRepositoryImpl extends ProgramaRepository{

  final ProgramaDatasource datasource;
  
  ProgramaRepositoryImpl({
    ProgramaDatasource? datasource
  }): datasource = datasource ?? ProgramaDatasourceImpl();

  @override
  Future<List<Programa>> getProgramas( String token ) {
    return datasource.getProgramas( token );
  }
  
  @override
  Future<void> createPrograma(String token, String nombrePrograma, String nivelPrograma, File competenciasyresultados ) {
    return datasource.createPrograma(token, nombrePrograma, nivelPrograma, competenciasyresultados);
  }

}