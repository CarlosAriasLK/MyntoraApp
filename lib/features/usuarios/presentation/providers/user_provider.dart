

import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';
import 'package:myntora_app/features/usuarios/domain/repositories/usuarios_repositories.dart';
import 'package:myntora_app/features/usuarios/infrastructure/repositories/usuarios_repositories_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';


@riverpod
class UsuarioProvider extends _$UsuarioProvider {

  late final String token;
  late final UsuariosRepositories repositoryImpl;

  @override
  UserStatus build() {
    final userProvider = ref.watch( authProvider );
    token = userProvider.user?.token ?? 'no-token';

    repositoryImpl = UsuariosRepositoriesImpl();

    getAllUsers();
    return UserStatus();
  }


  Future<List<Usuario>> getAllUsers() async{

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
        usuarios: [ ...currentUsuarios, usuario ],
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