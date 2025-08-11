import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            SizedBox(
              height: size.height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.directional(bottomEnd: Radius.circular(90)),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/no-image.jpg'), 
                  image: AssetImage('assets/images/prueba.jpg')
                ),
              ),
            ),
        
        
            SizedBox(
              height: size.height * 0.6,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: _LoginForm(),
              )
            ),
        
          ],
        ),
      )
    );
  }
}


class _LoginForm extends ConsumerStatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}


class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void showSnackbar( BuildContext context, String message ){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    ref.listen(authProvider, (previous, next) {
      if( next.errorMessage.isEmpty ) return;
      showSnackbar(context, next.errorMessage);
    },);

    return Form(
      key: _formKey,
      child: Column(
        children: [

          SizedBox(height:60,),
          Text('Iniciar Sesión', style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold ) ),
          Text('Bienvenid@ a Myntora', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold ) ),
          SizedBox(height:40,),

          SizedBox(
            width: size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextFormField(
                key: Key('email'),
                controller: emailController,
                validator: (value) {
                  if( value == null || value.isEmpty ) {
                    return 'El correo es requerido';
                  }

                  if( !value.contains('@')) {
                    return 'Debe ser un correo válido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Correo',
                  counterStyle: TextStyle( color: Colors.black ),
                  fillColor: Colors.black,
                  border: OutlineInputBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20)))
                ),
              
              ),
            ),
          ),

          SizedBox(
            width: size.width * 0.7,
            child: TextFormField(
              key: Key('password'),
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if( value == null || value.isEmpty ) {
                  return 'La contraseña es requerida';
                }
                if( value.length < 6 ){
                  return 'La contraseña debe tener mínimo 6 caracteres';
                } 
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)))
              ),
            ),
          ),

          
          SizedBox(height: 40,),

          SizedBox(
            width: size.width * 0.5,
            child: FilledButton(
              key: Key('filledButton'),
              onPressed: (){
                if( _formKey.currentState!.validate() ) {
                  ref.read( authProvider.notifier ).loginUser(
                    emailController.text.trim(), 
                    passwordController.text.trim()
                  );
                }
              }, 
              child: Text('Ingresar')  
            ),
          ),

          TextButton(
            onPressed: (){
              context.push('/recuperar');
            }, 
            child: Text('Olvidaste tu contraseña?')
          )
          
        ],
      )
    );
  }
}