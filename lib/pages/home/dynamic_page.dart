import 'package:doubanapp/bean/dynamic_entity.dart';
import 'package:flutter/material.dart';
import 'package:doubanapp/pages/movie/title_widget.dart';
import 'package:doubanapp/pages/movie/today_play_movie_widget.dart';
import 'package:doubanapp/http/API.dart';
import 'package:doubanapp/pages/movie/hot_soon_tab_bar.dart';
import 'package:doubanapp/widgets/item_count_title.dart';
import 'package:doubanapp/widgets/subject_mark_image_widget.dart';
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/bean/top_item_bean.dart';
import 'package:doubanapp/widgets/rating_bar.dart';
import 'package:doubanapp/constant/color_constant.dart';
import 'dart:math' as math;
import 'package:doubanapp/widgets/image/cache_img_radius.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/pages/movie/top_item_widget.dart';
import 'package:doubanapp/router.dart';
//import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/rendering.dart';
import 'package:doubanapp/repository/movie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:doubanapp/widgets/loading_widget.dart';
/// 动态页面
class DynamicPage extends StatefulWidget {

  DynamicPage({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _DynamicPage();
  }
}

class _DynamicPage extends State<DynamicPage>  with AutomaticKeepAliveClientMixin {
  // Widget titleWidget, hotSoonTabBarPadding;

  List<DynamicEntity> hotBeans = List(); //豆瓣榜单


  var imgSize=100;
  List<String> todayUrls = [];
  TopItemBean weeklyTopBean, weeklyHotBean, weeklyTop250Bean;
  Color weeklyTopColor, weeklyHotColor, weeklyTop250Color;
  Color todayPlayBg = Color.fromARGB(255, 47, 22, 74);

  @override
  void initState() {
    super.initState();
    print('initState movie_page');

    requestAPI();
  }

  @override
  Widget build(BuildContext context) {
    print('build movie_page');
    return Stack(
      children: <Widget>[
        containerBody()
      //   Offstage(
      //     child: LoadingWidget.getLoading(backgroundColor: Colors.transparent),
      //     offstage: !loading,
      //   )
      ],
    );
  }


  bool loading = false;
  void requestAPI() async {
    API().getHotWord((value) {
     hotBeans=value;
     setState(() {
       loading = false;
     });
    });
  }

  // 内容展示区

