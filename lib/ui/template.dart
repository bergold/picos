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
  
  injectText(key, value) {
    template.querySelectorAll('[data-inject=${key}]').forEach((e) => e.text = value.toString());
  }
  
}
