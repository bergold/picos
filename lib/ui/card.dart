library picos.ui.card;

import 'dart:html';
import 'dart:async';
import 'templates.dart';
import 'list.dart';
import 'view.dart';

abstract class Card extends TemplateComponent {
  
  Card(TemplateElement tpl) : super(tpl);
  
}

class ListItemCard extends Card implements ListComponentItem, HasView {
  
  String name;
  View view;
  
  StreamController _onClickCtrl = new StreamController.broadcast();
  Stream get onClick => _onClickCtrl.stream;
  
  ListItemCard(TemplateElement tpl, [this.name = '']) : super(tpl) {
    template.querySelector('.pico-name').text = name;
    template.querySelector('.pico-clickarea').onClick.pipe(_onClickCtrl);
  }
  
  void select() { template.classes.add('selected'); }
  void deselect() { template.classes.remove('selected'); }
  
}
