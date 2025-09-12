

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/juicios/domain/entities/juicio.dart';
import 'package:myntora_app/features/juicios/presentation/providers/juicios_provider.dart';

class JuiciosScreen extends ConsumerWidget {
  final int aprendizId;
  const JuiciosScreen({super.key, required this.aprendizId});

  void showSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final juicioState = ref.watch(juiciosProvider);

    ref.listen(juiciosProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        showSnackBar(context, next.errorMessage);
      }
    });

    ref.read(juiciosProvider.notifier).getJuicioById(aprendizId);

    if (juicioState.isLoading) return const Scaffold( body: Center(child: CircularProgressIndicator()), );

    if (juicioState.juicio == null) {
      return const Scaffold(
        body: Center(child: Text('No se encontró el juicio')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Juicio Evaluativo'),
      ),
      body: CustomScrollView(

        slivers: [


          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _CustomDetailsCard( juicio: juicioState.juicio!, ),

                    _CustomCompetenciasTable(juicio: juicioState.juicio! ,),
                  
                  ],
                );
                
              },
            )
          )
        ],

      )
    );
  }
}

class _CustomDetailsCard extends StatelessWidget {
  final Juicio juicio;
  const _CustomDetailsCard({required this.juicio});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        decoration: BoxDecoration( 
          color: Color.fromARGB(50, 0, 200, 10), 
          borderRadius: BorderRadius.all( Radius.circular(7) ) 
        ),

        width: size.width * 1,
        height: size.height * 0.2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('${juicio.nombre} ${juicio.apellidos}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
                ),
              ),
              Expanded(
                child: Text(juicio.tipoFocumento, style: TextStyle(fontSize: 17,),),
              ),
              Expanded(
                child: Text(juicio.nroDocumento, style: TextStyle(fontSize: 17,),),
              ),
              Expanded(
                child: Text(juicio.estado, style: TextStyle(fontSize: 17,),),
              ),
              Expanded(
                child: Text(juicio.idFicha.toString(), style: TextStyle(fontSize: 17,),),
              ),

            ],
          )
        )
      ),
    );
  }
}


class _CustomCompetenciasTable extends StatelessWidget {
  final Juicio juicio;
  const _CustomCompetenciasTable({required this.juicio});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(

          dividerThickness: 1.2,

          border: TableBorder.symmetric(
            inside: BorderSide( color: Colors.grey.shade200, width: 1)
          ),        
          headingRowColor: WidgetStatePropertyAll( Color.fromARGB(20, 0, 200, 10) ),
          headingTextStyle: const TextStyle( fontWeight: FontWeight.bold, fontSize: 15, ),  

          columns: [
            DataColumn(label: Text('Competencia') ),
            DataColumn(label: Text('Estado')),
            DataColumn(label: Text('# Resultados')),
            DataColumn(label: Text('Resultados Aprobados')),
          ], 
          rows: juicio.competencias.map( (competencia ) =>
            DataRow(
              cells: [
                DataCell(SizedBox( width: 200, child: Text(competencia.nombre, overflow: TextOverflow.ellipsis,))),
                DataCell(Text(competencia.estado)),
                DataCell(Text(competencia.resultados.length.toString())),
                DataCell(Text( competencia.resultados.where( (resultado) => resultado.estado == 'Aprobado' ).length.toString() )),
              ]
            )
          ).toList(),
        ),
      ),
    );
  }
}