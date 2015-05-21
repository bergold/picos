library picos.ui.dialog;

import 'dart:html' show TemplateElement, HtmlElement;
import 'dart:async';
import 'dart:js';
import 'template.dart';

class Dialog extends TemplateComponent {
  
  final HtmlElement _container;
  final StreamController _onCloseCtrl = new StreamController.broadcast();
  Stream get onClose => _onCloseCtrl.stream;
  
  
  Dialog(TemplateElement tpl, this._container) : super(tpl);
  
  Future show() {
    _container.append(template);
    var promise = new Completer();
    var animation = new JsObject.fromBrowserObject(template).callMethod('animate', [
      new JsObject.jsify([
        {
          'opacity': '0',
          'transform': 'scale(0.8)'
        },
        {
          'opacity': '1',
          'transform': 'scale(1)'
        }
      ]),
      new JsObject.jsify({
        'duration': 300,
        'easing': 'ease-out'
      })
    ]);
    animation['onfinish'] = (_) {
      promise.complete();
    };
    return promise.future;
  }
  
  Future hide() {
    var promise = new Completer();
    var animation = new JsObject.fromBrowserObject(template).callMethod('animate', [
      new JsObject.jsify([
        {
          'opacity': '1',
          'transform': 'scale(1)'
        },
        {
          'opacity': '0',
          'transform': 'scale(0.8)'
        }
      ]),
      new JsObject.jsify({
        'duration': 300,
        'easing': 'ease-in'
      })
    ]);
    animation['onfinish'] = (_) {
      template.remove();
      _onCloseCtrl.add(null);
      promise.complete();
    };
    return promise.future;
  }
  
}

class ModalDialog extends Dialog {
  
  ModalDialog(TemplateElement tpl, HtmlElement container) : super(tpl, container) {
    var btnClose = template.querySelector('.dialog-btn-close');
    if (btnClose != null) btnClose.onClick.listen((_) => hide());
  }
  
  @override
  Future show() {
    super.show();
    return onClose.first;
  }
  
}

class EditDialog extends ModalDialog with TemplateInjector {
  
  EditDialog(TemplateElement tpl, HtmlElement container) : super(tpl, container);
  
  
  
}
