import 'dart:html' as html;

import 'package:chrome_net/server.dart' show PicoServer, ServerLogger, HttpRequest, HttpResponse;

import 'static_servlet.dart';

var port = 5000;
var staticServlet;

// UI elements
var body;
var dropdownTrigger;
var dropdownMenu;
var dropdownEntryLoading;
var dropdownEntryEmpty;
var dropdownEntryChoose;
var loggerContainer;

void main() {
  body = html.document.body;
  dropdownTrigger = html.querySelector('#dropdownTrigger');
  dropdownMenu = html.querySelector('#dropdownMenu');
  dropdownEntryLoading = html.querySelector('#dropdownEntryLoading');
  dropdownEntryEmpty = html.querySelector('#dropdownEntryEmpty');
  dropdownEntryChoose = html.querySelector('#dropdownEntryChoose');
  loggerContainer = html.querySelector('#loggerContainer');

  body.onClick.listen((e) {
    dropdownMenu.attributes['hidden'] = '';
  });
  dropdownMenu.onClick.listen((e) => e.stopPropagation());

  dropdownTrigger.onClick.listen((e) {
    e.stopPropagation();
    dropdownMenu.attributes.remove('hidden');
  });

  dropdownEntryChoose.onClick.listen((e) {
    dropdownMenu.attributes['hidden'] = '';
    triggerChoose();
  });
}

void triggerChoose() {
  StaticServlet.choose().then((servlet) {
    staticServlet = servlet;
    staticServlet.setLogger(new ElementServletLogger(loggerContainer));
    dropdownTrigger.text = staticServlet.name;
    return PicoServer.createServer(port);
  }).then((server) {
    server.addServlet(staticServlet);
    return server.getInfo();
  }).then((info) {
    print("Server running on ${info.localAddress}:${info.localPort.toString()}");
  });
}

class PrintServletLogger extends ServletLogger {
  void logStart(int id, HttpRequest request) => print('[$id] > $request');
  void logComplete(int id, HttpResponse response) => print('[$id] < $response');
  void logError(int id, error) => print('[$id] ! $error');
}

class ElementServletLogger extends ServletLogger {

  final html.HtmlElement _container;

  ElementServletLogger(this._container);

  void logStart(int id, HttpRequest request) => _parse({ 'id': id, 'icon': '>', 'msg': request });
  void logComplete(int id, HttpResponse response) => _parse({ 'id': id, 'icon': '<', 'msg': response });
  void logError(int id, error) => _parse({ 'id': id, 'icon': '!', 'msg': error });

  void _parse(Map data) {
    var text = '[${data['id']}] ${data['icon']} ${data['msg']}';
    var div = new html.DivElement();
    div.text = text;
    _append(div);
  }

  void _append(html.HtmlElement element) {
    _container.append(element);
    _container.scrollTop = _container.scrollHeight - _container.clientHeight;
  }
}
