import 'dart:html';
import 'dart:async';

import 'package:chrome_net/server.dart' show PicoServer;

import 'static_servlet.dart';
import 'server.dart';

var port = 5000;
var staticServlet;
var server;

// UI elements
var btnFab;
var lstLogger;

void main() {
  StaticServlet.choose().then((servlet) {
    staticServlet = servlet;
    return PicoServer.createServer(port);
  }).then((server) {
    server.addServlet(staticServlet);
    return server.getInfo();
  }).then((info) {
    print("Server running on ${info.localAddress}:${info.localPort.toString()}");
  });

  btnFab = querySelector('#btnFab');
  lstLogger = querySelector('#lstLogger');
}
