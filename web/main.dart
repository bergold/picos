import 'dart:html' as html;

import 'package:chrome_net/server.dart' show PicoServer, ServerLogger, HttpRequest, HttpResponse;
import 'package:picos/static_servlet.dart';
import 'package:picos/ui/list.dart';
import 'package:picos/ui/card.dart';
import 'package:picos/ui/view.dart';

var port = 5000;
var server;
var logger;
var servlet;

// UI Elements
var body;
var picoList;
var viewContainer;

// Templates
var tplPicoItemCard;
var tplBtnItemCard;
var tplLogItemCard;

// View templates
var viewWelcome;
var viewNewPico;
var viewPico;

// Controllers
var picoListCtrl;
var viewContainerCtrl;

void main() {
  
  body = html.document.body;
  picoList = html.querySelector('#picoList');
  viewContainer = html.querySelector('#viewContainer');
  
  tplPicoItemCard = html.querySelector('#tplPicoItemCard');
  tplBtnItemCard = html.querySelector('#tplBtnItemCard');
  tplLogItemCard = html.querySelector('#tplLogItemCard');
  
  viewWelcome = html.querySelector('#viewWelcome');
  viewNewPico = html.querySelector('#viewNewPico');
  viewPico = html.querySelector('#viewPico');
  
  picoListCtrl = new ListComponent(picoList);
  viewContainerCtrl = new ListComponent(viewContainer);
  
  viewContainerCtrl.add(new View(viewWelcome), true);
  
  initPicoList();
  
}

void initPicoList() {
  var btnNewPico = createItemCard(tplBtnItemCard, 'New Pico');
  viewContainerCtrl.add(btnNewPico.view = new View(viewNewPico));
  picoListCtrl.add(btnNewPico);
  picoListCtrl.insertBefore = btnNewPico;
  
  picoListCtrl.add(createItemCard(tplPicoItemCard, 'Pico 1', true));
  picoListCtrl.add(createItemCard(tplPicoItemCard, 'Pico 2', true));
  picoListCtrl.add(createItemCard(tplPicoItemCard, 'Pico 3', true));
  
  picoListCtrl.onSelect.listen((item) {
    if (item is HasView && item.view != null) {
      viewContainerCtrl.select(item.view);
    }
  });
}


createItemCard(tpl, name, [withView = false]) {
  var item = new ListItemCard(tpl, name);
  if (withView) viewContainerCtrl.add(item.view = new PicoView(viewPico, name));
  item.onClick.listen((e) => picoListCtrl.select(item));
  return item;
}

  /*dropdownEntryChoose.onClick.listen((e) {
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
