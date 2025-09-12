

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/fichas/domain/entities/ficha.dart';
import 'package:myntora_app/features/fichas/presentation/presentation.dart';

class FichasJuiciosScreen extends ConsumerWidget {

  const FichasJuiciosScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final fichaState = ref.watch( fichasProvider );  
    if( fichaState.isLoading ) return Center(child: CircularProgressIndicator(),);
    if( fichaState.errorMessage.isNotEmpty ) return Center(child: Text("Erorr: ${fichaState.errorMessage}"),);

    final fichas = fichaState.fichas ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Juicios Evaluativos'),
      ),
      body: GridView.builder(
        itemCount: fichas.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10
        ), 
        itemBuilder: (context, index) {
          return CustomCard( ficha: fichas[index], );
        },
      )
    );
  }
}


class CustomCard extends StatelessWidget {
  
  final Ficha ficha;

  const CustomCard({super.key, required this.ficha});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 7),
      child: Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Color.fromARGB(20, 0, 200, 10) 
        ),

        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(child: Text('Ficha #${ficha.id}', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17 ),)),

              Expanded(child: Text('Programacion de software',  style: TextStyle(  fontSize: 12 ))),

              Expanded(child: Text("Jornada ${ficha.jornada}")),

              Expanded(child: Text('Etapa ${ficha.etapa}')),

              FilledButton(                
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll( RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7)) ) 
                ),
                onPressed: (){
                  context.push('/juicios/aprendices/${ficha.id}');
                }, 
                child: Text('Visualizar Juicio')
              )

            ],
          ),
        ),
      )
    );
  }
}