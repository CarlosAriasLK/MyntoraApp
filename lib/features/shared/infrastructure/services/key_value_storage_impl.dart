


import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_storage.dart';

class KeyValueStorageImpl extends KeyValueStorage {

  @override
  Future<T?> getValue<T>(String key) async{
    final prefs = await SharedPreferences.getInstance(); 

    switch (T) {
      case int:
        return prefs.getInt(key) as T?;
      case String:
        return prefs.getString(key) as T?;

      default:
        throw UnimplementedError();
    }
  }
  

  @override
  Future<void> setKeyValue<T>(String key, T value) async{
    final prefs = await SharedPreferences.getInstance();

    switch (T) {
      case int:
        prefs.setInt(key, value as int);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      default:
      throw UnimplementedError();
    }
  }


  @override
  Future<bool> removeKey(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

}