import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:myntora_app/features/programas/domain/domain.dart';
import 'package:myntora_app/features/programas/presentation/providers/programa_provider.dart';

class ProgramasScreen extends ConsumerStatefulWidget {
  const ProgramasScreen({super.key});

  @override
  ProgramasScreenState createState() => ProgramasScreenState();
}

class ProgramasScreenState extends ConsumerState<ProgramasScreen> {

  @override
  void initState() {
    super.initState();
    final token = ref.read(authProvider).user?.token;
    if( token != null ) {
      ref.read( programaProvider(token).notifier ).showProgramas();
    }
  }


  @override
  Widget build(BuildContext context) {

    final token = ref.watch( authProvider ).user?.token;
    if( token == null ){
      return Center(child: CircularProgressIndicator());
    }

    final programaState = ref.watch(programaProvider(token));

    if( programaState.isLoading ){
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Programas de formacion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            SizedBox(height: 10,),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _ProgramasDataTable( programas: programaState.programas! ),
            ),

          ],
        ),
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

        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10)
        ),
        columns: [
          DataColumn(label: Text('Id')),
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Nivel')),
          DataColumn(label: Text('Estado')),
        ],
        rows: programas.map((programa) {
          return DataRow(
            cells: [
              DataCell(Text(programa.id.toString())),
              DataCell(Text(programa.nombre)),
              DataCell(Text(programa.estado)),
              DataCell(Text(programa.nivel)),
            ]
          );
        }).toList(),
    );
  }

}