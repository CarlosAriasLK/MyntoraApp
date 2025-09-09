import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/programas/domain/domain.dart';
import 'package:myntora_app/features/programas/presentation/providers/programa_provider.dart';


class ProgramasScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ref) {

    final programaState = ref.watch( programasProvider );

    if( programaState.isLoading ){
      return Center(child: CircularProgressIndicator());
    }

    if( programaState.errorMessage.isNotEmpty ) {
      return Center(child: Text('Error: ${programaState.errorMessage}'),);
    }

    final programas = programaState.programas ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Programas de formacion'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: FilledButton(
              onPressed: (){}, 
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7))
                )
              ),
              child: Text('Cargar Programas'),
            ),
          ),
      
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _ProgramasDataTable( programas: programas ),
            ),
          ),
      
        ],
      ),
    );
  }
}


class _ProgramasDataTable extends StatelessWidget {
  final List<Programa> programas;
  const _ProgramasDataTable({required this.programas});

  @override
  Widget build(BuildContext context) {
    return DataTable(

      dividerThickness: 1.2,

      border: TableBorder.symmetric(
        inside: BorderSide(color: Colors.grey.shade300, width: 1),
      ),

      headingRowColor: WidgetStatePropertyAll( Color.fromARGB(20, 0, 200, 10) ),
      headingTextStyle: const TextStyle( fontWeight: FontWeight.bold, fontSize: 15, ),

      
      columns: [
        DataColumn(label: Text('Id')),
        DataColumn(label: Text('Nombre')),
        DataColumn(label: Text('Nivel')),
        DataColumn(label: Text('Estado')),
      ],
      rows: programas.map((programa) {
        return DataRow(
          cells: [
            DataCell(Text(programa.id.toString())),
            DataCell(Text(programa.nombre)),
            DataCell(Text(programa.estado)),
            DataCell(Text(programa.nivel)),
          ]
        );
      }).toList(),
    );
  }

}