library picos;

import 'dart:async';
import 'package:chrome/chrome_app.dart';
import 'package:chrome_net/server.dart' show PicoServer;
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
    _servlets.forEach((servlet) => servlet.onRequest.listen(_onRequest));
    
    initUI();
  }
  
  void initUI() {
    view.name = config.name;
    card.name = config.name;
    card.port = config.port;
    config.path.then((p) => card.path = p);
    
    card.onClickStart.listen((e) {
      start()
        .then((s) => s.getInfo())
        .then((info) => print('Server running on ${info.localAddress}:${info.localPort}'));
    });
  }
  
  start() {
    return PicoServer.createServer(config.port).then((s) {
      _servlets.forEach((servlet) => s.addServlet(servlet));
      return server = s;
    });
  }
  
  stop() {
    if (server != null) server.dispose();
  }
  
  _onRequest(requestInfo) {
    print(requestInfo.request);
    requestInfo.response.then((response) => print(response));
  }
  
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
  
  void save(PicoConfig pico) {
    
  }
  void saveAll() => _picos.forEach(save);
  
  Future<PicoConfig> restore(id) {
    // Todo: read storage pico_{id} and create new picoconfig from json.
  }
  Stream<PicoConfig> restoreAll() {
    // Todo: read storage pico_index and call restore for each entry.
    return new Stream.fromIterable(_picos);
  }
  
  chooseEntry() {
    var options = new ChooseEntryOptions(type: ChooseEntryType.OPEN_DIRECTORY);
    return fileSystem.chooseEntry(options).then((res) => res.entry);
  }
  
  getNextPort() {
    return 5000;
  }
  
}
