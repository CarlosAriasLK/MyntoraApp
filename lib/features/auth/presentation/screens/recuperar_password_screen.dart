import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecuperarPasswordScreen extends StatelessWidget {
  const RecuperarPasswordScreen({super.key});

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


class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Form(
      child: Column(
        children: [

          SizedBox(height:60,),
          Text('Restablecer Contraseña', style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold ) ),
          Text('Recupera el acceso a tu cuenta', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold ) ),
          SizedBox(height:40,),

          SizedBox(
            width: size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Correo',
                  counterStyle: TextStyle( color: Colors.black ),
                  fillColor: Colors.black,
                  border: OutlineInputBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20)))
                ),
              
              ),
            ),
          ),
          
          SizedBox(height: 40,),

          SizedBox(
            width: size.width * 0.5,
            child: FilledButton(
              onPressed: (){}, 
              child: Text('Enviar')  
            ),
          ),
          TextButton(
            onPressed: (){
              context.pop();
            }, 
            child: Text('Volver al Inicio de Sesión')
          )
          
        ],
      )
    );
  }
}