library picos.ui.snackbar;

import 'dart:async';
import 'dart:html' show TemplateElement;
import 'template.dart';

class Snackbar extends TemplateComponent with TemplateInjector {
  
  final String message;
  final String action;
  
  StreamController _onActionCtrl = new StreamController.broadcast();
  Stream get onAction => _onActionCtrl.stream;
  
  Snackbar(TemplateElement tpl, this.message, { this.action: '' }) : super(tpl) {
    inject('message', message);
    if (action.isNotEmpty) {
      inject('hasAction', true);
      inject('action', action);
    }
    var btnAction = template.querySelector('.pico-btn-action');
    if (btnAction != null) btnAction.onClick.pipe(_onActionCtrl);
  }
  
}

class _SnackbarWrapper {
  
  final Snackbar snackbar;
  final Completer _actionCompleter = new Completer();
  
  _SnackbarWrapper(this.snackbar) {
    snackbar.onAction.listen((_) => _actionCompleter.complete());
  }
  
  void abort() {
    _actionCompleter.complete();
  }
  
  Future get future => _actionCompleter.future.timeout(new Duration(seconds: 3), onTimeout: () => null);
  
}

class SnackbarStack {
  
  _SnackbarWrapper _snackbar;
  _SnackbarWrapper _scheduled;
  
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
  
  Future _remove() {
    if (_snackbar == null) return new Future.value();
    return _animateOut().then((_) {
      print('remove ${_snackbar.snackbar.message}');
    });
  }
  
  Future _append() {
    if (_snackbar == null) return new Future.value();
    print('append ${_snackbar.snackbar.message}');
    return _animateIn();
  }
  
  Future _animateIn() => new Future.value();
  Future _animateOut() => new Future.value();
  
}
