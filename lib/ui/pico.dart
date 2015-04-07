library picos.ui.pico;

import 'dart:html';
import 'card.dart';
import 'view.dart';

class PicoCard extends ListItemCard {
  PicoCard(TemplateElement tpl, [name = '']) : super(tpl, name);
}

class PicoView extends View {
  
  PicoView(TemplateElement tpl, name) : super(tpl) {
    template.querySelector('.pico-name').text = name;
  }
  
}
