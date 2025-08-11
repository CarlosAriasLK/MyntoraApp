
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';


final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.watch( authProvider.notifier );
  return GoRouterNotifier( authNotifier );
});


class GoRouterNotifier extends ChangeNotifier {

  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier( this._authNotifier ){
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }

  set authStatus( AuthStatus newStatus ){
    _authStatus = newStatus;
    notifyListeners();
  }

  AuthStatus get authStatus => _authStatus;

}