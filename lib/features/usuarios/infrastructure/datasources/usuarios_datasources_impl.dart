


import 'package:dio/dio.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/usuarios/domain/datasources/usuarios_datasources.dart';
import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';
import 'package:myntora_app/features/usuarios/infrastructure/mappers/usuario_mapper.dart';

class UsuariosDatasourcesImpl implements UsuariosDatasources {

  final dio = Dio( BaseOptions( baseUrl: Environment.apiUrl ) );

  @override
  Future<Usuario> getUsuario(int uid, String token) async{
    try {
      
      final response = await dio.get('/myntora/actualizarusuario/$uid', options: Options( headers: { 'x-token': token } ) );

      return UsuarioMapper.responseToEntity( response.data['usuario'] );

    } on DioException catch(e) {
      if( e.response?.statusCode == 401 ){
        CustomError('Token no valido');
      }
      if (e.response?.statusCode == 500) {
        CustomError('No existe un usuario con ese id');
      }
      throw Exception("Error: $e");
      
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  @override
  Future<List<Usuario>> getUsuarios( String token ) async{
    try {
      
      final response = await dio.get('/myntora/usuarios', options: Options( headers: { 'x-token': token } ) );
      final List usuariosResponse = response.data["usuarios"];
      return usuariosResponse.map((usuario) => UsuarioMapper.responseToEntity( usuario ) ).toList(); 

    } on DioException catch(e) {
      if( e.response?.statusCode == 401 ){
        CustomError('Token no valido');
      }
      throw Exception('Error: $e');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<Usuario> updateUsuario(String token, Usuario usuario) async{
    try {

      final newUsuario = await dio.put('/myntora/actualizarusuario/${usuario.id}', 
        data: {
          'nombre': usuario.nombre,
          'apellido': usuario.apellido,
          'password': usuario.password,
          'tipo_documento': usuario.tipoDocumento,
          'nro_documento': usuario.nroDocumento,
          'correo_institucional': usuario.correoInstitucional,
          'rol': usuario.rol,
          'tipo_rol': usuario.tipoRol,
          'fecha_inicio_contrato': usuario.fechaInicioContrato,
          'fecha_fin_contrato': usuario.fechaFinContrato,
          'telefono': usuario.telefono,
        },
        options: Options(
          headers: {
            'x-token': token
          }
        )
      );

      return UsuarioMapper.responseToEntity( newUsuario.data['usuario'] );


    } on DioException catch(e) {
      if (e.response?.statusCode == 500) {
        CustomError('No existe un usuario con ese id');
      }
      if( e.response?.statusCode == 401 ){
        CustomError('Token no valido');
      }
      if( e.response?.statusCode == 400 ){
        CustomError('Datos invalidos');
      }
      throw Exception("Error: $e");

    }
    catch (e) {
      throw Exception("Error: $e");
    }

  }

}