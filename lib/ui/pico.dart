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
  
  PicoCard(TemplateElement tpl) : super(tpl) {
    template.querySelector('.pico-btn-start').onClick.pipe(_onClickStartCtrl);
  }
  
}

class PicoView extends View with TemplateInjector {
  
  set name(v) => injectText('name', v);
  
  PicoView(TemplateElement tpl) : super(tpl);
  
}
