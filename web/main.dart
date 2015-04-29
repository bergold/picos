
import 'dart:html' as html;
import 'package:picos/picos.dart';
import 'package:picos/ui/pico.dart';
import 'package:picos/ui/list.dart';
import 'package:picos/ui/card.dart';
import 'package:picos/ui/view.dart';
import 'package:picos/ui/snackbar.dart';

var picoManager;

// UI Elements
var picoList;
var viewContainer;
var snackbarContainer;

// Templates
var tplPicoItemCard;
var tplNewPicoItemCard;
var tplRequestInfoCard;
var tplSnackbar;

// View templates
var viewWelcome;
var viewNewPico;
var viewPico;

// Controllers
var snackbarStack;
var picoListCtrl;
var viewContainerCtrl;

void main() {
  
  picoManager = new PicoManager();
  
  picoList = html.querySelector('#picoList');
  viewContainer = html.querySelector('#viewContainer');
  snackbarContainer = html.querySelector('#snackbarContainer');
  
  tplPicoItemCard = html.querySelector('#tplPicoItemCard');
  tplNewPicoItemCard = html.querySelector('#tplNewPicoItemCard');
  tplRequestInfoCard = html.querySelector('#tplRequestInfoCard');
  tplSnackbar = html.querySelector('#tplSnackbar');
  
  viewWelcome = html.querySelector('#viewWelcome');
  viewNewPico = html.querySelector('#viewNewPico');
  viewPico = html.querySelector('#viewPico');
  
  snackbarStack = new SnackbarStack(snackbarContainer);
  
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
  picoManager.restoreAll().then((all) {
    all.forEach(createPicoFromConfig);
  }).catchError((e) {
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
  view.requestInfoCardTemplate = tplRequestInfoCard;
  viewContainerCtrl.add(view);
  
  var card = new PicoCard(tplPicoItemCard);
  card.view = view;
  card.onClick.listen((e) => picoListCtrl.select(card));
  picoListCtrl.add(card);

  return initPicoUI(new Pico(config, card, view));
}

initPicoUI(pico) {
  pico.card.name = pico.config.name;
  pico.card.port = pico.config.port;
  pico.config.path.then((p) => pico.card.path = p);
  
  pico.onStarted.listen((info) {
    showSnackbar('Server running on ${info.localAddress}:${info.localPort}', 'Open').then((state) {
      if (state.isAction) pico.open();
    });
  });
  
  pico.onStopped.listen((_) {
    showSnackbar('Server stopped');
  });
  
  pico.card.onClickDelete.listen((e) {
    pico.stop();
    viewContainerCtrl.remove(pico.view);
    picoListCtrl.remove(pico.card);
    showSnackbar('Server removed', 'Undo').then((status) {
      if (status.isDismissed) {
        picoManager.remove(pico.config);
      } else {
        viewContainerCtrl.add(pico.view);
        picoListCtrl.add(pico.card);
      }
    });
  });
  return pico;
}

showSnackbar(message, [action]) {
  var snackbar = new Snackbar(tplSnackbar, message, action);
  return snackbarStack.show(snackbar);
}
