import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xiao/homePage.dart';

import 'RecommendProvider.dart';

class MePage extends StatefulWidget {
  MePage({
    Key key,
    this.provider,
    this.pageController,
  }) : super(key: key);
  RecommendProvider provider;
  PageController pageController;
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;
  int key = 1;
  List videoData = [];
  bool isnull = false;
  Map userInfo = {};

  Drag drag;
  DragStartDetails dragStartDetails;
  Future<DragPosition> dragPosition;
//appbar里的数据一定要提前加载
  getUserInfo(String uid) async {
    Response re =
        await Dio().get('http://192.168.1.3:8080/api/getUserInfo?uid=$uid');

    setState(() {
      userInfo.addAll(re.data);
      print(userInfo);
    });
  }

  getData(String uid) async {
    Response re = await Dio()
        .get('http://192.168.1.3:8080/api/getUserVideos?uid=$uid&key=$key');
    key++;
    setState(() {
      print(re.data);
      videoData.addAll(re.data);
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _tabController = TabController(vsync: this, length: 2);

    String uid = widget.provider.currentUid;

    getData(uid);

    _scrollViewController.addListener(() {
      print(_scrollViewController.position.pixels);
      print(_scrollViewController.position.maxScrollExtent);

      if (_scrollViewController.position.pixels ==
          _scrollViewController.position.maxScrollExtent) {
        print('我到底了');
        getData(uid);
        print('加载更多$key');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _scrollViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return userInfo == null
        ? Text('data')
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: NestedScrollView(
              // physics: BouncingScrollPhysics(),
              controller: _scrollViewController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 10,
                    leading: Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                    ),
                    actions: [
                      Icon(
                        Icons.more_horiz,
                        size: 15,
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                    // forceElevated: innerBoxIsScrolled,
                    // snap: true,
                    pinned: true,
                    floating: true,
                    expandedHeight: 340,
                    stretch: true,
                    // stretchTriggerOffset: 100,
                    flexibleSpace: FlexibleSpaceBar(
                        stretchModes: [StretchMode.zoomBackground],
                        collapseMode: CollapseMode.pin,
                        background: Container(
                            child: Stack(
                                //头部整个背景颜色
                                // height: double.infinity,
                                // color: Color(0xffcccccc),
                                children: [
                              Container(
                                width: screenWidth,
                                height: 170,
                                child: Image(
                                  image: NetworkImage(widget
                                      .provider.userInfo['avatar_larger']),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  _buildTabBarBg(screenWidth),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 190,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          widget.provider.userInfo['nickname'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          '抖音号： ${widget.provider.userInfo['short_id']}',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 11),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          color: Colors.grey,
                                          width: screenWidth,
                                          height: 0.1,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 55,
                                          child: Text(
                                            widget
                                                .provider.userInfo['signature'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                width: 0.85 * screenWidth,
                                                // margin: EdgeInsets.only(top: 10),
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.redAccent[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      ' 关注',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[500]
                                                        .withOpacity(0.3)),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                top: 100,
                                left: 10,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: widget
                                        .provider.userInfo['avatar_larger'],
                                    height: 70.0,
                                    width: 70.0,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              )
                            ]))),
                    bottom: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.yellow,
                        tabs: [
                          Tab(
                              text:
                                  "作品 ${widget.provider.userInfo['aweme_count']}"),
                          Tab(
                              text:
                                  "喜欢 ${widget.provider.userInfo['favoriting_count']}"),
                        ]),
                  )
                ];
              },
              body: NotificationListener(
                onNotification: handleNotification,
                // onNotification: (notification) {
                //   if (notification is UserScrollNotification &&
                //       notification.direction == ScrollDirection.forward &&
                //       !_tabController.indexIsChanging &&
                //       dragStartDetails != null &&
                //       _tabController.index == 0) {
                //     widget.pageController.position.drag(dragStartDetails, () {});
                //   }

                //   // Simialrly Handle the last tab.
                //   if (notification is UserScrollNotification &&
                //       notification.direction == ScrollDirection.reverse &&
                //       !_tabController.indexIsChanging &&
                //       dragStartDetails != null &&
                //       _tabController.index == _tabController.length - 1) {
                //     widget.pageController.position.drag(dragStartDetails, () {});
                //   }
                // if (notification is ScrollStartNotification) {
                //   dragStartDetails = notification.dragDetails;
                // }
                // if (notification is OverscrollNotification) {
                //   drag =
                //       widget.pageController.position.drag(dragStartDetails, () {});
                //   drag.update(notification.dragDetails);
                // }
                // if (notification is ScrollEndNotification) {
                //   drag?.cancel();
                // }
                // return true;
                // },
                child: _buildListView(),
              ),
            ),
          );
  }

  //用来描述因为Drag触发的滚动操作(实际上还分 startDetails,updateDetails，end...这里我们不用这些)
  //ps:其他原因触发的滚动，此值是null

  bool handleNotification(ScrollNotification notification) {
    //ScrollMetrics 其内部有滚动部件的描述信息和一些实时动作相关的值
    // 如 :minScrollExtent /maxScrollExtent - 最小/大滚动范围
    // pixels - 滚动位置， viewportDimension - 视窗大小 ,
    // axisDirection - 滚动view 的滚动方向   等等，不一而足。
    //如此重要，先初始化一个 metrics
    final ScrollMetrics metrics = notification.metrics;
    //当滑动结束时会进入此方法，我们将一些用过的值置空
    if (notification is ScrollEndNotification) {
      drag = null;
      dragPosition = null;
    }
    //因为我们只需要处理水平滚动所以这里做个判断
    if (metrics.axis == Axis.horizontal) {
      //滑动开始
      if (notification is ScrollStartNotification) {
        log('start');
        if (notification.dragDetails == null) return true;
        //我们保存notification的 dragDetails，
        dragStartDetails = notification.dragDetails;
      }

      ///与 start和end调用时期一样
      if (notification is UserScrollNotification) {
        //这里我们假设 一个水平listview，左侧为头部，右侧为尾部
        //此处判断 A （就是上面个 A widget） 是否已经滑动到头部，且用户继续向头部滑动
        if (metrics.pixels == metrics.minScrollExtent &&
            notification.direction == ScrollDirection.forward) {
          if (drag == null) {
            //那么我们认为用户是想切换上一页了
            //pageController 是外层4个页面的pageview控制器
            //此时我们将通知的dragStartDetails 传到pagecontroller的drag里
            //即，将用户的滑动信息和外层的 pageview controller 挂钩
            drag = widget.pageController.position.drag(dragStartDetails, () {
              //滑动结束后会调用
              drag = null;
            });
          }
          //此方法与上面相同，朝尾部滑动的处理
          // 因为我后面可能还有其他细化操作，所以这里拆成了两个if
        } else if (metrics.pixels == metrics.maxScrollExtent &&
            notification.direction == ScrollDirection.reverse) {
          if (drag == null) {
            drag = widget.pageController.position.drag(dragStartDetails, () {
              drag = null;
            });
          }
        }
      }
    }
    return true;
  }

  Widget _buildBanner(double width) {
    return Container(
      height: 100,
      width: width,
      child: Image(
        image: NetworkImage(
            'https://p11.douyinpic.com/img/tos-cn-avt-0015/edec87eb403135b6ae69bcd6e58eeb4b~c5_1080x1080.jpeg?from=116350172'),
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildButtonItem(IconData icon, String text) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 28.0),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          child: Text(text,
              style: TextStyle(color: Color(0xff999999), fontSize: 12)),
        )
      ],
    ));
  }

  Widget _buildTabBarBg(double width) {
    return Container(
      //TabBar圆角背景颜色
      height: 50,
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: Container(
            padding: EdgeInsets.only(top: 3),
            width: width,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 70,
                ),
                Column(
                  children: [
                    Text(
                      "获赞",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      setData(widget.provider.userInfo['total_favorited']),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  color: Colors.white,
                  width: 1,
                  height: 15,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                ),
                Column(
                  children: [
                    Text(
                      "粉丝",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      setData(widget.provider.userInfo['follower_count']),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Container(
                  color: Colors.white,
                  width: 1,
                  height: 15,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                ),
                Column(
                  children: [
                    Text(
                      "关注",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      setData(widget.provider.userInfo['following_count']),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildListView() {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            childAspectRatio: 0.76),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
            child: Stack(
              children: [
                Container(
                  width: 2000,
                  child: Image(
                    image: NetworkImage(videoData[index]['cover']),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                    bottom: 3,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          setData(videoData[index]['digg_count']),
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        )
                      ],
                    ))
              ],
            ),
          );
        }, childCount: videoData.length));
  }
}

mixin DragPosition {}
