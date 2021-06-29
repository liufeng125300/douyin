// import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:xiao/BottomSheet.dart';
import 'package:xiao/RecommendProvider.dart';
import 'package:xiao/addPage.dart';
import 'package:xiao/friendsPage.dart';
import 'package:xiao/homePage.dart';
import 'package:xiao/mePage.dart';
import 'package:xiao/messagepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:xiao/selfPage.dart';

void main() {
  runApp(MyApp());

  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => RecommendProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          platform: TargetPlatform.iOS,
          primaryColor: Color(0xff121319),
        ),
        title: 'tiktok',
        home: Root(),
      ),
    );
  }
}

class Root extends StatelessWidget {
  const Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    return MainHome(
      provider: provider,
    );
  }
}

class MainHome extends StatefulWidget {
  MainHome({Key key, this.provider}) : super(key: key);
  RecommendProvider provider;
  @override
  _MainHomeState createState() => _MainHomeState();
}

//tabbar 必须写在stateful里 vsync 动画效果 实例化要在inITstate中

class _MainHomeState extends State<MainHome> with TickerProviderStateMixin {
  //tabbar 必须写在stateful里 vsync 动画效果 实例化要在inITstate中
  TabController controller;
  List isselected = [true, false, false, false, false];
  bool currentselect = true;
  int currentPageIndex = 0;
  List<Widget> pages = [
    HomePageMain(),
    NotePage(),
    AddPage(),
    MessagePage(),
    SelfPage()
  ];
  TabController homeTabcontroller;
  PageController pageController;
  TabController HomeMainController;
  getmeInfo() async {
    Response re = await Dio().get(
        'http://101.200.141.108:8080/douyin/getUserInfo?uid=${widget.provider.userId}');
    // key++;
    setState(() {
      print(re.data);
      widget.provider.setmeInfo(re.data);
    });
  }

