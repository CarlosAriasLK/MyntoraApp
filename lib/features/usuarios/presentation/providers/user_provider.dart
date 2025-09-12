

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';
import 'package:myntora_app/features/usuarios/domain/repositories/usuarios_repositories.dart';
import 'package:myntora_app/features/usuarios/infrastructure/repositories/usuarios_repositories_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';


@Riverpod(keepAlive: true)
class UsuarioProvider extends _$UsuarioProvider {

  late final String token;
  late final UsuariosRepositories repositoryImpl;

  @override
  UserStatus build() {
    final userProvider = ref.watch( authProvider );
    token = userProvider.user?.token ?? 'no-token';
    repositoryImpl = UsuariosRepositoriesImpl();

    return UserStatus();
  }


  Future<bool> _hayConexion() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return !connectivityResults.contains( ConnectivityResult.none ); 
  }

  Future<void> _checkConnection() async {
    if( !await _hayConexion() ) {
      state = state.copyWith(
        errorMessage: 'No hay conexión a internet. Verifica tu conexión y vuelve a intentarlo.',
        isLoading: false
      );
      throw Exception('Sin conexion a internet');
    }
  }

  Future<void> createUser( Usuario usuario ) async {
    state = state.copyWith( isLoading: true );
    try {

      await repositoryImpl.createUsuario(token, usuario);
      getAllUsers();

    } on CustomError catch(e) {
      state = state.copyWith(errorMessage: e.errorMessage, isLoading: false);
      throw Exception("Error: ${e.errorMessage}");
    } catch (e) {
      state = state.copyWith(errorMessage: '$e', isLoading: false);
      throw Exception("Error: $e");
    }

  }

  Future<List<Usuario>> getAllUsers() async{

    await _checkConnection();

    try {
      final allUsers = await repositoryImpl.getUsuarios( token );

      state = state.copyWith(
        usuarios: allUsers,
        errorMessage: '',
        isLoading: false,
      );

      return allUsers;

    } on CustomError catch(e){
      state = state.copyWith( errorMessage: e.errorMessage, isLoading: false );
      throw Exception("Error: $e");
    } catch (e) {
      state = state.copyWith( errorMessage: "Error inesperado", isLoading: false );
      throw Exception("Error: $e");
    }

  }

  Future<Usuario> updateUser( Usuario usuario, int uid ) async{

    try {
      final usuarioActalizado = await repositoryImpl.updateUsuario( token, usuario );

      final usuariosActualizados = state.usuarios?.map( (usuario) {
        if( usuario.id == uid ) {
          return usuarioActalizado;
        }
        return usuario;
      }).toList();

      state = state.copyWith(
        errorMessage: '',
        isLoading: false,
        usuarios: usuariosActualizados
      );

      return usuarioActalizado;

    } on CustomError catch (e) {
      state = state.copyWith( errorMessage: e.errorMessage, isLoading: false);
      throw Exception("Error: $e");
    } catch (e){
      state = state.copyWith( errorMessage: "Error inesperado", isLoading: false);
      throw Exception("Error: $e");
    }

  }

  Future<Usuario> getUsuarioByid( int uid ) async{

    try {
      
      final usuario = await repositoryImpl.getUsuario(uid, token);
      final currentUsuarios = state.usuarios ?? [];

      state = state.copyWith(
        usuarios: [ usuario, ...currentUsuarios ],
        errorMessage: '',
        isLoading: false,
      );

      return usuario;


    } on CustomError catch(e) {
      state = state.copyWith( errorMessage: e.errorMessage, isLoading: false );
      throw Exception("Error: $e");
    } catch (e) {
      state = state.copyWith( errorMessage: "Error inesperado", isLoading: false );
      throw Exception("Error: $e");
    }
  }


  

}


class UserStatus {

  final List<Usuario>? usuarios;
  final String errorMessage;
  final bool isLoading;

  UserStatus({
    this.errorMessage = '', 
    this.isLoading = true, 
    this.usuarios
  });

  UserStatus copyWith({
    String? errorMessage,
    bool? isLoading,
    List<Usuario>? usuarios,
  }) => UserStatus(
    errorMessage: errorMessage ?? this.errorMessage,
    isLoading: isLoading ?? this.isLoading,
    usuarios: usuarios ?? this.usuarios 
  );  

}