
import 'dart:io';

import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/infrastructure/infrastructure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'fichas_provider.g.dart';

@Riverpod(keepAlive: true)
class Fichas extends _$Fichas {
  late final String token;
  late final FichasRepository repositoryImpl;

  @override
  FichasState build() {
    final authState = ref.watch( authProvider );
    token = authState.user?.token ?? 'no-token';

    repositoryImpl = FichasRepositoryImpl();

    showFichas();
    return FichasState();
  }

  Future<List<Ficha>> showFichas() async{
    try{
      final fichas = await repositoryImpl.getFichas( token );

      state = state.copyWith(
          isLoading: false,
          fichas: fichas,
          errorMessage: '',
      );
      return fichas;

    } on CustomError catch (e) {
      state = state.copyWith( errorMessage: e.errorMessage, isLoading: false, );
      throw Exception(e.errorMessage);
    } catch (e) {
      state = state.copyWith( errorMessage: 'Error inesperado',isLoading: false,);
      throw Exception('Error: $e');
    }
  }

  Future<Ficha> updateFicha( Ficha nuevaFicha, int numeroFicha ) async{
    try {
      final fichaActualizada = await repositoryImpl.updateFicha(token, numeroFicha, nuevaFicha);

      final fichasActualizadas = state.fichas?.map((ficha) {
        if (ficha.id == numeroFicha) {
          return fichaActualizada;
        }
        return ficha;
      }).toList();

      state = state.copyWith(
        fichas: fichasActualizadas,
        isLoading: false,
        errorMessage: '',
      );

      return fichaActualizada;

    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.errorMessage, isLoading: false);
      throw Exception('Error: $e');
    } catch (e) {
      throw Exception('Error: $e');
    }

  }


  Future<void> createFicha( Ficha ficha, File aprendices ) async{
    state = state.copyWith(isLoading: true);
    try {
      await repositoryImpl.createFicha(token, ficha, aprendices);
      showFichas();

    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.errorMessage, isLoading: false);
      throw Exception('Error: ${e.errorMessage}');
    } catch (e) {
      throw Exception('Error: $e');
    }

  }

}


class FichasState {

  final List<Ficha>? fichas;
  final bool isLoading;
  final String errorMessage;

  FichasState({
    this.fichas,
    this.isLoading = true,
    this.errorMessage = '',
  });

  FichasState copyWith({
    bool? isLoading,
    List<Ficha>? fichas,
    String? errorMessage
  }) => FichasState(
    fichas: fichas ?? this.fichas,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}