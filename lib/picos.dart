library picos;

import 'dart:async';
import 'package:chrome/chrome_app.dart';
import 'ui/pico.dart';

class Pico {
  
  final PicoConfig config;
  final PicoCard card;
  final PicoView view;
  
  Pico(this.config, this.card, this.view);
  
}

class PicoConfig {
  
  final DirectoryEntry entry;
  int port;
  
  PicoConfig(
    this.entry,
    this.port
  );
  
  static fromJson(json) {
    var port = json['port'];
    port = port == null ? 0 : port;
    
    var entryId = json['entry'];
    if (entryId == null) throw new ArgumentError('Entry is required');
    var entryPromise = fileSystem.restoreEntry(entryId);
    
    return entryPromise.then((entry) => new PicoConfig(entry, port));
  }
  
  toJson() {
    return {
      'entry': id,
      'port': port
    };
  }
  
  String get id => fileSystem.retainEntry(entry);
  String get name => entry.name;
  Future<String> get path => fileSystem.getDisplayPath(entry);
  
}

class PicoManager {
  
  List<PicoConfig> _picos = [];
  
  PicoManager();
  
  Future<PicoConfig> createNewPicoConfig() {
    return chooseEntry().then((entry) {
      return new PicoConfig(entry, getNextPort());
    });
  }
  
  void save(Pico pico) {
    
  }
  void saveAll() => _picos.forEach(save);
  
  Future<PicoConfig> restore(id) {
    // Todo: read storage pico_{id} and create new picoconfig from json.
  }
  Stream<PicoConfig> restoreAll() {
    // Todo: read storage pico_index and call restore for each entry.
    return F_picos;
  }
  
  chooseEntry() {
    var options = new ChooseEntryOptions(type: ChooseEntryType.OPEN_DIRECTORY);
    return fileSystem.chooseEntry(options).then((res) => res.entry);
  }
  
  getNextPort() {
    return 5000;
  }
  
}
