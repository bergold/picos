library picos;

import 'dart:async';
import 'dart:html' show window;
import 'package:chrome/chrome_app.dart' as chrome;
import 'package:chrome_net/server.dart' show PicoServer;
import 'storage.dart';
import 'servlet.dart';
import 'ui/pico.dart';

class Pico {
  
  static const int stateNotRunning = 0;
  static const int stateSwitching = 1;
  static const int stateRunning = 2;
  
  final PicoConfig config;
  final PicoCard card;
  final PicoView view;
  
  List _servlets;
  PicoServer server;
  
  StreamController _onStartedCtrl = new StreamController.broadcast();
  Stream get onStarted => _onStartedCtrl.stream;
  
  StreamController _onStoppedCtrl = new StreamController.broadcast();
  Stream get onStopped => _onStoppedCtrl.stream;
  
  Pico(this.config, this.card, this.view) { init(); }
  
  void init() {
    _servlets = [
      new FileServlet.fromEntry(config.entry),
      new IndexServlet.fromEntry(config.entry)
    ];
    _servlets.forEach((servlet) => servlet.onRequest.listen((r) => _onRequest(r)));
    
    initUI();
  }
  
  void initUI({ events: true }) {
    card.name = config.name;
    card.port = config.port;
    config.path.then((p) => card.path = p);
    
    state = stateNotRunning;
    
    if (events) {
      card
        ..onClickStart.listen(start)
        ..onClickStop.listen(stop)
        ..onClickOpen.listen(open)
        ..onClickClear.listen(view.clear);
        
      onStarted.listen((_) {
        state = stateRunning;
      });
      onStopped.listen((_) {
        state = stateNotRunning;
      });
    }
  }
  
  start([_]) {
    state = stateSwitching;
    
    PicoServer.createServer(config.port).then((s) {
      _servlets.forEach((servlet) => s.addServlet(servlet));
      server = s;
      
      server.getInfo().then(_onStartedCtrl.add);
    });
  }
  
  stop([_]) {
    state = stateSwitching;
    view.clear();
    
    if (server == null) return;
    server.dispose().then(_onStoppedCtrl.add);
    server = null;
  }
  
  open([_]) {
    window.open('http://127.0.0.1:${config.port}', '_blank');
  }
  
  set state(int v) {
    if (
      (v != stateNotRunning) &&
      (v != stateSwitching) &&
      (v != stateRunning)
    ) throw new ArgumentError('Invalid state');
    card.state = v;
    view.state = v;
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
