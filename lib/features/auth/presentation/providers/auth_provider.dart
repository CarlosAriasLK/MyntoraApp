import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/auth/domain/domain.dart';
import 'package:myntora_app/features/auth/infrastructure/errors/errors.dart';
import 'package:myntora_app/features/auth/infrastructure/infrastructure.dart';
import 'package:myntora_app/features/shared/infrastructure/services/key_value_storage.dart';
import 'package:myntora_app/features/shared/infrastructure/services/key_value_storage_impl.dart';


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final repositoryImpl = AuthRepositoryImpl();
  final keyValueStorageImpl = KeyValueStorageImpl();

  return AuthNotifier(
    repositoryImpl: repositoryImpl ,
    keyValueStorage: keyValueStorageImpl
  );

});


class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository repositoryImpl;
  final KeyValueStorage keyValueStorage;

  AuthNotifier({
    required this.keyValueStorage,
    required this.repositoryImpl
  }) : super( AuthState() ){
    chechAuthStatus();
  }


  Future<void> loginUser( String email, String password ) async{
    await Future.delayed(Duration( milliseconds: 500 ));

    try {
      final user = await repositoryImpl.login(email, password);
      await keyValueStorage.setKeyValue('token', user.token);

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