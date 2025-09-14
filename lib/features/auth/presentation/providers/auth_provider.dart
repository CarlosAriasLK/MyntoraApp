
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myntora_app/features/auth/domain/domain.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/infrastructure/infrastructure.dart';
import 'package:myntora_app/features/shared/infrastructure/services/key_value_storage.dart';
import 'package:myntora_app/features/shared/infrastructure/services/key_value_storage_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';


@Riverpod(keepAlive: true)
class Auth extends _$Auth {

  late final AuthRepository repositoryImpl;
  late final KeyValueStorage keyValueStorage;

  @override
   AuthState build() {
    repositoryImpl = AuthRepositoryImpl();
    keyValueStorage = KeyValueStorageImpl();

    chechAuthStatus();
    return AuthState();
  }

  Future<bool> _checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<void> _checkConection() async{
    if( !await _checkConnectivity() ) {
      state = state.copyWith(
        errorMessage: 'Sin conexion a internter. Revise su conexion e intentelo de nuevo mas tarde',
        authStatus: AuthStatus.notAuthenticated
      );
      throw Exception('Sin conexion a internet');
    }
  }
  
  Future<void> loginUser( String email, String password ) async{

    await _checkConection();

    try {
      final user = await repositoryImpl.login(email, password);
      await keyValueStorage.setKeyValue('token', user.token );

      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        errorMessage: '',
        user: user,
      );

    } on CustomError catch (e) {
      logout( errorMessage: e.errorMessage );
    } catch (e) {
      logout(errorMessage: 'Error al iniciar sesión');
    }
  }


  Future<void> chechAuthStatus() async{

    await _checkConection();

    final token = await keyValueStorage.getValue<String>('token');
    if( token == null ) return logout();

    try {
      final user = await repositoryImpl.checkLogin(token);
      state = state.copyWith(

        authStatus: AuthStatus.authenticated,
        user: user,
        errorMessage: '',
      );

    } catch (e) {
      logout( errorMessage: e.toString() );
    }
  }

  Future<void> changePassword( String token, String newPassword ) async{

    await _checkConection();

    try {
      
      await repositoryImpl.changePasword(token, newPassword);

      final userUpdated = User(
        uid: state.user!.uid, 
        nombre: state.user!.nombre, 
        rol: state.user!.rol, 
        token: state.user!.token, 
        debeCambiarPassword: false
      );

      state = state.copyWith( user: userUpdated, errorMessage: '' );

    } on CustomError catch(e) {
      state = state.copyWith(errorMessage: e.errorMessage);
      rethrow;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Erro al cambiar la contraseña');
      rethrow;
    }

  }


  Future<void> logout({ String? errorMessage }) async{

    await _checkConection();

    await keyValueStorage.removeKey('token');

    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: errorMessage,
        user: null
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }
class AuthState {
  
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    user: user ?? this.user,
    authStatus: authStatus ?? this.authStatus,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}