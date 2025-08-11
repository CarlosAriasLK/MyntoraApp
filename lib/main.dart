import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/config/constants/environment.dart';
import 'package:myntora_app/config/router/app_router.dart';
import 'package:myntora_app/config/theme/app_theme.dart';

void main() async{
  await Environment.initEnvironment();
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final appRouter = ref.watch( goRouterProvider );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
    );
  }
}
