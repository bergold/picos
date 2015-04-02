library serve.static_servlet;

import 'dart:html' as html;
import 'dart:async';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:chrome_net/server.dart' show PicoServlet, HttpRequest, HttpResponse, HttpStatus;

class StaticServlet extends PicoServlet {

  final chrome.DirectoryEntry entry;
  ServletLogger _logger = new _NullLogger();
  int requestId = 0;

  static Future<StaticServlet> choose() {
    var options = new chrome.ChooseEntryOptions(type: chrome.ChooseEntryType.OPEN_DIRECTORY);
    return chrome.fileSystem.chooseEntry(options).then((res) => res.entry).then((entry) => new StaticServlet.fromEntry(entry as chrome.DirectoryEntry));
  }
  static Future<StaticServlet> restore(String id) {
    return chrome.fileSystem.restoreEntry(id).then((entry) => new StaticServlet.fromEntry(entry as chrome.DirectoryEntry));
  }

  StaticServlet.fromEntry(this.entry);

  String get retainId => chrome.fileSystem.retainEntry(entry);
  String get name => entry.name;
  Future<String> get path => chrome.fileSystem.getDisplayPath(entry);

  void setLogger(ServletLogger logger) {
    _logger = logger == null ? new _NullLogger() : logger;
  }

  bool canServe(HttpRequest request) => true;

  Future<HttpResponse> serve(HttpRequest request) {
    var id = requestId++;
    var file = request.uri.path.substring(1);

    _logger.logStart(id, request);

    return entry.getFile(file).then((fe) {
      return (fe as chrome.ChromeFileEntry).readText();
    }).then((text) {
      var response = new HttpResponse.ok()..setContent(text);
      _logger.logComplete(id, response);
      return response;
    }).catchError((e) {
      var response = new HttpResponse.notFound();
      _logger.logComplete(id, response);
      return response;
    }, test: (e) => e is html.DomError && e.name == 'NotFoundError').catchError((e) {
      _logger.logError(id, e);
      return new HttpResponse(statusCode: HttpStatus.INTERNAL_SERVER_ERROR);
    });
  }

}

abstract class ServletLogger {
  void logStart(int id, HttpRequest request);
  void logComplete(int id, HttpResponse response);
  void logError(int id, error);
}

class _NullLogger extends ServletLogger {
  void logStart(int id, HttpRequest request) {}
  void logComplete(int id, HttpResponse response) {}
  void logError(int id, error) {}
}
