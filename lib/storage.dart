library picos.storage;

import 'package:chrome/chrome_app.dart';

class PicoStorage {
  
  final StorageArea area;
  final String namespace;
  
  PicoStorage(this.area, this.namespace);
  
  getIndex() {
    var key = namespace + '_index';
    return area.get(key).then((result) {
      return result[key] != null ? result[key] : [];
    });
  }
  
  getAll(index) {
    var keys = index.map((id) => '${namespace}_$id');
    return area.get(keys).then((result) => result.values);
  }
  
}
