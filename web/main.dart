import 'dart:html' as html;

import 'package:chrome_net/server.dart' show PicoServer, ServerLogger, HttpRequest, HttpResponse;

import 'static_servlet.dart';

var port = 5000;
var staticServlet;

// UI elements
var btnFab;
var lstLogger;

void main() {
  StaticServlet.choose().then((servlet) {
    staticServlet = servlet;
    staticServlet.setLogger(new PrintServletLogger());
    return PicoServer.createServer(port);
  }).then((server) {
    server.addServlet(staticServlet);
    //server.setLogger(new PrintServerLogger());
    return server.getInfo();
  }).then((info) {
    print("Server running on ${info.localAddress}:${info.localPort.toString()}");
  });

  btnFab = html.querySelector('#btnFab');
  lstLogger = html.querySelector('#lstLogger');
}

class PrintServletLogger extends ServletLogger {
  void logStart(int id, HttpRequest request) => print('[$id] > $request');
  void logComplete(int id, HttpResponse response) => print('[$id] < $response');
  void logError(int id, error) => print('[$id] ! $error');
}

class PrintServerLogger extends ServerLogger {
  void log(String msg) => print(msg);
}
