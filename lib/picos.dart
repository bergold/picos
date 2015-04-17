library picos;

import 'dart:async';
import 'package:chrome/chrome_app.dart' as chrome;
import 'package:chrome_net/server.dart' show PicoServer;
import 'storage.dart';
import 'servlet.dart';
import 'ui/pico.dart';

class Pico {
  
  final PicoConfig config;
  final PicoCard card;
  final PicoView view;
  
  List _servlets;
  PicoServer server;
  
  Pico(this.config, this.card, this.view) { init(); }
  
  void init() {
    _servlets = [
      new FileServlet.fromEntry(config.entry),
      new IndexServlet.fromEntry(config.entry)
    ];
    _servlets.forEach((servlet) => servlet.onRequest.listen((r) => _onRequest(r)));
  }
  
  start() {
    return PicoServer.createServer(config.port).then((s) {
      _servlets.forEach((servlet) => s.addServlet(servlet));
      return server = s;
    });
  }
  
  stop() {
    if (server == null) return new Future.value();
    return server.dispose();
  }
  
  _onRequest(requestInfo) {
    view.addRequest(requestInfo);
  }
  
}

class PicoConfig {
  
  final chrome.DirectoryEntry entry;
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
    var entryPromise = chrome.fileSystem.restoreEntry(entryId);
    
    return entryPromise.then((entry) => new PicoConfig(entry, port));
  }
  
  toJson() {
    return {
      'entry': id,
      'port': port
    };
  }
  
  String get id => chrome.fileSystem.retainEntry(entry);
  String get name => entry.name;
  Future<String> get path => chrome.fileSystem.getDisplayPath(entry);
  
}

class PicoManager {
  
  List<PicoConfig> _picos = [];
  PicoStorage _storage;
  
  PicoManager() {
    _storage = new PicoStorage(chrome.storage.local, 'pico');
  }
  
  Future<PicoConfig> createNewPicoConfig() {
    return chooseEntry().then((entry) {
      return new PicoConfig(entry, getAvailablePort());
    }).then((config) {
      _picos.add(config);
      save(config);
      return config;
    });
  }
  
  Future save(PicoConfig config) {
    return _storage.setItem(config.id, config.toJson());
  }
  
  Future remove(PicoConfig config) {
    return _storage.removeItem(config.id);
  }
  
  Future<PicoConfig> restoreAll() {
    return _storage.getIndex().then((index) {
      return _storage.getAll(index);
    }).then((items) {
      var all = items.map((item) {
        return PicoConfig.fromJson(item).then((config) {
          _picos.add(config);
          return config;
        });
      });
      return Future.wait(all);
    });
  }
  
  chooseEntry() {
    var options = new chrome.ChooseEntryOptions(type: chrome.ChooseEntryType.OPEN_DIRECTORY);
    return chrome.fileSystem.chooseEntry(options).then((res) => res.entry);
  }
  
  getAvailablePort() {
    var port = 5000;
    var testPort = (p) => (p.port == port);
    while (_picos.any(testPort)) port++;
    return port;
  }
  
}