  @override
  void initState() {
    super.initState();

    getmeInfo();

    controller = TabController(length: 5, vsync: this, initialIndex: 0);
    homeTabcontroller = widget.provider.controller;
    pageController = widget.provider.pageController;
    HomeMainController = widget.provider.HomePageController;
    homeTabcontroller.addListener(() {
      print('index是：${homeTabcontroller.index}');
      if (1 < 2) {
        // print(homeTabcontroller.index);
        if (homeTabcontroller.index == 0) {
          widget.provider.sethomepageindex(0);
        } else if (homeTabcontroller.index == 1) {
          widget.provider.videoPlayer.pause();
          widget.provider.sethomepageindex(1);

          if (widget.provider.isplayingsub) {
            widget.provider.videoPlayersub.play();
            // widget.provider.videoPlayer.pause();
            return;
          }
        } else {
          widget.provider.videoPlayersub.pause();
          widget.provider.sethomepageindex(2);

          if (widget.provider.isplaying) {
            widget.provider.videoPlayer.play();
            // widget.provider.videoPlayersub.pause();
            return;
          }
        }
        widget.provider.videoPlayer.pause();
        widget.provider.videoPlayersub.pause();
      }
    });

    controller.addListener(() {
      if (controller.indexIsChanging) {
        widget.provider.setcurrentBottomPageIndex(controller.index);
        print(widget.provider.isplaying);
        if (controller.index == 0) {
          if (widget.provider.isplaying &&
              widget.provider.currentHomePageindex == 2) {
            widget.provider.videoPlayer.play();
            return;
          } else if (widget.provider.isplayingsub &&
              widget.provider.currentHomePageindex == 1) {
            widget.provider.videoPlayersub.play();
            return;
          }
        }
        widget.provider.videoPlayer.pause();
        widget.provider.videoPlayersub.pause();
      }
      ;
    });

    pageController.addListener(() {
      print('当前的page是：${pageController.page}');
      if (pageController.hasClients) {
        if (pageController.page == 0.0) {
          if (widget.provider.isplaying &&
              widget.provider.currentHomePageindex == 2) {
            widget.provider.videoPlayer.play();
            return;
          } else if (widget.provider.isplayingsub &&
              widget.provider.currentHomePageindex == 1) {
            widget.provider.videoPlayersub.play();
            return;
          }
        }
        widget.provider.videoPlayer.pause();
        widget.provider.videoPlayersub.pause();
      }
    });
    // HomeMainController.addListener(() {
    //   print('当前的page是：${HomeMainController.index}');

    //   //不需要判断改变再判断
    //   if (HomeMainController.index == 0) {
    //     print(1);
    //     if (widget.provider.isplaying &&
    //         widget.provider.currentHomePageindex == 2) {
    //       widget.provider.videoPlayer.play();
    //       return;
    //     } else if (widget.provider.isplayingsub &&
    //         widget.provider.currentHomePageindex == 1) {
    //       widget.provider.videoPlayersub.play();
    //       return;
    //     }
    //   }
    //   widget.provider.videoPlayer.pause();
    //   widget.provider.videoPlayersub.pause();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: TabBarView(
          children: pages,
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
        ),
        // child: pages[currentPageIndex],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(
                    top: BorderSide(width: 1, color: Colors.grey.shade900))),
            height: 50,
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
                highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
              ),
              child: TabBar(
                labelPadding: EdgeInsets.all(0),
                indicator: BoxDecoration(),
                unselectedLabelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
                controller: controller,
                tabs: [
                  Text('首页'),
                  Text('笔记'),
                  Addicon(),
                  Text('消息'),
                  Text('我')
                ],
              ),
            ),
          )),
      // bottomNavigationBar: BottomAppBar(
      //   color: Theme.of(context).primaryColor,
      //   child: Container(
      //     decoration: BoxDecoration(
      //         color: Theme.of(context).primaryColor,
      //         border: Border(
      //             top: BorderSide(width: 1, color: Colors.grey.shade900))),
      //     height: 50,
      //     child: Container(
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           GestureDetector(
      //             child: getbutton(
      //               '首页',
      //               isselected[0],
      //             ),
      //             onTap: () {
      //               setState(() {
      //                 print(1);
      //                 currentPageIndex = 0;
      //                 for (int i = 0; i <= 4; i++) {
      //                   if (i == 0) {
      //                     isselected[i] = true;
      //                   } else {
      //                     isselected[i] = false;
      //                   }
      //                 }
      //               });
      //             },
      //           ),
      //           GestureDetector(
      //             child: getbutton(
      //               '朋友',
      //               isselected[1],
      //             ),
      //             onTap: () {
      //               setState(() {
      //                 currentPageIndex = 1;
      //                 for (int i = 0; i <= 4; i++) {
      //                   if (i == 1) {
      //                     isselected[i] = true;
      //                   } else {
      //                     isselected[i] = false;
      //                   }
      //                 }
      //               });
      //             },
      //           ),
      //           GestureDetector(
      //             child: Addicon(),
      //             onTap: () {
      //               setState(() {
      //                 currentPageIndex = 2;
      //                 for (int i = 0; i <= 4; i++) {
      //                   if (i == 2) {
      //                     isselected[i] = true;
      //                   } else {
      //                     isselected[i] = false;
      //                   }
      //                 }
      //               });
      //             },
      //           ),
      //           GestureDetector(
      //             child: getbutton(
      //               "消息",
      //               isselected[3],
      //             ),
      //             onTap: () {
      //               setState(() {
      //                 currentPageIndex = 3;
      //                 for (int i = 0; i <= 4; i++) {
      //                   if (i == 3) {
      //                     isselected[i] = true;
      //                   } else {
      //                     isselected[i] = false;
      //                   }
      //                 }
      //                 print(2);
      //               });
      //             },
      //           ),
      //           GestureDetector(
      //             child: getbutton(
      //               '我',
      //               isselected[4],
      //             ),
      //             onTap: () {
      //               setState(() {
      //                 currentPageIndex = 4;
      //                 for (int i = 0; i <= 4; i++) {
      //                   if (i == 4) {
      //                     isselected[i] = true;
      //                   } else {
      //                     isselected[i] = false;
      //                   }
      //                 }
      //               });
      //             },
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
    ); // )), //声明作用域中有哪些provider
  }
}
