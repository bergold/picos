library picos.storage;

import 'package:chrome/chrome_app.dart';

class PicoStorage {
  
  final StorageArea area;
  final String namespace;
  
  PicoStorage(this.area, this.namespace);
  
  getIndex() {
    var key = '${namespace}_index';
    return area.get(key).then((result) {
      return result[key] != null ? result[key] : [];
    });
  }
  
  getAll(index) {
    var keys = index.map((id) => '${namespace}_$id');
    return area.get(keys).then((result) => result.values);
  }
  
  setItem(id, value) {
    return area.set({
      '${namespace}_$id': value
    }).then((_) {
      return getIndex();
    }).then((index) {
      if (!index.contains(id)) index.add(id);
      return index;
    }).then((index) {
      return updateIndex(index);
    });
  }
  
  removeItem(id) {
    return getIndex().then((index) {
      index.remove(id);
      return index;
    }).then((index) {
      return updateIndex(index);
    }).then((_) {
      return area.remove('${namespace}_$id');
    });
  }
  
  updateIndex(index) {
    return area.set({
      '${namespace}_index': index
    });
  }
  
}
