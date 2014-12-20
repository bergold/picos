library serve.static_servlet;

import 'dart:async';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:chrome_net/server.dart' show PicoServlet, HttpRequest, HttpResponse;

class StaticServlet extends PicoServlet {

  final chrome.DirectoryEntry entry;

  static Future<StaticServlet> choose() {
    var options = new chrome.ChooseEntryOptions(type: chrome.ChooseEntryType.OPEN_DIRECTORY);
    return chrome.fileSystem.chooseEntry(options).then((res) => res.entry).then((entry) => new StaticServlet.fromEntry(entry as chrome.DirectoryEntry));
  }
  static Future<StaticServlet> restore(String id) {
    return chrome.fileSystem.restoreEntry(id).then((entry) => new StaticServlet.fromEntry(entry as chrome.DirectoryEntry));
  }

  StaticServlet.fromEntry(this.entry);

  bool canServe(HttpRequest request) {
    return true;
  }

  Future<HttpResponse> serve(HttpRequest request) {
    var method = request.method;
    var file = request.uri.path.substring(1);
    print('$method $file');
    return entry.getFile(file).then((fe) {
      print("got to start read");
      return (fe as chrome.ChromeFileEntry).readText();
    }).then((text) {
      print("read: $text");
      return new HttpResponse.ok()..setContent(text);
    }).catchError((e) {
      print(e);
      return new HttpResponse.notFound();
    });
  }

}
