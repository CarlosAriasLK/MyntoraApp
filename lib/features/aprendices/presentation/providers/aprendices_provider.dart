

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/aprendices/domain/entities/aprendiz.dart';
import 'package:myntora_app/features/aprendices/domain/repositories/aprendices_repositories.dart';
import 'package:myntora_app/features/aprendices/infrastructure/repositories/aprendices_repository_impl.dart';
import 'package:myntora_app/features/shared/infrastructure/errors/errors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aprendices_provider.g.dart';

@riverpod
class Aprendices extends _$Aprendices {

  late final AprendicesRepositories aprendicesRepositoryImpl;
  late final String token;

  @override
  AprendizStatus build() {

    final userStatus = ref.read( authProvider );
    token = userStatus.user?.token ?? 'no-token';
    aprendicesRepositoryImpl = AprendicesRepositoryImpl();

    return AprendizStatus();
  }

  Future<bool> _hayConnexion() async{
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<void> _verificarConexion() async{
    if( !await _hayConnexion() ) {
      state = state.copyWith( 
        errorMessage: 'Sin conexion a intenet. Intentelo de nuevo mas tarde',
        isLoading: false,
      );
      throw Exception('Sin conextion a internte');
    }
  }

  Future<List<Aprendiz>> getAprendices( int idFicha ) async{

    await _verificarConexion();

    try {
      
      final aprendices = await aprendicesRepositoryImpl.getAllAprendices(idFicha, token);

      state = state.copyWith(
        aprendices: aprendices,
        errorMessage: '',
        isLoading: false,
      );
      return aprendices;

    } on CustomError catch(e) {
      state = state.copyWith( errorMessage: e.errorMessage, isLoading: false );
      throw Exception("Error $e");
    } catch (e) {
      state = state.copyWith( errorMessage: 'Error no controlado', isLoading: false );
      throw Exception("Error $e");
    }

  }

}


class AprendizStatus {

  final bool isLoading;
  final String errorMessage;
  final List<Aprendiz>? aprendices;

  AprendizStatus({
    this.isLoading = true, 
    this.errorMessage = '', 
    this.aprendices
  });

  AprendizStatus copyWith({
    List<Aprendiz>? aprendices,
    bool? isLoading,
    String? errorMessage,
  }) => AprendizStatus(
    aprendices: aprendices ?? this.aprendices,
    errorMessage: errorMessage ?? this.errorMessage,
    isLoading: isLoading ?? this.isLoading,
  );

}


