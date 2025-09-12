

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/aprendices/domain/entities/aprendiz.dart';
import 'package:myntora_app/features/aprendices/presentation/providers/aprendices_provider.dart';

class AprendicesScreen extends ConsumerWidget {
  final int idFicha;
  const AprendicesScreen({super.key, required this.idFicha});

  @override
  Widget build(BuildContext context, ref) {

    final asyncAprendices = ref.watch( aprendicesProvider.notifier ).getAprendices(idFicha);  

    return Scaffold(
      appBar: AppBar(
        title: Text('Ficha $idFicha'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: _CustomAprendicesTable(asyncAprendices: asyncAprendices),
        )
      ),
    );
  }
}


class _CustomAprendicesTable extends StatelessWidget {
  const _CustomAprendicesTable({required this.asyncAprendices,});

  final Future<List<Aprendiz>> asyncAprendices;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder(
        future: asyncAprendices, 
        builder: (context, snapshot) {
      
          if( !snapshot.hasData ) return Center(child: CircularProgressIndicator(),);
          final aprendices = snapshot.data ?? [];
          
          return DataTable(
    
            dividerThickness: 1.2,
            border: TableBorder.symmetric(
              inside: BorderSide( color: Colors.grey.shade200, width: 1 )
            ),
            headingRowColor: WidgetStatePropertyAll( Color.fromARGB(20, 0, 200, 10) ),
            headingTextStyle: const TextStyle( fontWeight: FontWeight.bold, fontSize: 15, ),
    
            columns: [
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Apellido')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('Acciones')),
            ], 
            rows: aprendices.map((aprendiz) {
              return DataRow(
                  cells: [
                    DataCell(Text(aprendiz.nombre)),
                    DataCell(Text(aprendiz.apellidos)),
                    DataCell(Text(aprendiz.estado)),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            context.push('/juicios/juicio/${aprendiz.id}');
                          }, 
                          icon: Icon(Icons.remove_red_eye)
                        )
                      ],
                    )),
                  ]
                );
            }).toList()
          );
        },
      ),
    );
  }
}