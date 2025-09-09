

import 'package:myntora_app/features/usuarios/domain/datasources/usuarios_datasources.dart';
import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';
import 'package:myntora_app/features/usuarios/domain/repositories/usuarios_repositories.dart';
import 'package:myntora_app/features/usuarios/infrastructure/datasources/usuarios_datasources_impl.dart';

class UsuariosRepositoriesImpl implements UsuariosRepositories {

  final UsuariosDatasources datasources;

  UsuariosRepositoriesImpl({
    UsuariosDatasources? datasources
  }): datasources = datasources ?? UsuariosDatasourcesImpl();


  @override
  Future<Usuario> getUsuario(int uid, String token) {
    return datasources.getUsuario(uid, token);
  }

  @override
  Future<List<Usuario>> getUsuarios( String token ) {
    return datasources.getUsuarios( token );
  }

  @override
  Future<Usuario> updateUsuario(String token, Usuario usuario) {
    return datasources.updateUsuario(token, usuario);
  }
}