library picos.ui.snackbar;

import 'dart:async';
import 'dart:html' show HtmlElement, TemplateElement;
import 'dart:js';
import 'template.dart';

class Snackbar extends TemplateComponent with TemplateInjector {
  
  final String message;
  final String action;
  
  StreamController _onActionCtrl = new StreamController.broadcast();
  Stream get onAction => _onActionCtrl.stream;
  
  Snackbar(TemplateElement tpl, this.message, [this.action = '']) : super(tpl) {
    inject('message', message);
    if (action != null && action.isNotEmpty) {
      inject('hasAction', true);
      inject('action', action);
    }
    var btnAction = template.querySelector('.snackbar-btn-action');
    if (btnAction != null) btnAction.onClick.pipe(_onActionCtrl);
  }
  
}

class _SnackbarWrapper {
  
  final Snackbar snackbar;
  final Completer _actionCompleter = new Completer();
  
  _SnackbarWrapper(this.snackbar) {
    snackbar.onAction.first.then((_) => _actionCompleter.complete(new SnackbarState.action()));
  }
  
  void abort() {
    _actionCompleter.complete(new SnackbarState.abort());
  }
  
  Future get future => _actionCompleter.future.timeout(new Duration(seconds: 3), onTimeout: () => new SnackbarState.timeout());
  
}

class SnackbarState {
  
  static const int stateTimeout = 0;
  static const int stateAbort = 1;
  static const int stateAction = 2;
  
  final int state;
  
  SnackbarState(this.state);
  SnackbarState.timeout() : state = stateTimeout;
  SnackbarState.abort() : state = stateAbort;
  SnackbarState.action() : state = stateAction;
  
  bool get isTimeout => state == stateTimeout;
  bool get isAbort => state == stateAbort;
  bool get isAction => state == stateAction;
  bool get isDismissed => isTimeout || isAbort;
  
}

class SnackbarStack {
  
  final HtmlElement _container;
  
  _SnackbarWrapper _snackbar;
  _SnackbarWrapper _scheduled;
  
  SnackbarStack(this._container);
  
  Future show(Snackbar snackbar) {
    _scheduled = new _SnackbarWrapper(snackbar);
    
    if (_snackbar != null) {
      _snackbar.abort();
    } else {
      _triggerScheduled();
    }
    
    return _scheduled.future.then((_) {
      _triggerScheduled();
      return _;
    });
  }
  
  _triggerScheduled() {
    _remove().then((_) {
      _snackbar = _scheduled;
      _scheduled = null;
      _append();
    });
  }
  
  Future _append() {
    if (_snackbar == null) return new Future.value();
    var element = _snackbar.snackbar.template;
    _container.append(element);
    
    var promise = new Completer();
    var animation = new JsObject.fromBrowserObject(element).callMethod('animate', [
      new JsObject.jsify([
        { 'transform': 'translateY(100%)' },
        { 'transform': 'translateY(0%)' }
      ]),
      new JsObject.jsify({
        'duration': 500,
        'easing': 'ease'
      })
    ]);
    animation['onfinish'] = (_) {
      promise.complete();
    };
    return promise.future;
  }
  
  Future _remove() {
    if (_snackbar == null) return new Future.value();
    var element = _snackbar.snackbar.template;
    
    var promise = new Completer();
    var animation = new JsObject.fromBrowserObject(element).callMethod('animate', [
      new JsObject.jsify([
        { 'transform': 'translateY(0%)' },
        { 'transform': 'translateY(100%)' }
      ]),
      new JsObject.jsify({
        'duration': 500,
        'easing': 'ease'
      })
    ]);
    animation['onfinish'] = (_) {
      element.remove();
      promise.complete();
    };
    return promise.future;
  }
  
}
