


import 'package:myntora_app/features/programas/domain/entities/programa.dart';

abstract class ProgramaRepository {

  Future<List<Programa>> getProgramas( String token );

//Future<List<Programa>> updateProgramas( String token, file);

}