  Widget containerBody() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: <Widget>[
          // Text("还没有友邻的动态，看看别人在说什么..."),
          SliverToBoxAdapter(
            child: Text("还没有友邻的动态，看看别人在说什么..."),
          ),
          buildItemList(),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     child:
          //         TodayPlayMovieWidget(todayUrls, backgroundColor: todayPlayBg),
          //     padding: EdgeInsets.only(top: 22.0),
          //   ),
          // ),
          // SliverToBoxAdapter(
          //   child: hotSoonTabBarPadding,
          // ),
          // SliverGrid(
          //     delegate:
          //         SliverChildBuilderDelegate((BuildContext context, int index) {
          //       var hotMovieBean;
          //       var comingSoonBean;
          //       if (hotShowBeans.length > 0) {
          //         hotMovieBean = hotShowBeans[index];
          //       }
          //       if (comingSoonBeans.length > 0) {
          //         comingSoonBean = comingSoonBeans[index];
          //       }
          //       return Stack(
          //         children: <Widget>[
          //           Offstage(
          //             child: _getComingSoonItem(comingSoonBean, itemW),
          //             offstage: !(selectIndex == 1 &&
          //                 comingSoonBeans != null &&
          //                 comingSoonBeans.length > 0),
          //           ),
          //           Offstage(
          //               child: _getHotMovieItem(hotMovieBean, itemW),
          //               offstage: !(selectIndex == 0 &&
          //                   hotShowBeans != null &&
          //                   hotShowBeans.length > 0))
          //         ],
          //       );
          //     }, childCount: math.min(_getChildCount(), 6)),
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 3,
          //         crossAxisSpacing: 10.0,
          //         mainAxisSpacing: 0.0,
          //         childAspectRatio: _getRadio())),
          // getCommonImg(Constant.IMG_TMP1, (){
          //   MyRouter.pushNoParams(context, "http://www.flutterall.com");
          // }),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
          //     child: ItemCountTitle(
          //       '豆瓣热门',
          //       fontSize: 13.0,
          //       count: hotBeans == null ? 0 : hotBeans.length,
          //     ),
          //   ),
          // ),
          // getCommonSliverGrid(hotBeans),
          // getCommonImg(Constant.IMG_TMP2, null),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
          //     child: ItemCountTitle(
          //       '豆瓣榜单',
          //       count: weeklyBeans == null ? 0 : weeklyBeans.length,
          //     ),
          //   ),
          // ),
          // SliverToBoxAdapter(
          //   child: Container(
          //     height: 100,
          //     child: ListView(
          //       children: [
          //         TopItemWidget(
          //           title: '一周口碑电影榜',
          //           bean: weeklyTopBean,
          //           partColor: weeklyTopColor,
          //         ),
          //         TopItemWidget(
          //           title: '一周热门电影榜',
          //           bean: weeklyHotBean,
          //           partColor: weeklyHotColor,
          //         ),
          //         TopItemWidget(
          //           title: '豆瓣电影 Top250',
          //           bean: weeklyTop250Bean,
          //           partColor: weeklyTop250Color,
          //         )
          //       ],
          //       scrollDirection: Axis.horizontal,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


  //Build
  Widget buildItemList(){
    var screenW = MediaQuery.of(context).size.width;
    var itemH = screenW/16*9/2;
    return SliverFixedExtentList(delegate:  SliverChildBuilderDelegate(
          (_, index) => _getItem(hotBeans[index]),
      childCount: _getChildCount(),
    ), itemExtent: itemH);
  }


  ///影院热映item
  Widget _getItem(DynamicEntity bean) {
    var screenW = MediaQuery.of(context).size.width;
    if (bean == null) {
      return Container();
    }
    return GestureDetector(
      child:Padding(
        padding:EdgeInsets.only(top: 5.0,bottom: 5.0),
        child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors:[Colors.red,Colors.orange.shade700]), //背景渐变
            borderRadius: BorderRadius.circular(15.0), //3像素圆角
            boxShadow: [ //阴影
              BoxShadow(
                  color:Colors.black54,
                  offset: Offset(2.0,2.0),
                  blurRadius: 4.0
              )
            ]
        ),
        child: Stack(
          // textDirection:TextDirection.ltr ,
          alignment: Alignment.center,
          fit: StackFit.expand, //未定位widget占满Stack整个空间
           children: <Widget>[

             ClipRRect(
                 borderRadius: BorderRadius.circular(15.0), //3像素圆角
               child:Image.network(
                 bean.imageUrl,
                 fit: BoxFit.cover,
                 // width: 50.00,
                 // height: 100.00,
               )
             ),

            Positioned(
              top: 5.0,
              left: 15.0,
              child:  Text(
                  bean.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,

                  ),
                ),
            ),
             Positioned(
                 right: 10,
                 child:Text(">",style: TextStyle( fontSize: 20),)
             )
          ],
        ),
      ),

    ) , onTap: () {
      MyRouter.push(context, MyRouter.detailPage, 100);
    });
  }

  int _getChildCount() {
    return hotBeans.length;
  }


}

typedef OnTab = void Function();






//
//var loadingBody = new Container(
//  alignment: AlignmentDirectional.center,
//  decoration: new BoxDecoration(
//    color: Color(0x22000000),
//  ),
//  child: new Container(
//    decoration: new BoxDecoration(
//        color: Colors.white, borderRadius: new BorderRadius.circular(10.0)),
//    width: 70.0,
//    height: 70.0,
//    alignment: AlignmentDirectional.center,
//    child: SizedBox(
//      height: 25.0,
//      width: 25.0,
//      child: CupertinoActivityIndicator(
//        radius: 15.0,
//      ),
//    ),
//  ),
//);
