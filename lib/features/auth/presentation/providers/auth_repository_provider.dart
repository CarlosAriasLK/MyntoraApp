


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myntora_app/features/auth/infrastructure/infrastructure.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(datasource: AuthDatasourceImpl() ) ;
});



