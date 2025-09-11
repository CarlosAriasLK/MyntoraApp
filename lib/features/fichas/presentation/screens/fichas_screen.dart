import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myntora_app/features/fichas/domain/domain.dart';
import 'package:myntora_app/features/fichas/presentation/providers/fichas_provider.dart';
import 'package:myntora_app/features/fichas/presentation/widgets/custom_creating_modal.dart';
import 'package:myntora_app/features/fichas/presentation/widgets/custom_editing_modal.dart';


class FichasScreen extends ConsumerWidget {
  const FichasScreen({super.key});

    @override
    Widget build(BuildContext context, ref) {

    final fichasState = ref.watch( fichasProvider );
    if ( fichasState.isLoading ) return Center(child: CircularProgressIndicator(),);
    if (fichasState.errorMessage.isNotEmpty) return Center(child: Text('Error: ${fichasState.errorMessage}'));

    final fichas = fichasState.fichas ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Fichas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: FilledButton(
              onPressed: (){
                showDialog(
                  context: context, 
                  builder: (context) => CustomCreatingModal(),
                );
              }, 
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7))
                )
              ),
              child: Text('Cargar fichas'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _CustomDateTable(fichas: fichas,),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomDateTable extends ConsumerWidget {
  final List<Ficha> fichas;
  final DateFormat formater = DateFormat('yyyy-MM-dd');
  _CustomDateTable({required this.fichas});

  @override
  Widget build(BuildContext context, ref) {
    return DataTable(
      
      dividerThickness: 1.2,
    
      border: TableBorder.symmetric(
        inside: BorderSide( color: Colors.grey.shade200, width: 1)
      ),
    
      headingRowColor: WidgetStatePropertyAll( Color.fromARGB(20, 0, 200, 10) ),
      headingTextStyle: const TextStyle( fontWeight: FontWeight.bold, fontSize: 15, ),
    
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
            DataCell(Text(ficha.idProgramaFormacion.toString())),
            DataCell(Text(ficha.jornada)),
            DataCell(Text(formater.format(ficha.fechaInicio) )),
            DataCell(Text(formater.format(ficha.fechaFin) )),
            DataCell(Text(ficha.modalidad)),
            DataCell(Text(ficha.etapa)),
            DataCell(Text(ficha.jefeFicha)),
            DataCell(Text(ficha.oferta)),
            DataCell(
              Row(
                children: [

                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomEditingModal( ficha: ficha, );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),

                  IconButton(
                    onPressed: (){
                      print(ficha.id.toString());
                    },
                    icon: Icon(Icons.delete_forever)
                  ),
                ],
              )
            ),
          ],
        );
      }).toList(),
    );
  }
}




