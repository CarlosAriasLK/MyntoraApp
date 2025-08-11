
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/config/router/app_router_notifier.dart';
import 'package:myntora_app/features/auth/auth.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/auth/presentation/screens/check_auth_status.dart';
import 'package:myntora_app/features/myntora/myntora.dart';
import 'package:myntora_app/features/myntora/presentation/screens/screens.dart';


final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.watch( goRouterNotifierProvider );

  return GoRouter(
  initialLocation: '/splash',
  refreshListenable: goRouterNotifier,

  routes: [
    //LOGIN
    GoRoute(
      path: '/splash',
      builder: (context, state) => CheckAuthStatus(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),

    GoRoute(
      path: '/recuperar',
      builder: (context, state) => RecuperarPasswordScreen(),
    ),
    
    //MYNTORA
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/fichas',
      builder: (context, state) => FichasScreen(),
    ),
    GoRoute(
      path: '/programas',
      builder: (context, state) => ProgramasFormacionScreen(),
    ),
    GoRoute(
      path: '/usuarios',
      builder: (context, state) => UsuariosScreen(),
    ),
    GoRoute(
      path: '/juicios',
      builder: (context, state) => JuiciosEvaluativosScreen(),
    ),

  ],  

  redirect: (context, state) {

    final isGoingTo = state.matchedLocation;
    final authStatus = goRouterNotifier.authStatus;

    if( isGoingTo == '/splash' && authStatus == AuthStatus.checking ) return null;

    if( authStatus == AuthStatus.notAuthenticated ) {
      if( isGoingTo == '/login' || isGoingTo == '/recuperar') return null;
      return '/login';
    }

    if( authStatus == AuthStatus.authenticated ) {
      if( isGoingTo == '/login' || isGoingTo == '/recuperar' || isGoingTo == '/splash' ) return '/home';
    }

    return null;
  },

  );
});


