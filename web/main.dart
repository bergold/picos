import 'dart:html' as html;

import 'package:chrome_net/server.dart' show PicoServer, ServerLogger, HttpRequest, HttpResponse;

import 'static_servlet.dart';

var port = 5000;
var staticServlet;
var logger;

// UI elements
var btnFab;
var lstLogger;

void main() {
  logger = new ElementLogger();

  StaticServlet.choose().then((servlet) {
    staticServlet = servlet;
    staticServlet.logger = logger;
    return PicoServer.createServer(port);
  }).then((server) {
    server.addServlet(staticServlet);
    server.setLogger(new PrintServerLogger());
    return server.getInfo();
  }).then((info) {
    print("Server running on ${info.localAddress}:${info.localPort.toString()}");
  });

  btnFab = html.querySelector('#btnFab');
  lstLogger = html.querySelector('#lstLogger');
}

class ElementLogger extends ServletLogger {
  void log(int id, { HttpRequest request, HttpResponse response, error, String measure }) {
    print('[$id] $request $response $error ${html.window.performance.getEntriesByName(measure, 'measure').first.duration}ms');
  }
}

class PrintServerLogger extends ServerLogger {
  void log(String msg) => print(msg);
}
