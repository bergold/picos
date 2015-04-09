library picos.servlet;

import 'dart:async';
import 'package:chrome/chrome_app.dart';
import 'package:chrome_net/server.dart' show PicoServlet, HttpRequest, HttpResponse;

class RequestInfo {
  
  final HttpRequest request;
  final Future<HttpResponse> response;
  
  RequestInfo(this.request, this.response);
  
}

class FileServlet extends PicoServlet {

  final DirectoryEntry entry;
  
  StreamController _onRequestCtrl = new StreamController.broadcast();
  Stream get onRequest => _onRequestCtrl.stream;
  
  FileServlet.fromEntry(this.entry);

  bool canServe(HttpRequest request) => request.method == 'GET' && !request.uri.path.endsWith('/');

  Future<HttpResponse> serve(HttpRequest request) {
    var path = request.uri.path.substring(1);
    
    var responseCompleter = new Completer();
    var requestInfo = new RequestInfo(request, responseCompleter.future);
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
      responseCompleter.complete(response);
      return response;
    });
  }

}

class IndexServlet extends PicoServlet {

  final DirectoryEntry entry;
  
  StreamController _onRequestCtrl = new StreamController.broadcast();
  Stream get onRequest => _onRequestCtrl.stream;
  
  IndexServlet.fromEntry(this.entry);

  bool canServe(HttpRequest request) => request.method == 'GET' && request.uri.path.endsWith('/');

  Future<HttpResponse> serve(HttpRequest request) {
    var path = request.uri.path.substring(1) + 'index.html';

    var responseCompleter = new Completer();
    var requestInfo = new RequestInfo(request, responseCompleter.future);
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
      responseCompleter.complete(response);
      return response;
    });
  }

}
