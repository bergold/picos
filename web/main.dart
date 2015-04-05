import 'dart:html' as html;

import 'package:chrome_net/server.dart' show PicoServer, ServerLogger, HttpRequest, HttpResponse;
import 'package:picos/static_servlet.dart';
import 'package:picos/ui/list.dart';
import 'package:picos/ui/cards.dart';

var port = 5000;
var server;
var logger;
var servlet;

// UI Elements
var body;
var picoList;
var viewContainer;

// UI Controller
var picoListCtrl;
/*var dropdownTrigger;
var dropdownMenu;
var dropdownEntryLoading;
var dropdownEntryEmpty;
var dropdownEntryChoose;
var loggerContainer;*/

// Templates
var tplPicoItemCard;
var tplLogItemCard;

void main() {
  
  body = html.document.body;
  picoList = html.querySelector('#picoList');
  viewContainer = html.querySelector('#viewContainer');
  
  tplPicoItemCard = html.querySelector('#tplPicoItemCard');
  tplLogItemCard = html.querySelector('#tplLogItemCard');
  
  picoListCtrl = new ListComponent(picoList, picoList.querySelector('.list-insert-before'));
  
  picoListCtrl.add(createPico('Pico 1'));
  picoListCtrl.add(createPico('Pico 2'));
  picoListCtrl.add(createPico('Pico 3'));
  
}

PicoItemCard createPico(name) {
  return new PicoItemCard(tplPicoItemCard, name);
}
  /*dropdownTrigger = html.querySelector('#dropdownTrigger');
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

  logger = new ElementServletLogger(loggerContainer);
}*/

/*void triggerChoose() {
  if (server != null) {
    server.dispose();
  }
  StaticServlet.choose().then((s) {
    servlet = s;
    servlet.setLogger(logger);
    dropdownTrigger.text = servlet.name;
    return PicoServer.createServer(port);
  }).then((s) {
    server = s;
    server.addServlet(servlet);
    return server.getInfo();
  }).then((info) {
    logger.logStatus("Server running on ${info.localAddress}:${info.localPort.toString()}");
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
  void logStatus(String msg) => _parse({ 'id': 'info', 'icon': '#', 'msg': msg });

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
}*/
