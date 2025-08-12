


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/fichas/infrastructure/infrastructure.dart';

final fichasRepositoryProvider = StateProvider((ref) {
  final datasource = FichasDatasourceImpl();
  return FichasRepositoryImpl(datasource: datasource);
});