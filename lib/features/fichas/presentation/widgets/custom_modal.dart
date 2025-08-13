import 'package:flutter/material.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';

class CustomModal extends StatefulWidget {
  final Ficha ficha;
  final Function(Ficha) onActualizar;

  const CustomModal({
    Key? key,
    required this.ficha,
    required this.onActualizar,
  }) : super(key: key);

  @override
  State<CustomModal> createState() => _CustomModal();
}

class _CustomModal extends State<CustomModal> {
  late TextEditingController jornadaController;
  late TextEditingController modalidadController;
  late TextEditingController etapaController;
  late TextEditingController jefeFichaController;

  @override
  void initState() {
    super.initState();
    jornadaController = TextEditingController(text: widget.ficha.jornada);
    modalidadController = TextEditingController(text: widget.ficha.modalidad);
    etapaController = TextEditingController(text: widget.ficha.etapa);
    jefeFichaController = TextEditingController(text: widget.ficha.jefe_ficha);
  }

  @override
  void dispose() {
    jornadaController.dispose();
    modalidadController.dispose();
    etapaController.dispose();
    jefeFichaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar ficha"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: jornadaController,
              decoration: const InputDecoration(labelText: "Jornada"),
            ),
            TextField(
              controller: modalidadController,
              decoration: const InputDecoration(labelText: "Modalidad"),
            ),
            TextField(
              controller: etapaController,
              decoration: const InputDecoration(labelText: "Etapa"),
            ),
            TextField(
              controller: jefeFichaController,
              decoration: const InputDecoration(labelText: "Jefe de ficha"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Guardar"),
          onPressed: () {
            final fichaActualizada = Ficha(
              id: widget.ficha.id,
              id_programa_formacion: widget.ficha.id_programa_formacion,
              jornada: jornadaController.text,
              fecha_inicio: widget.ficha.fecha_inicio,
              fecha_fin: widget.ficha.fecha_fin,
              modalidad: modalidadController.text,
              etapa: etapaController.text,
              jefe_ficha: jefeFichaController.text,
              oferta: widget.ficha.oferta,
            );

            widget.onActualizar(fichaActualizada);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
