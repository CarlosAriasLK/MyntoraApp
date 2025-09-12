import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/shared/presentation/providers/theme_provider.dart';

class MainLayout extends ConsumerWidget {

  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, ref) {

    final size = MediaQuery.of(context).size;
    final isDarkMode = ref.watch( themeProvider );
    final user = ref.watch( authProvider ); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Myntora'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
            ),
            onPressed: () {
              ref.read( themeProvider.notifier ).changeTheme();
            },
            
          ),
        ],
      ),

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [

              DrawerHeader(
                padding: EdgeInsets.zero,

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    FadeInImage(
                      height: (size.height - 300) * 0.1,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/no-image.jpg'),
                      image: AssetImage('assets/images/LogoSenaSinFondo.webp'),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Myntora', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                          Text('Gestión de Aprendices', style: TextStyle(fontSize: 15), textAlign: TextAlign.center),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              ListTile(
                trailing: Icon(Icons.arrow_right),
                title: const Text('Dashboard'),
                leading: Icon(Icons.dashboard),
                onTap: () {
                  context.go('/home');
                  context.pop();
                },
              ),
              ListTile(
                trailing: Icon(Icons.arrow_right),
                title: const Text('Programas de formación'),
                leading: Icon(Icons.menu_book),
                onTap: () {
                  context.go('/programas');
                  context.pop();
                },
              ),
              ListTile(
                trailing: Icon(Icons.arrow_right),
                title: const Text('Fichas'),
                leading: Icon(Icons.description),
                onTap: () {
                  context.go('/fichas');
                  context.pop();
                },
              ),
              ListTile(
                trailing: Icon(Icons.arrow_right),
                title: const Text('Juicios evaluativos'),
                leading: Icon(Icons.rate_review),
                onTap: () {
                  context.go('/juicios');
                  context.pop();
                },
              ),
              ListTile(
                trailing: Icon(Icons.arrow_right),
                title: const Text('Usuarios'),
                leading: Icon(Icons.people),
                onTap: () {
                  context.go('/usuarios');
                  context.pop();
                },
              ),

              const Spacer(),

              PopupMenuButton<int>(
                onSelected: (value) {
                  if (value == 0) {
                    // Ir al perfil
                  } else if (value == 1) {
                    ref.read(authProvider.notifier).logout();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: ListTile(
                      trailing: Icon(Icons.arrow_right),
                      leading: Icon(Icons.person_outline),
                      title: Text("Perfil"),
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      trailing: Icon(Icons.arrow_right),
                      leading: Icon(Icons.logout),
                      title: Text("Cerrar Sesión"),
                    ),
                  ),
                ],
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(user.user?.nombre ?? 'Usuario'),
                  subtitle: Text(user.user?.rol ?? 'Rol' ),
                  trailing: Icon(Icons.arrow_drop_down),
                ),
              ),

            ],
          ),
        ),
      ),

      body: child,

    );
  }
}