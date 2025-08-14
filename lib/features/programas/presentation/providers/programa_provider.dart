import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/programas/domain/domain.dart';
import 'package:myntora_app/features/programas/presentation/presentation.dart';

final programaProvider = StateNotifierProvider.family<ProgramaNotifier, ProgramaState, String>((ref, token) {
  final repositoryImpl = ref.watch( programaRepositoryProvider );
  return ProgramaNotifier(token: token, repositoryImpl: repositoryImpl);
});

class ProgramaNotifier extends StateNotifier<ProgramaState> {

  final String token;
  final ProgramaRepository repositoryImpl;
  ProgramaNotifier({required this.token, required this.repositoryImpl}) : super( ProgramaState() );


  Future<List<Programa>> showProgramas() async{
    try {
      final programas = await repositoryImpl.getProgramas(token);

      state = state.copyWith(
        errorMessage: '',
        isLoading: false,
        programas: programas,
      );

      return programas;

    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.errorMessage, isLoading: false,);
      throw Exception(e.errorMessage);
    } catch (e) {
      state = state.copyWith( errorMessage: 'Error inesperado', isLoading: false,);
      throw Exception('Malo');
    }

  }


}




class ProgramaState {

  final bool isLoading;
  final String errorMessage;
  final List<Programa>? programas;

  ProgramaState({
    this.isLoading = true,
    this.errorMessage = '',
    this.programas
  });

  ProgramaState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Programa>? programas,
  }) => ProgramaState(
    errorMessage: errorMessage ?? this.errorMessage,
    isLoading: isLoading ?? this.isLoading,
    programas: programas ?? this.programas,
  );

}