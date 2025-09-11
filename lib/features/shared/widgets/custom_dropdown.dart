


import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomDropdown extends StatefulWidget {
  final List<DropdownItem<String>> items;
  final String hintText;
  final String? valor;
  final ValueChanged<String?> onChange;
  const CustomDropdown({super.key, required this.items, required this.hintText, required this.onChange, this.valor});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {

  String? onSelectedValue;
  @override
  void initState() {
    super.initState();
    onSelectedValue = widget.valor;
  }

  final controller = MultiSelectController<String>();
  @override
  Widget build(BuildContext context) {

    return MultiDropdown<String>(
      items: widget.items,
      controller: controller,
      singleSelect: true,
      enabled: true,
      fieldDecoration: FieldDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.black87),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        )
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
      onSelectionChange: (selectedItems) {
        setState(() {
          onSelectedValue = selectedItems.isNotEmpty ? selectedItems.first : null;
        });
        if( selectedItems.isNotEmpty ){
          widget.onChange( selectedItems.first );
        } else {
          widget.onChange( null );
        }
      },

    );
  }
}