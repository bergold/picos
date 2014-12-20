library serve.fs;

import 'dart:async';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:chrome_net/server.dart' show PicoServlet, HttpRequest, HttpResponse;

class Fs implements PicoServlet {

  final chrome.Entry entry;

  static Future<Fs> choose() {
    var options = new chrome.ChooseEntryOptions(type: chrome.ChooseEntryType.OPEN_DIRECTORY);
    return chrome.fileSystem.chooseEntry(options).then((res) => res.entry).then((entry) => new Fs.fromEntry(entry));
  }
  static Future<Fs> restore(String id) {
    return chrome.fileSystem.restoreEntry(id).then((entry) => new Fs.fromEntry(entry));
  }

  Fs.fromEntry(this.entry);

  bool canServe(HttpRequest request) {
    return true;
  }

  Future<HttpResponse> serve(HttpRequest request) {

  }

}
