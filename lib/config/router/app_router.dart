
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/auth/auth.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/auth/presentation/screens/check_auth_status.dart';

import 'package:myntora_app/features/fichas/presentation/screens/fichas_screen.dart';

import 'package:myntora_app/features/myntora/myntora.dart';
import 'package:myntora_app/features/myntora/presentation/screens/juicios_evaluativos_screen.dart';
import 'package:myntora_app/features/programas/presentation/presentation.dart';
import 'package:myntora_app/features/shared/presentation/layout/main_layout.dart';
import 'package:myntora_app/features/usuarios/presentation/screens/usuarios_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final authNotifierProvider = ref.watch( authProvider );

  return GoRouter(
    initialLocation: '/splash',

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
      ShellRoute(
          builder: (context, state, child) {
            return MainLayout(child: child);
          },
          routes: [
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
              builder: (context, state) => ProgramasScreen(),
            ),
            GoRoute(
              path: '/juicios',
              builder: (context, state) => JuiciosEvaluativosScreen(),
            ),
            GoRoute(
              path: '/usuarios',
              builder: (context, state) => UsuariosScreen(),
            ),
          ]
      )

    ],

    redirect: (context, state) {

      final isGoingTo = state.matchedLocation;
      final authStatus = authNotifierProvider.authStatus;

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
}
