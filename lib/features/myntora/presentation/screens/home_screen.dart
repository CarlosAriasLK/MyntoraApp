import 'package:flutter/material.dart';
import 'package:myntora_app/features/myntora/presentation/widgets/shared/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: CustomDrawer(),

      body: Center(child: Text('Dashboard')),
    );
  }
}
