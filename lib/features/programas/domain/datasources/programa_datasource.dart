


import 'dart:io';
import 'package:myntora_app/features/programas/domain/entities/programa.dart';

abstract class ProgramaDatasource {

  Future<List<Programa>> getProgramas( String token );

  Future<void> createPrograma( String token, String nombrePrograma, String nivelPrograma, File competenciasyresultados );

  Future<Programa> updateProgramas( String token, Programa programa );

}