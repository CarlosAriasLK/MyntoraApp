

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';
import 'package:myntora_app/features/usuarios/presentation/providers/user_provider.dart';

class UsuariosScreen extends ConsumerWidget {
  
  const UsuariosScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final usuariosStatus = ref.watch( usuarioProviderProvider );

    if( usuariosStatus.isLoading ){
      return Center(child: CircularProgressIndicator(),);
    }

    if( usuariosStatus.errorMessage.isNotEmpty ){
      return Center(child: Text('Error ${ usuariosStatus.errorMessage }'),);
    }

    final usuarios = usuariosStatus.usuarios ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
    
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: FilledButton(
              onPressed: (){}, 
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(7))
                )
              ),
              child: Text('Crear usuarios'),
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _CustomTableUsers(usuarios: usuarios,),
            ),
          ),
        ],
      ),

    );
  }
}

class _CustomTableUsers extends ConsumerWidget {
  final List<Usuario> usuarios;
  const _CustomTableUsers({required this.usuarios});

  @override
  Widget build(BuildContext context, ref) {

    return DataTable(
      dividerThickness: 1.2,

      border: TableBorder.symmetric(
        inside: BorderSide(color: Colors.grey.shade300, width: 1),
      ),

      headingRowColor: WidgetStatePropertyAll( Color.fromARGB(20, 0, 200, 10) ),
      headingTextStyle: const TextStyle( fontWeight: FontWeight.bold, fontSize: 15, ),

      columns: [
        DataColumn(label: Text('id')),
        DataColumn(label: Text('nombre')),
        DataColumn(label: Text('apellido')),
        DataColumn(label: Text('tipo_documento')),
        DataColumn(label: Text('nro_documento')),
        DataColumn(label: Text('correo_institucional')),
        DataColumn(label: Text('telefono')),
        DataColumn(label: Text('Acciones')),
      ], 
      rows: usuarios.map(( usuario ) {
        return DataRow(
          cells: [
            DataCell(Text(usuario.id.toString())),
            DataCell(Text(usuario.nombre)),
            DataCell(Text(usuario.apellido)),
            DataCell(Text(usuario.tipoDocumento)),
            DataCell(Text(usuario.nroDocumento.toString())),
            DataCell(Text(usuario.correoInstitucional)),
            DataCell(Text(usuario.telefono.toString())),
            DataCell(

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context) => _ModalUser(usuario: usuario),);
                    }, 
                    icon: Icon(Icons.remove_red_eye)
                  ),

                  IconButton(
                    onPressed: (){}, 
                    icon: Icon(Icons.edit)
                  ),

                  IconButton(
                    onPressed: (){
                      _ModalUser(usuario: usuario,);
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


class _ModalUser extends StatelessWidget {
  final Usuario usuario;
  _ModalUser({required this.usuario});

  final DateFormat formater = DateFormat('yyyy-MM-dd'); 
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: AlertDialog(
        scrollable: true,
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(0),
        
        content: Column(
          children: [

            SizedBox(
              height: 200,
              width: 200,
              child: Image(
                image: AssetImage('assets/images/LogoSenaSinFondo.webp')
              )
            ),
            SizedBox(height: 20,),

            ListTile(
              title: Text(usuario.nombre),
              subtitle: Text('Nombre'),
            ),

            ListTile(
              title: Text(usuario.apellido),
              subtitle: Text('Apellido'),
            ),
            ListTile(
              title: Text(usuario.rol),
              subtitle: Text('Rol'),
            ),
            ListTile(
              title: Text(usuario.tipoRol),
              subtitle: Text('Tipo de Rol'),
            ),
            ListTile(
              title: Text(formater.format(usuario.fechaInicioContrato)),
              subtitle: Text('Fecha inicio del contrato'),
            ),
            ListTile(
              title: Text(formater.format(usuario.fechaInicioContrato)),
              subtitle: Text('Fecha fin del contrato'),
            ),
            ListTile(
              title: Text(usuario.telefono),
              subtitle: Text('Telefono'),
              onTap:  () {},
            ),
            
          ],
        ),
      ),



    );
  }
}