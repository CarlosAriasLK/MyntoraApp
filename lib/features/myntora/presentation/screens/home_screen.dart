

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: (){
            ref.watch( authProvider.notifier ).logout();
          }, 
          
          child: Text('Cerrar sesíon')),
        ),
    );
  }
}