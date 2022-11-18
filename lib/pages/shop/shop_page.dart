import 'package:doubanapp/widgets/custom_tab_indicator.dart';
import 'package:doubanapp/widgets/search_text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:doubanapp/util/screen_utils.dart';

import '../../router.dart';

String url1 = 'https://flutterchina.club/';
String url2 = 'https://juejin.cn/post/6844903812264640519';
bool _closed = false;
bool _isShow = true;
///提供链接到一个唯一webview的单例实例，以便您可以从应用程序的任何位置控制webview
final _webviewReference = FlutterWebviewPlugin();

///市集 市集使用两个webView代替，因为豆瓣中 这个就是WebView
class ShopPageWidget extends StatelessWidget {

  void setShowState(bool isShow) {
    _isShow = isShow;
    if(!isShow){
      _closed = true;
      _webviewReference.hide();
      _webviewReference.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewPageWidget();
  }
}


class WebViewPageWidget extends StatefulWidget {
  @override
  _WebViewPageWidgetState createState() => _WebViewPageWidgetState();
}


class _WebViewPageWidgetState extends State<WebViewPageWidget>
    with SingleTickerProviderStateMixin {
  var list = ['动态', '推荐'];
  int selectIndex = 0;
  Color selectColor, unselectColor;
  TextStyle selectStyle, unselectedStyle;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    print('_ShopPageWidgetState initState');
    _webviewReference.close();
    tabController = new TabController(length: list.length, vsync: this);
    selectColor = Colors.black;
    unselectColor = Colors.black12;
    // unselectColor = Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18,fontWeight: FontWeight.bold);
    unselectedStyle = TextStyle(fontSize: 18,fontWeight: FontWeight.bold);
    _webviewReference.onUrlChanged.listen((String url) {
      if(url != url1 || url != url2){
        print("new Url=$url");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('_ShopPageWidgetState dispose');
    tabController.dispose();
    _webviewReference.close();
    _webviewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!_isShow){
      return Container();
    }
    return Container(
      child: SafeArea(
          child: Column(
            children: <Widget>[
              SearchTextFieldWidget(
                hintText: '影视作品中你难忘的离别',
                margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                onTab: () {
                  MyRouter.push(context, MyRouter.searchPage, '影视作品中你难忘的离别');
                },
              ),
              Container(
                // color: Colors.red,
                alignment: Alignment.topLeft,
                height: 63.0,
                margin: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                child: TabBar(
                  tabs: list.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Text(item),
                  )
                  ).toList(),
                  isScrollable: true,
                  controller: tabController,
                  indicatorColor: selectColor,
                  labelColor: selectColor,
                  labelStyle: selectStyle,
                  unselectedLabelColor: unselectColor,
                  unselectedLabelStyle: unselectedStyle,
                  indicatorSize: TabBarIndicatorSize.label,
                  // labelPadding: EdgeInsets.only(bottom: 5.0,left: 50.0),
                  // indicatorPadding: EdgeInsets.only(left: 50.0),
                  indicator: RoundUnderlineTabIndicator(
                      borderSide: BorderSide(width: 3, color: selectColor),
                      // width: 43.0,
                      // widthEqualTitle: false),
                  ),
                  onTap: (selectIndex) {
                    print('select=$selectIndex');
                    this.selectIndex = selectIndex;
                    print('_closed=$_closed');
                    _webviewReference.reloadUrl(selectIndex == 0 ? url1 : url2);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Expanded(
                  flex: 1,
                  child: _WebViewWidget(selectIndex == 0 ? url1 : url2),
                ),
              )
            ],
          )),
      color: Colors.white,
    );
  }

}

class _WebViewWidget extends StatefulWidget {
  final String url;

  _WebViewWidget(this.url, {Key key}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<_WebViewWidget>  {
  Rect _rect;
  bool needFullScreen = false;
  @override
  void initState() {
    super.initState();
    _webviewReference.close();
  }

  @override
  void dispose() {
    super.dispose();
    _webviewReference.close();
    _webviewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build widget.url=${widget.url}');
    return _WebviewPlaceholder(onRectChanged: (Rect value) {
      if (_rect == null || _closed) {
        if(_rect != value){
          _rect = value;
        }
        print('_webviewReference.launch');
        _webviewReference.launch(widget.url,
            withJavascript: true,
            withLocalStorage: true,
            scrollBar: true,
            rect: getRect());
      } else {
        print('_webviewReference.launch else');
        if (_rect != value) {
          _rect = value;
        }
        _webviewReference.reloadUrl(widget.url);
      }
    }, child: const Center(child: const CircularProgressIndicator()),);
  }

  getRect() {

    if(needFullScreen){
      return null;
    }else{
      return Rect.fromLTRB(0.0, ScreenUtils.getStatusBarH(context) + 105.0,
          ScreenUtils.screenW(context), ScreenUtils.screenH(context) - 60.0);
    }
  }

}

class _WebviewPlaceholder extends SingleChildRenderObjectWidget {
  const _WebviewPlaceholder({
    Key key,
    @required this.onRectChanged,
    Widget child,
  }) : super(key: key, child: child);

  final ValueChanged<Rect> onRectChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _WebviewPlaceholderRender(
      onRectChanged: onRectChanged,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _WebviewPlaceholderRender renderObject) {
    renderObject..onRectChanged = onRectChanged;
  }
}

class _WebviewPlaceholderRender extends RenderProxyBox {
  _WebviewPlaceholderRender({
    RenderBox child,
    ValueChanged<Rect> onRectChanged,
  })  : _callback = onRectChanged,
        super(child);

  ValueChanged<Rect> _callback;
  Rect _rect;

  Rect get rect => _rect;

  set onRectChanged(ValueChanged<Rect> callback) {
    if (callback != _callback) {
      _callback = callback;
      notifyRect();
    }
  }

  void notifyRect() {
    if (_callback != null && _rect != null) {
      _callback(_rect);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final rect = offset & size;
    if (_rect != rect) {
      _rect = rect;
      notifyRect();
    }
  }
}
