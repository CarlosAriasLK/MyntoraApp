



import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/juicios/domain/entities/juicio.dart';
import 'package:myntora_app/features/juicios/domain/repositories/juicios_repositories.dart';
import 'package:myntora_app/features/juicios/infrastructure/repositories/juicios_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'juicios_provider.g.dart';

@Riverpod(keepAlive: true)
class Juicios extends _$Juicios {

  late final String token;
  late final JuiciosRepositories repositoryImpl;

  @override
  JuiciosStatus build() {

    final userStatus = ref.watch( authProvider );
    token = userStatus.user?.token ?? "no-token";
    repositoryImpl = JuiciosRepositoryImpl();

    return JuiciosStatus();
  }


  Future<bool> _checkConnectivity() async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    return !connectivityResult.contains(ConnectivityResult.none);
  }
  Future<void> _checkInternet() async {
    if( !await _checkConnectivity() ) {
      state = state.copyWith(
        errorMessage: 'Sin internet. Revise su conexion e intentelo de nuevo mas tarde',
        isLoading: false,
      );
      throw Exception('Sin conexion a internet');
    }

  }
  

  Future<Juicio> getJuicioById( int id ) async{
    await _checkInternet();

    // state = state.copyWith( isLoading: true );

    try {
      final juicio = await repositoryImpl.getAprendizById(id, token);

      state = state.copyWith(
        isLoading: false,
        errorMessage: '',
        juicio: juicio
      );
      return juicio;

    } on CustomError catch(e) {
      state = state.copyWith(errorMessage: e.errorMessage, isLoading: false);
      throw Exception("Error: ${e.errorMessage}");
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error no controlado', isLoading: false);
      throw Exception("Error: $e");
    }
  }

}

class JuiciosStatus {

  final bool isLoading;
  final String errorMessage;
  final Juicio? juicio;

  JuiciosStatus({
    this.isLoading = false, 
    this.errorMessage = '', 
    this.juicio
  });

  copyWith({
    bool? isLoading,
    String? errorMessage,
    Juicio? juicio,
  }) => JuiciosStatus(
    errorMessage: errorMessage ?? this.errorMessage,
    isLoading: isLoading ?? this.isLoading,
    juicio: juicio ?? this.juicio
  );

}