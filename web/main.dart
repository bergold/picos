
import 'dart:html' as html;
import 'package:picos/picos.dart';
import 'package:picos/ui/pico.dart';
import 'package:picos/ui/list.dart';
import 'package:picos/ui/card.dart';
import 'package:picos/ui/view.dart';

var picoManager;

// UI Elements
var picoList;
var viewContainer;

// Templates
var tplPicoItemCard;
var tplNewPicoItemCard;
var tplLogItemCard;

// View templates
var viewWelcome;
var viewNewPico;
var viewPico;

// Controllers
var picoListCtrl;
var viewContainerCtrl;

void main() {
  
  picoManager = new PicoManager();
  
  picoList = html.querySelector('#picoList');
  viewContainer = html.querySelector('#viewContainer');
  
  tplPicoItemCard = html.querySelector('#tplPicoItemCard');
  tplNewPicoItemCard = html.querySelector('#tplNewPicoItemCard');
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
  var newPicoBtn = new ListItemCard(tplNewPicoItemCard);
  newPicoBtn.onClick.listen((e) => picoListCtrl.select(newPicoBtn));
  newPicoBtn.onClick.listen((e) => createNewPico());
  picoListCtrl.add(newPicoBtn);
  picoListCtrl.insertBefore = newPicoBtn;
}

void initPicoList() {
  picoManager.restoreAll()
    .forEach(createPicoFromConfig)
    .catchError((e) {
      print(e);
    });
  
  picoListCtrl.onSelect.listen((item) {
    if (item is HasView) {
      if (item.view != null) {
        viewContainerCtrl.select(item.view);
      } else {
        viewContainerCtrl.deselect();
      }
    }
  });
}

/// Triggers the creation of a new Pico.
/// Gets triggered by the newPicoBtn.onClick handler.
void createNewPico() {
  picoManager.createNewPicoConfig()
    .then(createPicoFromConfig)
    .then((p) => picoListCtrl.select(p.card))
    .catchError((e) {
      print(e);
    });
}

createPicoFromConfig(config) {
  var view = new PicoView(viewPico);
  viewContainerCtrl.add(view);
  
  var card = new PicoCard(tplPicoItemCard);
  card.view = view;
  card.onClick.listen((e) => picoListCtrl.select(card));
  picoListCtrl.add(card);

  return new Pico(config, card, view);
}
