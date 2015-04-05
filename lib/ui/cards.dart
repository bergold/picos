library picos.ui.cards;

import 'dart:html';
import 'templates.dart';
import 'list.dart';

abstract class Card extends TemplateComponent {
  
  Card(TemplateElement tpl) : super(tpl);
  
}

class PicoItemCard extends Card implements ListComponentItem {
  
  String name;
  
  PicoItemCard(TemplateElement tpl, [this.name = '']) : super(tpl) {
    template.querySelector('.pico-name').text = name;
  }
  
  void select() { template.classes.add('selected'); }
  void deselect() { template.classes.remove('selected'); }
  
}
