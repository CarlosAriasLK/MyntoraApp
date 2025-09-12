import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/programas/domain/domain.dart';
import 'package:myntora_app/features/programas/presentation/providers/programa_provider.dart';
import 'package:myntora_app/features/shared/infrastructure/services/file_picker.dart';
import 'package:myntora_app/features/shared/widgets/custom_dropdown.dart';

void showSnackBar( BuildContext context, String message ) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message))
  );
}

class ProgramasScreen extends ConsumerStatefulWidget {
  const ProgramasScreen({super.key});
  @override
  ProgramasScreenState createState() => ProgramasScreenState();
}

class ProgramasScreenState extends ConsumerState<ProgramasScreen> {

  @override
  void initState() {
    ref.read(programasProvider.notifier).getProgramas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final userState = ref.watch( authProvider );
    final rol = userState.user?.rol;

    final programaState = ref.watch( programasProvider );
    ref.listen(programasProvider, (previous, next) {
      if( next.errorMessage.isNotEmpty ) {
        showSnackBar( context, next.errorMessage );
      }
    });

    if( programaState.isLoading ) return Center(child: CircularProgressIndicator());
    
    final programas = programaState.programas ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Programas de formacion'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          rol != null && rol == 'admin' 
          ? Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: FilledButton(
              
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7))
                )
              ),
              onPressed: (){
                showMaterialModalBottomSheet(
                  enableDrag: false,
                  context: context, 
                  builder: (context) => _CustomLoadProgramas(),
                );
              }, 
              child: Text('Cargar Programas'),
            ),
          ): SizedBox(),
      
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


class _ProgramasDataTable extends ConsumerWidget {
  final List<Programa> programas;
  const _ProgramasDataTable({required this.programas});

  @override
  Widget build(BuildContext context, ref) {

    final userState = ref.watch( authProvider );
    final rol = userState.user?.rol;

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
        rol != null && rol == 'admin' 
        ? DataColumn(label: Text('Acciones'))
        : DataColumn(label: Text('')),
      ],
      rows: programas.map((programa) {
        return DataRow(
          cells: [
            DataCell(Text(programa.id.toString())),
            DataCell(Text(programa.nombre)),
            DataCell(Text(programa.nivel)),
            DataCell(Text(programa.estado)),
            rol != null && rol == 'admin' 
            ?
              DataCell(Row(
                children: [
                  IconButton(
                    onPressed: (){
                      showModalBottomSheet(
                        enableDrag: false,
                        context: context, 
                        builder: (context) => _UpdatePrograma( programa: programa ),
                      );
                    }, 
                    icon: Icon(Icons.edit)
                  ),
                ],
              ))
            : DataCell(Text('')) 
          ]
        );
      }).toList(),
    );
  }

}


class _UpdatePrograma extends ConsumerStatefulWidget {
  final Programa programa;
  const _UpdatePrograma({required this.programa});

  @override
  _UpdateProgramaState createState() => _UpdateProgramaState();
}

class _UpdateProgramaState extends ConsumerState<_UpdatePrograma> {

  String? nivelController;
  String? estadoController;
  File? selectedFile;

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickFile() async{
    final file = await FilePickerAdapter().pickFile();
    if( file != null ) {
      selectedFile = file;
    }
  }

  late TextEditingController nombreController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.programa.nombre);
    nivelController = widget.programa.nivel;
    estadoController = widget.programa.estado;
  }
  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height * 1,

      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Align( 
                  alignment: Alignment.center, 
                  child: Text('Editar Programa de Formacion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CustomDropdown(
                  valor: nivelController,
                  hintText: 'Nivel de Programa',
                  items: [
                    DropdownItem(label: 'Técnico', value: 'Técnico'),
                    DropdownItem(label: 'Tecnólogo', value: 'Tecnólogo'),
                  ], 
                  onChange: (String? value) { 
                    setState(() {
                        nivelController = value;
                    });
                  }, 
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CustomDropdown(
                  valor: estadoController,
                  hintText: 'Estado',
                  items: [
                    DropdownItem(label: 'Activo', value: 'activo'),
                    DropdownItem(label: 'Inactivo', value: 'inactivo'),
                  ], 
                  onChange: (String? value) { 
                    setState(() {
                        estadoController = value;
                    });
                  }, 
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
          
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: FilledButton(
                    style: ButtonStyle( shape: WidgetStatePropertyAll( RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7)) ) ),
                    onPressed: (){
                      if( _formKey.currentState!.validate() ){
        
                        final nuevoPrograma = Programa(
                          id: widget.programa.id, 
                          nombre: nombreController.text, 
                          nivel: nivelController!, 
                          estado: estadoController!, 
                        );
        
                        ref.read( programasProvider.notifier ).updatePrograma( nuevoPrograma );
                        context.pop();
                      }
                    }, 
                    child: const Text("Actualizar Programa"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _CustomLoadProgramas extends ConsumerStatefulWidget {
  const _CustomLoadProgramas();
  @override
  _CustomLoadProgramasState createState() => _CustomLoadProgramasState();
}

class _CustomLoadProgramasState extends ConsumerState<_CustomLoadProgramas> {
  final fileAdapter = FilePickerAdapter();
  final nombreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? currentValue;
  
  File? selectedFile;
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

    return Container(
      height: size.height * 0.6,
      color: Colors.white,

      child: SingleChildScrollView(
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CustomDropdown(
                  hintText: 'Nivel de Programa',
                  items: [
                    DropdownItem(label: 'Técnico', value: 'Técnico'),
                    DropdownItem(label: 'Tecnólogo', value: 'Tecnólogo'),
                  ], 
                  onChange: (String? value) { 
                    setState(() {
                        currentValue = value;
                    });
                  }, 
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
          
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: FilledButton(
                    style: ButtonStyle( shape: WidgetStatePropertyAll( RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7)) ) ),
                    onPressed: (){
                      if( _formKey.currentState!.validate() ){
                        ref.watch( programasProvider.notifier ).createProgramas( nombreController.text, currentValue!, selectedFile! );
                        context.pop();
                      }
                    }, 
                    child: const Text("Cargar Programa"),
                  ),
                ),
              ),
          
            ],
          )
        ),
      ),
    );
  }
}



