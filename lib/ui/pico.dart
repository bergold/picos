library picos.ui.pico;

import 'dart:html';
import 'dart:async';
import 'package:chrome_net/server.dart' show HttpStatus;
import 'template.dart';
import 'card.dart';
import 'view.dart';

class PicoCard extends ListItemCard with TemplateInjector {
  
  set name(v) => injectText('name', v);
  set path(v) => injectText('path', v);
  set port(v) => injectText('port', v);
  
  StreamController _onClickStartCtrl = new StreamController.broadcast();
  Stream get onClickStart => _onClickStartCtrl.stream;
  
  StreamController _onClickStopCtrl = new StreamController.broadcast();
  Stream get onClickStop => _onClickStopCtrl.stream;
  
  StreamController _onClickOpenCtrl = new StreamController.broadcast();
  Stream get onClickOpen => _onClickOpenCtrl.stream;
  
  StreamController _onClickClearCtrl = new StreamController.broadcast();
  Stream get onClickClear => _onClickClearCtrl.stream;
  
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
    var btnDelete = template.querySelector('.pico-btn-delete');
    if (btnDelete != null) btnDelete.onClick.pipe(_onClickDeleteCtrl);
  }
  
}

class PicoView extends View with TemplateInjector {
  
  TemplateElement requestInfoCardTemplate;
  HtmlElement _container;
  
  set name(v) => injectText('name', v);
  
  PicoView(TemplateElement tpl) : super(tpl) {
    _container = template.querySelector('.pico-request-list');
  }
  
  addRequest(requestInfo) {
    var card = new RequestInfoCard(requestInfo, requestInfoCardTemplate);
    _container.append(card.template);
    card.template.scrollIntoView(ScrollAlignment.TOP);
  }
  
}

class RequestInfoCard extends Card with TemplateInjector {
  
  final requestInfo;
  
  DateTime _start;
  
  set method(v) => injectText('method', v);
  set uri(v) => injectText('uri', v);
  set status(v) => injectText('status', v);
  set duration(v) => injectText('duration', v);
  set time(v) => injectText('time', v);
  
  RequestInfoCard(this.requestInfo, TemplateElement tpl) : super(tpl) {
    _start = new DateTime.now();
    
    method = requestInfo.request.method;
    uri = requestInfo.request.uri;
    time = _start;
    
    requestInfo.response.then((res) {
      var dur = new DateTime.now().difference(_start);
      
      duration = '${dur.inMilliseconds}ms';
      status = '${res.statusCode} ${_calcPhrase(res)}';
    });
  }
  
  String _calcPhrase(res) {
    if (res.reasonPhrase == null) {
      return HttpStatus.getReasonPhrase(res.statusCode);
    } else {
      return res.reasonPhrase;
    }
  }
  
}
