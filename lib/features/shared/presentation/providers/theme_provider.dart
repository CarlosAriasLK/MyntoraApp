

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class Theme extends _$Theme {
  @override
  bool build() {
    return false;
  }

  void changeTheme(){
    state = !state;
  }
}