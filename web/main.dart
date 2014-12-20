import 'dart:html';

import 'fs.dart';
import 'server.dart';

var fs;
var server;

// UI elements
var btnFab;
var lstLogger;

void main() {
  fs = new Fs();
  server = new Server();

  btnFab = querySelector('#btnFab');
  lstLogger = querySelector('#lstLogger');
}
