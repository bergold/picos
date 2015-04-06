library picos.ui.view;

import 'dart:html';
import 'templates.dart';
import 'list.dart';

class View extends TemplateComponent implements ListComponentItem {
  
  View(TemplateElement tpl) : super(tpl);
  
  void select() { template.attributes.remove('hidden'); }
  void deselect() { template.attributes['hidden'] = ''; }
  
}
