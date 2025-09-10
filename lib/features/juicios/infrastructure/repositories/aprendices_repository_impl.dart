

import 'package:myntora_app/features/juicios/domain/datasources/aprendices_datasources.dart';
import 'package:myntora_app/features/juicios/domain/entities/aprendiz.dart';
import 'package:myntora_app/features/juicios/domain/repositories/aprendices_repositories.dart';
import 'package:myntora_app/features/juicios/infrastructure/datasources/aprendices_datasources_impl.dart';

class AprendicesRepositoryImpl implements AprendicesRepositories {

  final AprendicesDatasources datasources;
  AprendicesRepositoryImpl({
    AprendicesDatasources? datasources
  }): datasources = datasources ?? AprendicesDatasourcesImpl();

  @override
  Future<List<Aprendiz>> getAllAprendices( int idFicha, String token) {
    return datasources.getAllAprendices( idFicha, token );
  }

  @override
  Future<Aprendiz> getAprendizById(int id, String token) {
    return datasources.getAprendizById(id, token);
  }

}