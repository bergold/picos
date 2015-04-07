library picos;

import 'package:chrome/chrome_app.dart';
import 'ui/card.dart';
import 'ui/view.dart';

class Pico {
  
  final PicoConfig config;
  final ListItemCard card;
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
  
}
