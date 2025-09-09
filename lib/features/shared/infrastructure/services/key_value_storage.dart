

abstract class KeyValueStorage {

  Future<T?> getValue<T>(String key);

  Future<void> setKeyValue<T>(String key, T value);

  Future<bool> removeKey(String key);
}