


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/programas/infrastructure/infrastructure.dart';

final programaRepositoryProvider = StateProvider((ref){
  final datasource = ProgramaDatasourceImpl();
  return ProgramaRepositoryImpl(datasource: datasource);
});