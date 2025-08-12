
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/presentation/presentation.dart';


final fichasProvider = StateNotifierProvider<FichasNotifier, FichasState>((ref) {
  final authState = ref.watch( authProvider );

  if( authState.user == null ) {
    print(authState.user);
    return FichasNotifier(repositoryImpl: ref.watch(fichasRepositoryProvider), token: 'no-token');
  }

  final repositoryImpl = ref.watch( fichasRepositoryProvider );
  return FichasNotifier(repositoryImpl: repositoryImpl, token: authState.user!.token );
});


class FichasNotifier extends StateNotifier<FichasState>{

  final String token;
  final FichasRepository repositoryImpl;

  FichasNotifier({ required this.repositoryImpl, required this.token }) : super( FichasState() );

  Future<List<Ficha>> showFichas() async{

    try{
      final fichas = await repositoryImpl.getFichas( token );

      state = state.copyWith(
        fichas: fichas,
        errorMessage: '',
        isLoading: false
      );

      return fichas;

    } on CustomError catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.errorMessage);
      throw Exception(e.errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('malo');
    }

  }
}


class FichasState {

  final bool isLoading;
  final List<Ficha>? fichas;
  final String errorMessage;

  FichasState({
    this.fichas,
    this.isLoading = false,
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