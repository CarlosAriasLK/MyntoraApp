import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/presentation/providers/fichas_provider.dart';
import 'package:myntora_app/features/fichas/presentation/widgets/custom_modal.dart';

class FichasScreen extends ConsumerStatefulWidget {
  const FichasScreen({super.key});

  @override
  FichasScreenState createState() => FichasScreenState();
}

class FichasScreenState extends ConsumerState<FichasScreen> {

  @override
  void initState() {
    super.initState();
    ref.read( fichasProvider.notifier ).showFichas();
  }

  @override
  Widget build(BuildContext context) {
    final fichasState = ref.watch(fichasProvider);

    if (fichasState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final fichas = fichasState.fichas ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Fichas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox( width: 140, child: FilledButton(
                  style: ButtonStyle( 
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                      elevation: WidgetStatePropertyAll(2)
                  ),
                  onPressed: (){},
                  child: Text('Cargar')),
              )
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _CustomDateTable( fichas: fichas ),
          ),
        ],
      ),
    );
  }
}

class _CustomDateTable extends StatelessWidget {
  final List<Ficha> fichas;
  _CustomDateTable({required this.fichas});

  final DateFormat formater = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),

        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Programa')),
          DataColumn(label: Text('Jornada')),
          DataColumn(label: Text('Inicio')),
          DataColumn(label: Text('Fin')),
          DataColumn(label: Text('Modalidad')),
          DataColumn(label: Text('Etapa')),
          DataColumn(label: Text('Jefe Ficha')),
          DataColumn(label: Text('Oferta')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: fichas.map((ficha) {
          return DataRow(
            cells: [
              DataCell(Text(ficha.id.toString())),
              DataCell(Text(ficha.id_programa_formacion.toString())),
              DataCell(Text(ficha.jornada ?? '')),
              DataCell(Text(formater.format(ficha.fecha_inicio) )),
              DataCell(Text(formater.format(ficha.fecha_fin) )),
              DataCell(Text(ficha.modalidad ?? '')),
              DataCell(Text(ficha.etapa ?? '')),
              DataCell(Text(ficha.jefe_ficha ?? '')),
              DataCell(Text(ficha.oferta ?? '')),
              DataCell(
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.2),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomModal(
                                ficha: ficha,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsGeometry.all(0.2),
                        child: IconButton(
                            onPressed: (){
                              print(ficha.id.toString());
                            },
                            icon: Icon(Icons.delete_forever)
                        ),
                    ),
                  ],
                )
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
