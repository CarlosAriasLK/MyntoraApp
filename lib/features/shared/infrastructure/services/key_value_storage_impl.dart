

import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage.dart';

class KeyValueStorageImpl extends KeyValueStorage {

  @override
  Future<T?> getValue<T>(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) as T?;
  }
  
  @override
  Future<void> setKeyValue<T>(String key, T value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value as String);
  }

  @override
  Future<bool> removeKey(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

}