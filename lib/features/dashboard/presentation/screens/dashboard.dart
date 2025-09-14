import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';

class Dashboard extends ConsumerWidget {
  Dashboard({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authProvider);

    if (authStatus.user?.debeCambiarPassword == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const ShowCambiarPasswordModal(),
        );
      });
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Dashboard')),
    );
  }
}


class ShowCambiarPasswordModal extends ConsumerWidget {
  const ShowCambiarPasswordModal({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final authStatus = ref.watch(authProvider);
    final TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: const Text("Cambiar contraseña"),
      content: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: "Nueva contraseña",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {

            final newPassword = passwordController.text;
            if (newPassword.isEmpty) return;

            try {
              
              ref.read( authProvider.notifier ).changePassword( authStatus.user!.uid.toString(), newPassword );
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Contraseña actualizada!'))
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e'))
              );
            }

          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
