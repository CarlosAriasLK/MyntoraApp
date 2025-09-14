

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/programas/domain/domain.dart';
import 'package:myntora_app/features/programas/infrastructure/infrastructure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'programa_provider.g.dart';

@Riverpod(keepAlive: true)
class Programas extends _$Programas {

  late final ProgramaRepository programaRepository;
  late final String token;

  @override
  ProgramaState build() {

    final auhtProvider = ref.watch( authProvider );
    token = auhtProvider.user?.token ?? 'no-token';

    programaRepository = ProgramaRepositoryImpl();
    return ProgramaState();
  }


  Future<bool> _hayConexion() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return !connectivityResults.contains(ConnectivityResult.none);
  }

  Future<void> _verificarConexion() async {
    if (!await _hayConexion()) {
      state = state.copyWith(
        errorMessage: 'No hay conexión a internet. Verifica tu conexión y vuelve a intentarlo.',
        isLoading: false
      );
      throw Exception('Sin conexión a internet');
    }
  }
  

  Future<List<Programa>> getProgramas() async{
    await _verificarConexion();

    try {
      final programas = await programaRepository.getProgramas(token);
      
      state = state.copyWith(
        programas: programas,
        errorMessage: '',
        isLoading: false
      );

      return programas;

    } on CustomError catch (e) {
      state = state.copyWith( errorMessage: e.errorMessage, isLoading: false );
      throw Exception('Error: $e');
    } catch (e) {
      state = state.copyWith( errorMessage: 'Error al cargar programas', isLoading: false );
      throw Exception('Error: $e');
    }

  }


  Future<void> createProgramas( String nombrePrograma, String nivelPrograma, File competenciasyresultados  ) async {
    await _verificarConexion();

    state = state.copyWith(isLoading: true);
    try {
      await programaRepository.createPrograma(token, nombrePrograma, nivelPrograma, competenciasyresultados);
      getProgramas();
      
    } on CustomError catch(e) {
      state = state.copyWith(errorMessage: e.errorMessage, isLoading: false);
      throw Exception('Error: ${e.errorMessage}');
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error no controlado', isLoading: false);
      throw Exception('Error: $e');
    }

  }


  Future<Programa> updatePrograma( Programa programaFormacion ) async {
    await _verificarConexion();

    try {
      
      final programaActualizado = await programaRepository.updateProgramas(token, programaFormacion);

      final programasActualizados = state.programas?.map<Programa>( (programa) {
        if( programa.id == programaFormacion.id ) {
          return programaActualizado;
        }
        return programa;
      } ).toList();

      state = state.copyWith(
        errorMessage: '',
        isLoading: false,
        programas: programasActualizados
      );

      return programaActualizado;

    } on CustomError catch(e) {
      state = state.copyWith( errorMessage: e.errorMessage, isLoading: false );
      throw Exception("Error: ${e.errorMessage}");
    } catch (e) {
      state = state.copyWith( errorMessage: 'Error no controlado', isLoading: false );
      throw Exception("Error: $e");
    }
  }

}


class ProgramaState {

  final List<Programa>? programas;
  final String errorMessage;
  final bool isLoading;

  ProgramaState({
    this.programas,
    this.errorMessage = '',
    this.isLoading = true
  });

  ProgramaState copyWith({
    List<Programa>? programas,
    String? errorMessage,
    bool? isLoading
  }) => ProgramaState(
    errorMessage: errorMessage ?? this.errorMessage,
    programas: programas ?? this.programas,
    isLoading: isLoading ?? this.isLoading,
  );

}
