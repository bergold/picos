library picos.ui.templates;

import 'dart:html';

abstract class TemplateComponent {
  
  HtmlElement _template;
  HtmlElement get template => _template;
  
  TemplateComponent(TemplateElement tpl) {
    _template = (document.importNode(tpl.content, true) as DocumentFragment).children.single;
  }
  
}

abstract class TemplateInjector {
  
  HtmlElement get template;
  
  inject(key, value) {
    template.querySelectorAll('[data-inject=$key]').forEach((element) {
      var type = element.attributes.containsKey('data-inject-type') ? element.attributes['data-inject-type'] : 'text';
      switch (type) {
        case 'text':
          _injectText(element, value);
          break;
        case 'class':
          _injectClass(element, value);
          break;
        default:
          _injectAttribute(element, type, value);
      }
    });
  }
  
  _injectText(element, value) {
    element.text = value.toString();
  }
  
  _injectClass(element, value) {
    var previous = element.attributes['data-inject-class'];
    if (previous != null) element.classes.remove(previous);
    element.classes.add(value.toString());
    element.attributes['data-inject-class'] = value.toString();
  }
  
  _injectAttribute(element, attribute, value) {
    if (value == null || (value is bool && value == false)) {
      element.attributes.remove(attribute);
    }
    var textValue = (value is bool && value == true) ? '' : value.toString();
    element.attributes[attribute] = textValue;
  }
  
}
