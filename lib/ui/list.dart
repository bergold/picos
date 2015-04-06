library picos.ui.list;

import 'dart:html';
import 'dart:async';
import 'templates.dart';

class ListComponent {
  
  final HtmlElement _container;
  
  final StreamController _onSelectCtrl = new StreamController.broadcast();
  Stream get onSelect => _onSelectCtrl.stream;
  
  List<ListComponentItem> _items = [];
  ListComponentItem _selected;
  ListComponentItem insertBefore;
  
  ListComponent(this._container, [this.insertBefore]);
  
  void select(item) {
    if (!_items.contains(item)) throw new ArgumentError('Item is not in the list.');
    if (_selected != null) _selected.deselect();
    _selected = item..select();
    _onSelectCtrl.add(item);
  }
  
  void deselect() {
    if (_selected == null) return;
    _selected.deselect();
    _selected = null;
  }
  
  void add(item) {
    if (item is! TemplateComponent) throw new ArgumentError('Item needs to be a TemplateComponent.');
    if (item is! ListComponentItem) throw new ArgumentError('Item needs to implement the ListComponentItem interface');
    if (insertBefore != null && _items.contains(insertBefore)) {
      _items.insert(_items.indexOf(insertBefore), item);
      _container.insertBefore((item as TemplateComponent).template, (insertBefore as TemplateComponent).template);
    } else {
      _items.add(item);
      _container.append((item as TemplateComponent).template);
    }
  }
  
  void remove(item) {
    if (!_items.contains(item)) throw new ArgumentError('Item is not in the list.');
    if (item == _selected) {
      item.deselect();
      _selected = null;
    }
    _items.remove(item);
    item.template.remove();
  }
  
}

abstract class ListComponentItem {
  
  void select();
  void deselect();
  
}
