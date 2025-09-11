import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/presentation/presentation.dart';
import 'package:myntora_app/features/shared/infrastructure/services/file_picker.dart';

class CustomCreatingModal extends ConsumerStatefulWidget {
  const CustomCreatingModal({super.key});
  @override
  CustomCreatingModalState createState() => CustomCreatingModalState();
}

class CustomCreatingModalState extends ConsumerState<CustomCreatingModal> {

  final idFichaController = TextEditingController();
  final idProgramaController = TextEditingController();
  final jornadaController = TextEditingController();
  final inicioController = TextEditingController();
  final finController = TextEditingController();
  final modalidadController = TextEditingController();
  final etapaController = TextEditingController();
  final jefeController = TextEditingController();
  final ofertaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final fileAdapter = FilePickerAdapter();
  File? _selectedFile;

  Future<void> getFile() async{
    final file = await fileAdapter.pickFile();
    if( file != null ) {
      setState(() {
        _selectedFile = file;
      });
    }  
  }

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
                    
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('Crear Ficha', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: idProgramaController,
                          decoration: InputDecoration(
                              labelText: 'Programa de formación',
                              border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: jornadaController,
                          decoration: InputDecoration(
                              labelText: 'Jornada',
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: inicioController,
                          decoration: InputDecoration(
                              labelText: 'Fecha inicio',
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: finController,
                          decoration: InputDecoration(
                              labelText: 'Fecha fin',
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: modalidadController,
                          decoration: InputDecoration(
                              labelText: 'Modalidad',
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: etapaController,
                          decoration: InputDecoration(
                              labelText: 'Etapa',
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: jefeController,
                          decoration: InputDecoration(
                              labelText: 'Jefe ficha',
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: ofertaController,
                          decoration: InputDecoration(
                              labelText: 'Oferta',
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
            
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 10),
                        child: _selectedFile != null 
                        ? Text(_selectedFile!.path.split('/').last)
                        : TextButton.icon(
                            onPressed: (){
                              getFile();
                            }, 
                            label: Text('Cargar aprendices'),
                            icon: Icon(Icons.file_download),
                          ),
                      ),
            
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FilledButton(
                          style: ButtonStyle( shape: WidgetStatePropertyAll( RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7)) ) ),
                          onPressed: ref.read( fichasProvider ).isLoading
                            ? null 
                            : (){
                              final nuevaFicha = Ficha(
                                id: int.tryParse( idFichaController.text ) ?? 0,
                                idProgramaFormacion: int.tryParse(idProgramaController.text) ?? 0,
                                jornada: jornadaController.text,
                                fechaInicio: DateTime.tryParse(inicioController.text) ?? DateTime.now(),
                                fechaFin: DateTime.tryParse(finController.text) ?? DateTime.now(),
                                modalidad: modalidadController.text,
                                etapa: etapaController.text,
                                jefeFicha: jefeController.text,
                                oferta: ofertaController.text,
                              );
            
                              if( _formKey.currentState!.validate() ){
                                ref.read( fichasProvider.notifier ).createFicha(nuevaFicha, _selectedFile!);
                                context.pop();
                              }
                          },
                          child: Text('Crear')
                        ),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}