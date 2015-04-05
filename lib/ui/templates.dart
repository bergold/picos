library picos.ui.templates;

import 'dart:html';

abstract class TemplateComponent {
  
  HtmlElement _template;
  HtmlElement get template => _template;
  
  TemplateComponent(TemplateElement tpl) {
    _template = (document.importNode(tpl.content, true) as DocumentFragment).children.single;
  }
  
}
