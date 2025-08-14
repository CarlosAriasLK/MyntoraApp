

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/presentation/presentation.dart';

class CustomModal extends ConsumerStatefulWidget {
  final Ficha ficha;
  const CustomModal({super.key, required this.ficha});

  @override
  CustomModalState createState() => CustomModalState();
}

class CustomModalState extends ConsumerState<CustomModal> {

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
    idProgramaController.text = widget.ficha.id_programa_formacion.toString();
    jornadaController.text = widget.ficha.jornada;
    inicioController.text = formatter.format(widget.ficha.fecha_fin);
    finController.text = formatter.format(widget.ficha.fecha_fin);
    modalidadController.text = widget.ficha.modalidad;
    etapaController.text = widget.ficha.etapa;
    jefeController.text = widget.ficha.jefe_ficha;
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

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            Text('Editar Ficha', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),),
            Form(
              child: Column(
                children: [

                  SizedBox(height: 10,),
                  TextFormField(
                    controller: idProgramaController,
                    decoration: InputDecoration(
                        labelText: 'Programa de formación',
                        border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: jornadaController,
                    decoration: InputDecoration(
                        labelText: 'Jornada',
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: inicioController,
                    decoration: InputDecoration(
                        hint: Text(widget.ficha.id.toString()),
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: finController,
                    decoration: InputDecoration(
                        hint: Text(widget.ficha.fecha_fin.toString()),
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: modalidadController,
                    decoration: InputDecoration(
                        hint: Text(widget.ficha.modalidad),
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: etapaController,
                    decoration: InputDecoration(
                        hint: Text(widget.ficha.etapa),
                        border: OutlineInputBorder()
                    ),
                  ),

                  SizedBox(height: 10,),
                  TextFormField(
                    controller: jefeController,
                    decoration: InputDecoration(
                        hint: Text(widget.ficha.jefe_ficha),
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(10) )
                    ),
                  ),

                  SizedBox(height: 10,),
                  TextFormField(
                    controller: ofertaController,
                    decoration: InputDecoration(
                        hint: Text(widget.ficha.oferta),
                        border: OutlineInputBorder()
                    ),
                  ),
                  
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FilledButton(
                      onPressed: ref.read( fichasProvider ).isLoading
                        ? null :
                        (){
                        final nuevaFicha = Ficha(
                          id: widget.ficha.id,
                          id_programa_formacion: int.parse(idProgramaController.text),
                          jornada: jornadaController.text,
                          fecha_inicio: DateTime.parse(inicioController.text),
                          fecha_fin: DateTime.parse(finController.text),
                          modalidad: modalidadController.text,
                          etapa: etapaController.text,
                          jefe_ficha: jefeController.text,
                          oferta: ofertaController.text,
                        );
                        ref.read( fichasProvider.notifier ).updateFicha( nuevaFicha, widget.ficha.id );
                        context.pop(context);

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
    );
  }
}