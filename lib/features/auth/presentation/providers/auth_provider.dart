
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

    _chechAuthStatus();
    return AuthState();
  }

  Future<void> loginUser( String email, String password ) async{

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


  Future<void> _chechAuthStatus() async{
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

  Future<void> logout({ String? errorMessage }) async{
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
    this.authStatus = AuthStatus.checking , 
    this.user, 
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}