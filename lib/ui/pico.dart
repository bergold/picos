library picos.ui.pico;

import 'dart:html';
import 'dart:async';
import 'package:chrome_net/server.dart' show HttpStatus;
import '../picos.dart' show Pico;
import 'template.dart';
import 'card.dart';
import 'view.dart';

class PicoCard extends ListItemCard with TemplateInjector {
  
  set name(v) => inject('name', v);
  set path(v) => inject('path', v);
  set port(v) => inject('port', v);
  
  set state(int v) {
    switch (v) {
      case Pico.stateNotRunning:
        inject('stateNotRunning', true);
        inject('stateSwitching', false);
        inject('stateRunning', false);
        
        inject('stateIcon', 'icon-pico-stopped');
        break;
        
      case Pico.stateSwitching:
        inject('stateSwitching', true);
        inject('stateNotRunning', false);
        inject('stateRunning', false);
        break;
        
      case Pico.stateRunning:
        inject('stateRunning', true);
        inject('stateNotRunning', false);
        inject('stateSwitching', false);
        
        inject('stateIcon', 'icon-pico-running');
        break;
    }
  }
  
  StreamController _onClickStartCtrl = new StreamController.broadcast();
  Stream get onClickStart => _onClickStartCtrl.stream;
  
  StreamController _onClickStopCtrl = new StreamController.broadcast();
  Stream get onClickStop => _onClickStopCtrl.stream;
  
  StreamController _onClickOpenCtrl = new StreamController.broadcast();
  Stream get onClickOpen => _onClickOpenCtrl.stream;
  
  StreamController _onClickClearCtrl = new StreamController.broadcast();
  Stream get onClickClear => _onClickClearCtrl.stream;
  
  StreamController _onClickEditCtrl = new StreamController.broadcast();
  Stream get onClickEdit => _onClickEditCtrl.stream;
  
  StreamController _onClickDeleteCtrl = new StreamController.broadcast();
  Stream get onClickDelete => _onClickDeleteCtrl.stream;
  
  PicoCard(TemplateElement tpl) : super(tpl) {
    var btnStart = template.querySelector('.pico-btn-start');
    if (btnStart != null) btnStart.onClick.pipe(_onClickStartCtrl);
    var btnStop = template.querySelector('.pico-btn-stop');
    if (btnStop != null) btnStop.onClick.pipe(_onClickStopCtrl);
    var btnOpen = template.querySelector('.pico-btn-open');
    if (btnOpen != null) btnOpen.onClick.pipe(_onClickOpenCtrl);
    var btnClear = template.querySelector('.pico-btn-clear');
    if (btnClear != null) btnClear.onClick.pipe(_onClickClearCtrl);
    var btnEdit = template.querySelector('.pico-btn-edit');
    if (btnEdit != null) btnEdit.onClick.pipe(_onClickEditCtrl);
    var btnDelete = template.querySelector('.pico-btn-delete');
    if (btnDelete != null) btnDelete.onClick.pipe(_onClickDeleteCtrl);
  }
  
}

class PicoView extends View with TemplateInjector {
  
  TemplateElement requestInfoCardTemplate;
  HtmlElement _container;
  List<HtmlElement> _requests;
  
  set state(int v) {
    switch (v) {
      case Pico.stateNotRunning:
        inject('stateNotRunning', true);
        inject('stateSwitching', false);
        inject('stateRunning', false);
        break;
        
      case Pico.stateSwitching:
        inject('stateSwitching', true);
        inject('stateNotRunning', false);
        inject('stateRunning', false);
        break;
        
      case Pico.stateRunning:
        inject('stateRunning', true);
        inject('stateNotRunning', false);
        inject('stateSwitching', false);
        break;
    }
  }
  
  PicoView(TemplateElement tpl) : super(tpl) {
    _container = template.querySelector('.pico-request-list');
    _requests = new List();
  }
  
  addRequest(requestInfo) {
    var card = new RequestInfoCard(requestInfo, requestInfoCardTemplate);
    _container.append(card.template);
    _requests.add(card.template);
    card.template.scrollIntoView(ScrollAlignment.TOP);
  }
  
  clear([_]) {
    _requests.forEach((r) => r.remove());
  }
  
}

class RequestInfoCard extends Card with TemplateInjector {
  
  final requestInfo;
  
  DateTime _start;
  
  set method(v) => inject('method', v);
  set uri(v) => inject('uri', v);
  set status(v) => inject('status', v);
  set duration(v) => inject('duration', v);
  set time(v) => inject('time', v);
  set icon(v) => inject('icon', v);
  
  RequestInfoCard(this.requestInfo, TemplateElement tpl) : super(tpl) {
    _start = new DateTime.now();
    
    method = requestInfo.request.method;
    uri = requestInfo.request.uri;
    time = _start;
    
    requestInfo.response.then((res) {
      var dur = new DateTime.now().difference(_start);
      var ico = _calcIcon(res.statusCode);
      
      duration = '${dur.inMilliseconds}ms';
      status = '${res.statusCode} ${_calcPhrase(res)}';
      if (ico != null) icon = 'icon-$ico';
    });
  }
  
  String _calcPhrase(res) {
    if (res.reasonPhrase == null) {
      return HttpStatus.getReasonPhrase(res.statusCode);
    } else {
      return res.reasonPhrase;
    }
  }
  
  String _calcIcon(statusCode) {
    if (statusCode >= 500 && statusCode < 600) return 'error';
    if (statusCode >= 400 && statusCode < 500) return 'warning';
    if ((statusCode >= 300 && statusCode < 400) ||
        (statusCode >= 100 && statusCode < 200)) return 'info';
    return null;
  }
  
}
