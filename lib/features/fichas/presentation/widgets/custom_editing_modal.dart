

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/presentation/presentation.dart';

class CustomEditingModal extends ConsumerStatefulWidget {
  final Ficha ficha;
  const CustomEditingModal({super.key, required this.ficha});

  @override
  CustomModalState createState() => CustomModalState();
}

class CustomModalState extends ConsumerState<CustomEditingModal> {


  final idFichaController = TextEditingController();
  final idProgramaController = TextEditingController();
  final jornadaController = TextEditingController();
  final inicioController = TextEditingController();
  final finController = TextEditingController();
  final modalidadController = TextEditingController();
  final etapaController = TextEditingController();
  final jefeController = TextEditingController();
  final ofertaController = TextEditingController();

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    idProgramaController.text = widget.ficha.idProgramaFormacion.toString();
    jornadaController.text = widget.ficha.jornada;
    inicioController.text = formatter.format(widget.ficha.fechaInicio);
    finController.text = formatter.format(widget.ficha.fechaFin);
    modalidadController.text = widget.ficha.modalidad;
    etapaController.text = widget.ficha.etapa;
    jefeController.text = widget.ficha.jefeFicha;
    ofertaController.text = widget.ficha.oferta;
  }

  @override
  void dispose() {
    idProgramaController.dispose();
    jornadaController.dispose();
    inicioController.dispose();
    finController.dispose();
    modalidadController.dispose();
    etapaController.dispose();
    jefeController.dispose();
    ofertaController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();


  void showSuccesSnackBar( BuildContext context, String successMessage ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(successMessage ))
    );
  }
  void showErrorSnackBar( BuildContext context, String errorMessage ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text( errorMessage ))
    );
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(fichasProvider, (previous, next) {
      if( !next.isLoading ) {
        if (next.errorMessage.isNotEmpty) {
          showErrorSnackBar(context, next.errorMessage);
        } else {
          showSuccesSnackBar(context, 'Ficha Actualizada correctamente');
        }
      }
    },);
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
        
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text('Editar Ficha', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),),
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
        
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FilledButton(
                        style: ButtonStyle( shape: WidgetStatePropertyAll( RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7)) ) ),
                        onPressed: ref.read( fichasProvider ).isLoading
                          ? null 
                          : (){
                            final nuevaFicha = Ficha(
                              id: widget.ficha.id,
                              idProgramaFormacion: int.parse(idProgramaController.text),
                              jornada: jornadaController.text,
                              fechaInicio: DateTime.parse(inicioController.text),
                              fechaFin: DateTime.parse(finController.text),
                              modalidad: modalidadController.text,
                              etapa: etapaController.text,
                              jefeFicha: jefeController.text,
                              oferta: ofertaController.text,
                            );

                            if( _formKey.currentState!.validate() ){
                              ref.read( fichasProvider.notifier ).updateFicha( nuevaFicha, widget.ficha.id );
                              context.pop();
                            }
                        },
                        child: Text('Editar')
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}