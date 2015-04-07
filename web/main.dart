
import 'dart:html' as html;
import 'package:picos/picos.dart';
import 'package:picos/ui/pico.dart';
import 'package:picos/ui/list.dart';
import 'package:picos/ui/card.dart';
import 'package:picos/ui/view.dart';

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
  
  initNewPicoBtn();
  initPicoList();
  
}

void initNewPicoBtn() {
  var newPicoBtn = new ListItemCard(tplBtnItemCard, 'New Pico');
  viewContainerCtrl.add(newPicoBtn.view = new View(viewNewPico));
  newPicoBtn.onClick.listen((e) => picoListCtrl.select(newPicoBtn));
  picoListCtrl.add(newPicoBtn);
  picoListCtrl.insertBefore = newPicoBtn;
}

void initPicoList() {
  createPico('Pico 1');
  createPico('Pico 2');
  createPico('Pico 3');
  
  picoListCtrl.onSelect.listen((item) {
    if (item is HasView && item.view != null) {
      viewContainerCtrl.select(item.view);
    }
  });
}


createPico(name) {
  var view = new PicoView(viewPico, name);
  viewContainerCtrl.add(view);
  
  var card = new PicoCard(tplPicoItemCard, name);
  card.view = view;
  card.onClick.listen((e) => picoListCtrl.select(card));
  picoListCtrl.add(card);
  
  var config = new PicoConfig(null, null);
  
  var pico = new Pico(config, card, view);
  return pico;
}

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
*/
