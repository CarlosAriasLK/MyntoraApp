import 'package:flutter/material.dart';

class JuiciosEvaluativosScreen extends StatelessWidget {
  JuiciosEvaluativosScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('Juicios Evaluativos'), ),
    );
  }
}