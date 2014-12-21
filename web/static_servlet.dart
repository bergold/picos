library serve.static_servlet;

import 'dart:html' as html;
import 'dart:async';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:chrome_net/server.dart' show PicoServlet, HttpRequest, HttpResponse, HttpStatus;

class StaticServlet extends PicoServlet {

  final chrome.DirectoryEntry entry;
  ServletLogger logger = new _NullLogger();
  int requestId = 0;

  static Future<StaticServlet> choose() {
    var options = new chrome.ChooseEntryOptions(type: chrome.ChooseEntryType.OPEN_DIRECTORY);
    return chrome.fileSystem.chooseEntry(options).then((res) => res.entry).then((entry) => new StaticServlet.fromEntry(entry as chrome.DirectoryEntry));
  }
  static Future<StaticServlet> restore(String id) {
    return chrome.fileSystem.restoreEntry(id).then((entry) => new StaticServlet.fromEntry(entry as chrome.DirectoryEntry));
  }

  StaticServlet.fromEntry(this.entry);

  bool canServe(HttpRequest request) => true;

  Future<HttpResponse> serve(HttpRequest request) {
    var id = requestId++;
    var file = request.uri.path.substring(1);

    print('[$id] start request');
    //html.window.performance.mark('serve_start_$id');
    //logger.log(id, request: request);

    return entry.getFile(file).then((fe) {
      return (fe as chrome.ChromeFileEntry).readText();
    }).then((text) {
      var response = new HttpResponse.ok()..setContent(text);
      print('[$id] success request');
      //html.window.performance.mark('serve_end_$id');
      //html.window.performance.measure('serve_$id', 'serve_start_$id', 'serve_end_$id');
      //logger.log(id, response: response, measure: 'serve_$id');
      return response;
    }).catchError((e) {
      print('[$id] error request: not found');
      //html.window.performance.mark('serve_end_$id');
      //html.window.performance.measure('serve_$id', 'serve_start_$id', 'serve_end_$id');
      //logger.log(id, error: e, measure: 'serve_$id');
      return new HttpResponse.notFound();
    }, test: (e) => e is html.DomError && e.name == 'NotFoundError').catchError((e) {
      print('[$id] error: $e');
      return new HttpResponse(statusCode: HttpStatus.INTERNAL_SERVER_ERROR);
    });
  }

}

abstract class ServletLogger {
  void log(int id, { HttpRequest request, HttpResponse response, error, String measure });
}

class _NullLogger extends ServletLogger {
  void log(int id, { HttpRequest request, HttpResponse response, error, String measure }) { }
}
