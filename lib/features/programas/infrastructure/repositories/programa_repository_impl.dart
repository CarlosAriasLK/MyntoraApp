

import 'package:myntora_app/features/programas/domain/domain.dart';

class ProgramaRepositoryImpl extends ProgramaRepository{

  final ProgramaDatasource datasource;
  ProgramaRepositoryImpl({required this.datasource});

  @override
  Future<List<Programa>> getProgramas( String token ) {
    return datasource.getProgramas( token );
  }

}