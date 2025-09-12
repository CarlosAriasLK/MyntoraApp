



import 'package:myntora_app/features/juicios/domain/datasources/juicios_datasources.dart';
import 'package:myntora_app/features/juicios/domain/entities/juicio.dart';
import 'package:myntora_app/features/juicios/domain/repositories/juicios_repositories.dart';
import 'package:myntora_app/features/juicios/infrastructure/datasources/juicios_datasource_impl.dart';

class JuiciosRepositoryImpl implements JuiciosRepositories {

  final JuiciosDatasources datasource;

  JuiciosRepositoryImpl({JuiciosDatasources? datasource}): datasource = datasource ?? JuiciosDatasourceImpl();

  @override
  Future<Juicio> getAprendizById(int id, String token) {
    return datasource.getAprendizById(id, token);
  }
  
}