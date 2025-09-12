

import 'package:myntora_app/features/aprendices/domain/datasources/aprendices_datasources.dart';
import 'package:myntora_app/features/aprendices/domain/entities/aprendiz.dart';
import 'package:myntora_app/features/aprendices/domain/repositories/aprendices_repositories.dart';
import 'package:myntora_app/features/aprendices/infrastructure/datasources/aprendices_datasources_impl.dart';

class AprendicesRepositoryImpl implements AprendicesRepositories {

  final AprendicesDatasources datasources;
  AprendicesRepositoryImpl({
    AprendicesDatasources? datasources
  }): datasources = datasources ?? AprendicesDatasourcesImpl();

  @override
  Future<List<Aprendiz>> getAllAprendices( int idFicha, String token) {
    return datasources.getAllAprendices( idFicha, token );
  }

}