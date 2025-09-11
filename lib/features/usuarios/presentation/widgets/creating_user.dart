

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';
import 'package:myntora_app/features/usuarios/presentation/providers/user_provider.dart';

class CreatingUser extends ConsumerStatefulWidget {
  const CreatingUser({super.key});
  @override
  CreatingUserState createState() => CreatingUserState();
}

class CreatingUserState extends ConsumerState<CreatingUser> {
  final _formKey = GlobalKey<FormState>();

  final nombreInput = TextEditingController();
  final apellidoInput = TextEditingController();
  final numeroDocumentoInput = TextEditingController();
  final correoInput = TextEditingController();
  final telefonoInput = TextEditingController();

  String? tipoDocumentoInput;
  String? rolInput;
  String? tipoContratoInput;
  String? tipoRolInput;

  DateTime? fechaInicioInput;
  DateTime? fechaFinInput;

  final formater = DateFormat('yyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      height: size.height * 0.8,
      color: Colors.white,

      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            
            children: [
        
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Crear Nuevo Usuario', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextFormField(  
                  controller: nombreInput,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Nombre")
                  ),
                  validator: (value) {
                    if( value == null || value.isEmpty ){
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextFormField(  
                  controller: apellidoInput,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Apellido")
                  ),
                  validator: (value) {
                    if( value == null || value.isEmpty ){
                      return 'El apellido es requerido';
                    }
                    return null;
                  },
                ),
              ),
              
              Padding(
                padding: EdgeInsetsGeometry.all(8.0),
                child: CustomCreatingUser(
                  hinText: 'Tipo de Documento',
                  valor: tipoDocumentoInput,
                  items: [
                    DropdownItem(label: 'Cedula de Ciudadania', value: 'Cedula'),
                    DropdownItem(label: 'Pasaporte', value: 'Pasaporte'),
                  ],
                  onChange: (value) {
                    setState(() {
                      tipoDocumentoInput = value;
                    });
                  },
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextFormField(  
                  controller: numeroDocumentoInput,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Numero de Documento")
                  ),
                  validator: (value) {
                    if( value == null || value.length < 9 ){
                      return 'El documento es requerido';
                    }
                    return null;
                  },
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextFormField(  
                  controller: correoInput,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Correo Institucional")
                  ),
                  validator:(value) {
                    if( value == null ){
                      return 'El Correo Institucional es requerido';
                    }
                    if( !value.contains('@') ) {
                      return 'Correo no valido';
                    }
                    return null;
                  },
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextFormField(  
                  controller: telefonoInput,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Telefono")
                  ),
                  validator:(value) {
                    if( value == null || value.length < 9 ){
                      return 'El telefono es requerido';
                    }
                    return null;
                  },
                ),
              ),
        
              Padding(
                padding: EdgeInsetsGeometry.all(8.0),
                child: CustomCreatingUser(
                  hinText: 'Rol',
                  valor: rolInput,
                  items: [
                    DropdownItem(label: 'Instructor', value: 'Instructor'),
                    DropdownItem(label: 'Coordinador', value: 'Coordinador'),
                  ],
                  onChange: (value) {
                    setState(() {
                      rolInput = value;
                    });
                  },
                ),
              ),

              rolInput == 'Instructor' ? 
                Padding(
                  padding: EdgeInsetsGeometry.all(8.0),
                  child: CustomCreatingUser(
                    hinText: 'Tipo Contrato',
                    valor: tipoContratoInput,
                    items: [
                      DropdownItem(label: 'Contratista', value: 'Contratista'),
                      DropdownItem(label: 'Planta', value: 'Planta'),
                    ],
                    onChange: (value) {
                      setState(() {
                        tipoContratoInput = value;
                      });
                    },
                  ),
                )
              : SizedBox(),

              rolInput == 'Instructor'?
              Padding(
                padding: EdgeInsetsGeometry.all(8.0),
                child: CustomCreatingUser(
                  hinText: 'Tipo Rol',
                  valor: tipoRolInput,
                  items: [
                    DropdownItem(label: 'Técnico', value: 'Técnico'),
                    DropdownItem(label: 'Transversal', value: 'Transversal'),
                    DropdownItem(label: 'Clave', value: 'Clave'),
                  ],
                  onChange: (value) {
                    setState(() {
                      tipoRolInput = value;
                    });
                  },
                ),
              ) 
              : SizedBox(),

              tipoContratoInput == 'Contratista' ?
              Padding(
                padding: EdgeInsetsGeometry.all(8.0),
                child: DateTimeFormField(
                  mode: DateTimeFieldPickerMode.date,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  
                  initialValue: fechaInicioInput,
                  decoration: const InputDecoration(
                    labelText: 'Fecha Inicio de Contrato',
                    border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(12)) )
                  ),
                  onChanged: (DateTime? value) { fechaInicioInput = value; },
                  validator: (value) {
                    if( value == null ) {
                      return 'La fecha es requerida';
                    }
                    return null;
                  },
                ),
              ): SizedBox(),

              tipoContratoInput == 'Contratista' ?
              Padding(
                padding: EdgeInsetsGeometry.all(8.0),
                child: DateTimeFormField(
                  mode: DateTimeFieldPickerMode.date,
                  style: TextStyle(fontSize: 16, color: Colors.black),

                  initialValue: fechaFinInput,
                  decoration: const InputDecoration(
                    labelText: 'Fecha Fin de Contrato',
                    border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(12)) )
                  ),

                  onChanged: (DateTime? value) { fechaFinInput = value; },
                  validator: (value) {
                    if( value == null ) {
                      return 'La fecha es requerida';
                    }
                    return null;
                  },
                ),
              ): SizedBox(),
        
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 30),
                  child: FilledButton(
                    style: ButtonStyle( shape: WidgetStatePropertyAll( RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(7) ) ) ),
                    onPressed: (){
                      if( _formKey.currentState!.validate() ) {
                        
                        final nuevoUsuario = Usuario(
                          nombre: nombreInput.text, 
                          apellido: apellidoInput.text, 
                          tipoDocumento: tipoDocumentoInput ?? '', 
                          nroDocumento: numeroDocumentoInput.text, 
                          correoInstitucional: correoInput.text, 
                          rol: rolInput ?? '', 
                          tipoContrato: tipoContratoInput ?? '', 
                          tipoRol: tipoRolInput ?? '', 
                          fechaInicioContrato: formater.format( fechaInicioInput ?? DateTime.now() ) , 
                          fechaFinContrato: formater.format( fechaFinInput ?? DateTime.now() ), 
                          telefono: telefonoInput.text
                        );
                        ref.read(usuarioProviderProvider.notifier).createUser(nuevoUsuario);
                        context.pop();
                      }
                    }, 
                    child: Text('Crear usuario')
                  ),
                ),
              )
        
            ],
          )
        ),
      )
    );
  }
}


class CustomCreatingUser extends StatefulWidget {
  final List<DropdownItem<String>> items;
  final ValueChanged<String?> onChange;
  final String? valor;
  final String hinText;

  const CustomCreatingUser({super.key, required this.items, required this.valor, required this.onChange, required this.hinText});

  @override
  State<CustomCreatingUser> createState() => _CustomCreatingUserState();
}

class _CustomCreatingUserState extends State<CustomCreatingUser> {
  final controller = MultiSelectController<String>();
  String? itemSelected;

  @override
  void initState() {
    super.initState();
    itemSelected = widget.valor;
  }
  
  @override
  Widget build(BuildContext context) {
    return  MultiDropdown(
      items: widget.items,
      controller: controller,
      singleSelect: true,

      fieldDecoration: FieldDecoration(
        hintText: widget.hinText,
        hintStyle: const TextStyle(color: Colors.black87),
        showClearIcon: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a country';
        }
        return null;
      },

      onSelectionChange: (selectedItems) {
        setState(() {
          itemSelected = selectedItems.isNotEmpty ? selectedItems.last : null;
        });
        if( selectedItems.isNotEmpty ) {
          widget.onChange(selectedItems.first);
        } else {
          widget.onChange(null);
        }
      },

    );
  }
}