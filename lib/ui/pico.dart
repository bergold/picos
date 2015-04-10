library picos.ui.pico;

import 'dart:html';
import 'dart:async';
import 'template.dart';
import 'card.dart';
import 'view.dart';

class PicoCard extends ListItemCard with TemplateInjector {
  
  set name(v) => injectText('name', v);
  set path(v) => injectText('path', v);
  set port(v) => injectText('port', v);
  
  StreamController _onClickStartCtrl = new StreamController.broadcast();
  Stream get onClickStart => _onClickStartCtrl.stream;
  
  StreamController _onClickStopCtrl = new StreamController.broadcast();
  Stream get onClickStop => _onClickStopCtrl.stream;
  
  StreamController _onClickOpenCtrl = new StreamController.broadcast();
  Stream get onClickOpen => _onClickOpenCtrl.stream;
  
  StreamController _onClickClearCtrl = new StreamController.broadcast();
  Stream get onClickClear => _onClickClearCtrl.stream;
  
  StreamController _onClickDeleteCtrl = new StreamController.broadcast();
  Stream get onClickDelete => _onClickDeleteCtrl.stream;
  
  PicoCard(TemplateElement tpl) : super(tpl) {
    template.querySelector('.pico-btn-start').onClick.pipe(_onClickStartCtrl);
    template.querySelector('.pico-btn-stop').onClick.pipe(_onClickStopCtrl);
    template.querySelector('.pico-btn-open').onClick.pipe(_onClickOpenCtrl);
    template.querySelector('.pico-btn-clear').onClick.pipe(_onClickClearCtrl);
    template.querySelector('.pico-btn-delete').onClick.pipe(_onClickDeleteCtrl);
  }
  
}

class PicoView extends View with TemplateInjector {
  
  set name(v) => injectText('name', v);
  
  PicoView(TemplateElement tpl) : super(tpl);
  
}
