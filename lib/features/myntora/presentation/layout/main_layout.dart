import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/myntora/providers/theme_provider.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends ConsumerState<MainLayout> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Myntora'),
        actions: [
          IconButton(
            icon: Icon( 
              ref.watch( themeProvider ) ? Icons.wb_sunny : Icons.nightlight_round,
            ),
            onPressed: () {
              ref.read( themeProvider.notifier ).update( (value) => !value );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                child: Row(
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
                title: const Text('Dashboard'),
                leading: Icon(Icons.dashboard),
                onTap: () {
                    context.go('/home');
                    context.pop();
                  },
              ),
              ListTile(
                title: const Text('Fichas'),
                leading: Icon(Icons.description),
                onTap: () {
                  context.go('/fichas');
                  context.pop();
                },
              ),
              ListTile(
                title: const Text('Programas de formación'),
                leading: Icon(Icons.menu_book),
                onTap: () {
                  context.go('/programas');
                  context.pop();
                },
              ),
              ListTile(
                title: const Text('Juicios evaluativos'),
                leading: Icon(Icons.rate_review),
                onTap: () {
                  context.go('/juicios');
                  context.pop();
                },
              ),
              ListTile(
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
                      leading: Icon(Icons.person_outline),
                      title: Text("Perfil"),
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Cerrar Sesión"),
                    ),
                  ),
                ],
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Yuly Saenz"),
                  subtitle: Text("yuly@sena.edu.co"),
                  trailing: Icon(Icons.arrow_drop_down),
                ),
              ),
          
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }
}