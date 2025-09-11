import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myntora_app/features/programas/domain/domain.dart';
import 'package:myntora_app/features/programas/presentation/providers/programa_provider.dart';
import 'package:myntora_app/features/shared/infrastructure/services/file_picker.dart';


class ProgramasScreen extends ConsumerWidget {
  const ProgramasScreen({super.key});

  void showSnackBar( BuildContext context, String errorMessage ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage))
    );
  }

  @override
  Widget build(BuildContext context, ref) {

    final programaState = ref.watch( programasProvider );
    if( programaState.isLoading ) return Center(child: CircularProgressIndicator());
    
    ref.listen(programasProvider, (previous, next) {
      if( next.errorMessage.isNotEmpty ) {
        showSnackBar( context, next.errorMessage );
      }
    },);


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
  final nombreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  File? selectedFile;
  String dropdownValue = list.first;

  Future<void> _pickFile() async {
    final file = await fileAdapter.pickFile();
    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final programasStatus = ref.watch( programasProvider );

    return Dialog(
      child: SizedBox(
        height: size.height * 0.4,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              
              
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Align( 
                    alignment: Alignment.center, 
                    child: Text('Crear Programa de Formacion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
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
                    validator: (value) {
                      if( value == null || value.isEmpty ) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
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
                    onPressed: programasStatus.isLoading == true
                    ? null
                    : (){
                        if( _formKey.currentState!.validate() ){
                          ref.watch( programasProvider.notifier ).createProgramas( nombreController.text, dropdownValue, selectedFile! );
                          context.pop();
                        }
                      }, 
                      child: programasStatus.isLoading
                        ? const CircularProgressIndicator( strokeWidth: 2, color: Colors.white, )
                        : const Text("Cargar Programa"),
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