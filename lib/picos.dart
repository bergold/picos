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
      'entry': fileSystem.retainEntry(entry),
      'port': port
    };
  }
  
  String get name => entry.name;
  Future<String> get path => fileSystem.getDisplayPath(entry);
  
}

class PicoManager {
  
  List<Pico> _picos = [];
  
  PicoManager();
  
  Future<Pico> createNewPicoConfig() {
    return chooseEntry().then((entry) {
      return new PicoConfig(entry, getNextPort());
    });
  }
  
  save(Pico pico) {
    
  }
  saveAll() => _picos.forEach(save);
  
  chooseEntry() {
    var options = new ChooseEntryOptions(type: ChooseEntryType.OPEN_DIRECTORY);
    return fileSystem.chooseEntry(options).then((res) => res.entry);
  }
  
  getNextPort() {
    return 5000;
  }
  
}
