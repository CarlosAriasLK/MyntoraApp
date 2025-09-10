import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/programas/domain/domain.dart';
import 'package:myntora_app/features/programas/presentation/providers/programa_provider.dart';
import 'package:myntora_app/features/shared/infrastructure/services/file_picker.dart';


class ProgramasScreen extends ConsumerWidget {
  const ProgramasScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final programaState = ref.watch( programasProvider );
    if( programaState.isLoading ) return Center(child: CircularProgressIndicator());
    if( programaState.errorMessage.isNotEmpty ) return Center(child: Text('Error: ${programaState.errorMessage}'),);


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
              
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7))
                )
              ),

              onPressed: (){
                showDialog(
                  context: context, 
                  builder: (context) {
                    return _CustomLoadProgramas();
                  },
                );
              }, 
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
        DataColumn(label: Text('Acciones')),
      ],
      rows: programas.map((programa) {
        return DataRow(
          cells: [
            DataCell(Text(programa.id.toString())),
            DataCell(Text(programa.nombre)),
            DataCell(Text(programa.nivel)),
            DataCell(Text(programa.estado)),
            DataCell(Row(
              children: [
                IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.remove_red_eye)
                ),
                IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.edit)
                ),
              ],
            ))
          ]
        );
      }).toList(),
    );
  }

}


const list = <String>['Técnico', 'Tecnólogo'];

class _CustomLoadProgramas extends ConsumerStatefulWidget {
  const _CustomLoadProgramas();
  @override
  _CustomLoadProgramasState createState() => _CustomLoadProgramasState();
}

class _CustomLoadProgramasState extends ConsumerState<_CustomLoadProgramas> {
  final fileAdapter = FilePickerAdapter();
  File? selectedFile;

  Future<void> _pickFile() async {
    final file = await fileAdapter.pickFile();
    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  final nombreController = TextEditingController();
  String dropdownValue = list.first;

  void showSnackBar( BuildContext context, String errorMessage ) {
    showSnackBar(context, errorMessage);
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    ref.listen(programasProvider, (previous, next) {
      if( next.errorMessage.isNotEmpty ) {
        showSnackBar( context, next.errorMessage );
      }
    },);

    return Dialog(
      child: SizedBox(
        height: size.height * 0.5,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Align( 
                    alignment: Alignment.center, 
                    child: Text('Crear programa de formacion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                      label: Text('Nombre del Programa')
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.7),
                    borderRadius: BorderRadius.circular(7)
                  ),
                  width: double.infinity,
                  child: DropdownButton(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    isExpanded: true,
                    hint: Text('Nivel programa'),
                    value: dropdownValue,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    underline: SizedBox(),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: selectedFile != null 
                    ? Text(selectedFile!.path.split('/').last)
                    : TextButton.icon(
                      onPressed: (){
                        _pickFile();
                      }, 
                      label: Text('Competencias y Resultados'),
                      icon: Icon(Icons.file_download),
                    ),
                ),

                Spacer(),

                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    style: ButtonStyle( shape: WidgetStatePropertyAll( RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7)) ) ),
                    onPressed: (){
                      ref.watch( programasProvider.notifier ).createProgramas( nombreController.text, dropdownValue, selectedFile! );
                      print('Elementos: ${nombreController.text}, $dropdownValue, ${selectedFile?.path.split('/').last} ');
                      context.pop();
                    }, 
                    child: Text('Cargar Programa'),
                  ),
                ),

              ],
            )
          ),
        )
      ),
    );
  }
}