library picos.ui.pico;

import 'dart:html';
import 'template.dart';
import 'card.dart';
import 'view.dart';

class PicoCard extends ListItemCard with TemplateInjector {
  
  set name(String v) => injectText('name', v);
  
  PicoCard(TemplateElement tpl) : super(tpl);
  
}

class PicoView extends View with TemplateInjector {
  
  set name(String v) => injectText('name', v);
  
  PicoView(TemplateElement tpl) : super(tpl);
  
}
