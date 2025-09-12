import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/presentation/presentation.dart';
import 'package:myntora_app/features/programas/presentation/providers/programa_provider.dart';
import 'package:myntora_app/features/shared/infrastructure/services/file_picker.dart';
import 'package:date_field/date_field.dart';

class CustomCreatingModal extends ConsumerStatefulWidget {
  const CustomCreatingModal({super.key});
  @override
  CustomCreatingModalState createState() => CustomCreatingModalState();
}

class CustomCreatingModalState extends ConsumerState<CustomCreatingModal> {

  final _formKey = GlobalKey<FormState>();
  final idFichaController = TextEditingController();
  final jefeController = TextEditingController();

  String? idProgramaController;
  String? jornadaController;
  String? modalidadController;
  String? etapaController;
  String? ofertaController;

  DateTime? inicioController;
  DateTime? finController;

  File? _selectedFile;

  Future<void> getFile() async{
    final file = await FilePickerAdapter().pickFile();
    if( file != null ) {
      setState(() {
        _selectedFile = file;
      });
    }  
  }

  final formatter = DateFormat('yyyy-MM-dd');

  void showSnackbar( BuildContext context, String message ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text( message ))
    );
  }

  @override
  Widget build(BuildContext context) {

    final programasState = ref.watch(programasProvider);
    if( programasState.isLoading ) return Center(child: CircularProgressIndicator() ,); 

    ref.listen( programasProvider, (previous, next) {
      if( next.errorMessage.isNotEmpty ) {
        showSnackbar( context, next.errorMessage );
      }
      if( next.errorMessage.isEmpty ) {
        showSnackbar( context, 'Ficha creada correctamente!' );
      }
    },);

    final idProgramas = programasState.programas?.map((programa) {
      return DropdownMenuItem(
        value: programa.id.toString(),
        child: Text(programa.nombre, style: TextStyle(fontSize: 16),)
      );
    }).toList() ?? [];
    

    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: size.height * 0.9,
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
                          controller: idFichaController,
                          decoration: InputDecoration(
                              labelText: 'Numero de Ficha',
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
                        child: CustomDropdown(
                          selectedItem: idProgramaController,
                          items: idProgramas, 
                          hintText: 'Programa de Formacion',
                          onChanged: (value) {
                            setState(() {
                              idProgramaController = value;
                            });
                          },
                        )
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CustomDropdown(
                          selectedItem: jornadaController,
                          hintText: 'Jornada',
                          items: [
                            DropdownMenuItem(value: 'Diurna', child: Text('Diurna', style: TextStyle(fontSize: 16),)),
                            DropdownMenuItem(value: 'Tarde', child: Text('Tarde', style: TextStyle(fontSize: 16))),
                            DropdownMenuItem(value: 'Noche', child: Text('Noche', style: TextStyle(fontSize: 16))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              jornadaController = value;
                            });
                          },
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DateTimeFormField(
                          mode: DateTimeFieldPickerMode.date,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Fecha inicio',
                          ),
                          onChanged: (DateTime? value) {
                            inicioController = value;
                          },
                          validator: (value) {
                            if( value == null  ) {
                              return 'El campo es requeridio';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DateTimeFormField(
                          mode: DateTimeFieldPickerMode.date,

                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Fecha Fin',
                          ),
                          onChanged: (DateTime? value) {
                            finController = value;
                          },
                          validator: (value) {
                            if( value == null  ) {
                              return 'El campo es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CustomDropdown(
                          selectedItem: modalidadController,
                          hintText: 'Modalidad',
                          items: [
                            DropdownMenuItem(value: 'Presencial', child: Text('Presencial', style: TextStyle(fontSize: 16),)),
                            DropdownMenuItem(value: 'Virtual', child: Text('Virtual', style: TextStyle(fontSize: 16))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              modalidadController = value;
                            });
                          },
                        )
                      ),
                    
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CustomDropdown(
                          selectedItem: etapaController,
                          hintText: 'Etapa',
                          items: [
                            DropdownMenuItem(value: 'Lectiva', child: Text('Lectiva', style: TextStyle(fontSize: 16),)),
                            DropdownMenuItem(value: 'Productiva', child: Text('Productiva', style: TextStyle(fontSize: 16))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              etapaController = value;
                            });
                          },
                        )
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
                        child: CustomDropdown(
                          selectedItem: ofertaController,
                          hintText: 'Oferta',
                          items: [
                            DropdownMenuItem(value: 'Cerrada', child: Text('Cerrada', style: TextStyle(fontSize: 16),)),
                            DropdownMenuItem(value: 'Abierta', child: Text('Abierta', style: TextStyle(fontSize: 16))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              ofertaController = value;
                            });
                          },
                        )
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
                                idProgramaFormacion: int.tryParse(idProgramaController ?? '') ?? 0,
                                jornada: jornadaController ?? '',
                                fechaInicio: inicioController ?? DateTime.now(),
                                fechaFin: finController ?? DateTime.now(),
                                modalidad: modalidadController ?? '',
                                etapa: etapaController ?? '',
                                jefeFicha: jefeController.text,
                                oferta: ofertaController ?? '',
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



class CustomDropdown extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final String? selectedItem;
  final String hintText;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key, 
    required this.items, 
    required this.hintText, 
    this.selectedItem, 
    required this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedItem;
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 1,
      child: DropdownButton(
        isExpanded: true,
        hint: Text(widget.hintText, style: TextStyle(fontSize: 16)),
        items: widget.items, 
        value: _selectedValue,
        onChanged: (String? value) {
          setState(() {
            _selectedValue = value;
          });
          widget.onChanged(value);
        },
      ),
    );
  }
}