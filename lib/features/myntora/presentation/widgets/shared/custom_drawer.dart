import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/myntora/presentation/presentation.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;

    return Drawer(
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
                    child: SizedBox(
                      height: size.height * 0.5,
                      width: size.width * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Myntora',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Gestion de Aprendices',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            // Menú
            ListTile(
              title: Text('Dashboard'), 
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
              },
            ),
            ListTile(
              title: Text('Programas de Formación'), 
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProgramasFormacionScreen(),));
              },
            ),
            ListTile(
              title: Text('Fichas'), 
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FichasScreen(),));
              },
            ),
            ListTile(
              title: Text('Juicios Evaluativos'), 
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JuiciosEvaluativosScreen(),));
              },
            ),
            ListTile(
              title: Text('Usuarios'), 
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UsuariosScreen(),));
              },
            ),
        
            Spacer(),
        
            InkWell(
              onTap: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 700, 100, 10), 
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.person_outline),
                        title: Text("Perfil"),
                        onTap: () {
                          Navigator.pop(context); 
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Cerrar Sesión"),
                        onTap: () {
                          Navigator.pop(context);
                          ref.read( authProvider.notifier ).logout();
                        },
                      ),
                    ),
                  ],
                );
              },

              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Text("YS"), // Iniciales
                ),
                title: Text("Yuly Saenz"),
                subtitle: Text("yuly@sena.edu.co"),
                trailing: Icon(Icons.arrow_drop_down),
              ),
            )
          ],
        ),
      ),
    );
  }
}
