library picos.servlet;

import 'dart:async';
import 'package:chrome/chrome_app.dart';
import 'package:chrome_net/server.dart' show PicoServlet, HttpRequest, HttpResponse;

class RequestInfo {
  
  final Completer completer = new Completer();
  
  final HttpRequest request;
  Future<HttpResponse> get response => completer.future;
  
  RequestInfo(this.request);
  
}

class FileServlet extends PicoServlet {

  final DirectoryEntry entry;
  
  StreamController _onRequestCtrl = new StreamController.broadcast();
  Stream get onRequest => _onRequestCtrl.stream;
  
  StaticServlet.fromEntry(this.entry);

  bool canServe(HttpRequest request) => request.method == 'GET' && !request.uri.path.endsWith('/');

  Future<HttpResponse> serve(HttpRequest request) {
    var path = request.uri.path.substring(1);

    var requestInfo = new Requestnfo(request);
    _onRequestCtrl.add(requestInfo);

    return entry.getFile(path).then((file) {
      return (file as ChromeFileEntry).readText();
    }).then((text) {
      var response = new HttpResponse.ok()..setContentTypeFrom(path)..setContent(text);
      return response;
    }).catchError((e) {
      var response = new HttpResponse.notFound();
      return response;
    }).then((response) {
      requestInfo.completer.complete(response);
      return response;
    });
  }

}

class IndexServlet extends PicoServlet {

  final DirectoryEntry entry;
  
  StreamController _onRequestCtrl = new StreamController.broadcast();
  Stream get onRequest => _onRequestCtrl.stream;
  
  StaticServlet.fromEntry(this.entry);

  bool canServe(HttpRequest request) => request.method == 'GET' && request.uri.path.endsWith('/');

  Future<HttpResponse> serve(HttpRequest request) {
    var path = request.uri.path.substring(1) + 'index.html';

    var requestInfo = new Requestnfo(request);
    _onRequestCtrl.add(requestInfo);

    return entry.getFile(path).then((file) {
      return (file as ChromeFileEntry).readText();
    }).then((text) {
      var response = new HttpResponse.ok()..setContentTypeFrom(path)..setContent(text);
      return response;
    }).catchError((e) {
      var response = new HttpResponse.notFound();
      return response;
    }).then((response) {
      requestInfo.completer.complete(response);
      return response;
    });
  }

}
