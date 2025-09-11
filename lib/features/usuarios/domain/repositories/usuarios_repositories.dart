



import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';

abstract class UsuariosRepositories {

  Future<List<Usuario>> getUsuarios( String token );

  Future<Usuario> getUsuario( int uid, String token );

  Future<Usuario> updateUsuario( String token, Usuario usuario );

  Future<void> createUsuario( String token, Usuario usuario );
  
}