import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:m_loading/m_loading.dart';
import 'package:video_player/video_player.dart';
import 'package:xiao/BottomSheet.dart';
import 'package:xiao/RecommendProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:dio/dio.dart';

import 'package:after_layout/after_layout.dart';
import 'package:xiao/addPage.dart';
import 'package:xiao/sameCity.dart';
import 'package:xiao/sub.dart';
import 'package:xiao/recommend.dart';
import 'flutter_nest_page_view.dart';
import 'mePage.dart';
import 'video.dart';
import 'package:xiao/profiles.dart';
import 'package:xiao/utils.dart';
import 'package:extended_tabs/extended_tabs.dart';

class HomePageMain extends StatefulWidget {
  HomePageMain({Key key}) : super(key: key);

  @override
  _HomePageMainState createState() => _HomePageMainState();
}

double screenWidth;

class _HomePageMainState extends State<HomePageMain>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
            child: ExtendedTabBarView(
          children: [
            HomePage(),
            profileView(
              provider: provider,
            )
          ],
          controller: provider.HomePageController,
          // physics: NeverScrollableScrollPhysics(),
          // physics: provider.currentHomePageindex == 2
          //     ? ClampingScrollPhysics()
          //     : NeverScrollableScrollPhysics(), //防止其他页面可以滑动 可以解决滑动冲突
        ))
      ],
    );
  }
}

class title_pr extends StatefulWidget {
  title_pr({Key key, this.nickname, this.controller}) : super(key: key);
  String nickname;
  PageController controller;
  @override
  _titleState_pr createState() => _titleState_pr(this.nickname);
}

class _titleState_pr extends State<title_pr> {
  String nickname;

  _titleState_pr(this.nickname);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(),
      // border: Border(bottom: BorderSide(color: Colors.black12))),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      // decoration: BoxDecoration(color: Colors.green),
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              // size: 15,
              color: Colors.white,
            ),
            onTap: () {
              widget.controller.jumpTo(0.0);
            },
          ),
          Text(nickname ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Icon(
            Icons.more_horiz,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class profileView extends StatefulWidget {
  profileView({
    Key key,
    this.provider,
  }) : super(key: key);
  RecommendProvider provider;

  @override
  _profileViewState createState() => _profileViewState(this.provider);
}

class _profileViewState extends State<profileView>
    with SingleTickerProviderStateMixin {
  RecommendProvider provider;
  _profileViewState(this.provider);
  int key = 1;
  List videoData = [];
  bool isnull = false;
  Map userInfo = {};
  TabController _tabController;
  double expandheight;

  ScrollController controller = ScrollController();
  bool offsate = true;
  List newdata = [];

  @override
  void dispose() {
    if (provider.isplaying) {
      provider.videoPlayer.play();
    }
    super.dispose();
  }

  //  初始化只执行一次
  @override
  void initState() {
    super.initState();
    provider.videoPlayer.pause();
    _tabController = TabController(vsync: this, length: 2);
    String uid = provider.currentUid;
    // getUserInfo(uid);
    getData(uid);
    controller.addListener(() {
      if (controller.hasClients &&
          controller.offset > expandheight - kToolbarHeight - 20) {
        offsate = false;
        setState(() {});
      } else {
        offsate = true;
        setState(() {});
      }
      print(setExpandHeight);
      print(controller.offset);
      print(kToolbarHeight);

      if (controller.position.pixels == controller.position.maxScrollExtent) {
        getData(uid);
        print('加载更多$key');
      }
    });
  }

  setExpandHeight(height) {
    setState(() {
      expandheight = height;
    });
  }

  // getUserInfo(String uid) async {
  //   Response re = await Dio()
  //       .get('http://101.200.141.108:8080/douyin/getUserInfo?uid=$uid');
  //   // key++;
  //   setState(() {
  //     userInfo.addAll(re.data);
  //     print(userInfo);
  //   });
  // }

  getData(String uid) async {
    Response re = await Dio().get(
        'http://101.200.141.108:8080/douyin/getUserVideos?uid=$uid&key=$key');
    key++;
    if (mounted) {
      setState(() {
        print(re.data);
        videoData.addAll(re.data);
        newdata = re.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,

        // body: NestedScrollView(
        //     // physics: ClampingScrollPhysics(),
        //     controller: provider.controllerMin,
        //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        //       return <Widget>[_buildBanner(), _buildStickyBar(provider)];
        //     },
        //     body: _buildList()),
        body: CustomScrollView(
          physics: ClampingScrollPhysics(),
          controller: controller,
          slivers: <Widget>[
            _appbar(),
            SliverToBoxAdapter(
                child: Offstage(
              child: Container(
                  alignment: Alignment.center,
                  width: screenWidth,
                  height: screenHeight / 3,
                  child: Container(
                    child: BallPulseLoading(
                      ballStyle: BallStyle(
                        size: 8,
                        color: Colors.cyan,
                        ballType: BallType.solid,
                      ),
                    ),
                    width: 50,
                  )),
              offstage: videoData.isNotEmpty,
            )),
            // _buildBanner(),
            // _buildStickyBar(provider),

            // _buildStickyBar(),
            _buildList(),
            SliverToBoxAdapter(child: _loading())
          ],
        ));
  }

  Widget _loading() {
    if (videoData.isNotEmpty) {
      if (newdata.isEmpty) {
        return Container(
          width: screenWidth,
          height: 30,
          alignment: Alignment.center,
          child: Text(
            '没有更多数据了',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      }
      return Container(
          width: screenWidth,
          height: 30,
          alignment: Alignment.center,
          child: Container(
            width: 50,
            child: BallPulseLoading(
              ballStyle: BallStyle(
                size: 8,
                color: Colors.cyan,
                ballType: BallType.solid,
              ),
            ),
          ));
    } else {
      return Container();
    }
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

  Widget _appbar() {
    return SliverAppBar(
        // toolbarHeight: 50,
        title: Offstage(
          child: Text(
            provider.userInfo['nickname'],
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          offstage: offsate,
        ),
        centerTitle: true,
        elevation: 10,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            size: 15,
          ),
          onTap: () {
            widget.provider.HomePageController.animateTo(0,
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
        actions: [
          Offstage(
            offstage: offsate,
            child: Container(
              alignment: Alignment.center,
              width: 40,
              padding: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(),
              margin: EdgeInsets.only(right: 5),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '关注',
                  style: TextStyle(fontSize: 12),
                ),
                decoration: BoxDecoration(
                    color: Colors.redAccent[400],
                    borderRadius: BorderRadius.circular(3)),
                // height: 3,
              ),
            ),
          ),
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
        // floating: true,
        expandedHeight: expandheight,
        stretch: true,
        // stretchTriggerOffset: 100,
        flexibleSpace: FlexibleSpaceBar(
            stretchModes: [StretchMode.zoomBackground],
            collapseMode: CollapseMode.pin,
            background: Container(
                child: Layout_appbar(
              provider: widget.provider,
              updatafunction: setExpandHeight,
            ))),
        bottom: PreferredSize(
          child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.yellow,
              tabs: [
                Tab(
                    text: "作品 " +
                        setData(widget.provider.userInfo['aweme_count'])),
                Tab(
                    text: "喜欢 " +
                        setData(widget.provider.userInfo['favoriting_count'])),
              ]),
          preferredSize: Size.fromHeight(20),
        ));
  }

  Widget _buildList() {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            childAspectRatio: 0.76),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return video(
                    videodata: videoData[index],
                    provider: provider,
                    index: index,
                    isprofile: true,
                  );
                },
              ));
            },
            child: Hero(
              tag: index.toString() + 'true',
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
            ),
          );
        }, childCount: videoData.length));
  }

  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: userInfo['avatar_larger'],
                  height: 100.0,
                  width: 100.0,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "@${userInfo['nickname']}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    setData(userInfo['total_favorited']),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "获赞",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
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
                    setData(userInfo['follower_count']),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "粉丝",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
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
                    setData(userInfo['following_count']),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "关注",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 47,
                decoration: BoxDecoration(
                  color: Colors.pink[500],
                ),
                child: Center(
                  child: Text(
                    "Follow",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 45,
                height: 47,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.pink)),
                child: Center(
                    child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                )),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 35,
                height: 47,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.pink)),
                child: Center(
                    child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                )),
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBar(RecommendProvider provider) {
    return SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 45, //收起的高度
        maxHeight: 45, //展开的最大高度
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(width: 0.1, color: Colors.pink)),
              // border: Border.all(color: Colors.white),
              color: Theme.of(context).primaryColor),
          child: TabBar(
            // indicatorSize: TabBarIndicatorSize.label,

            indicatorColor: Colors.yellow,
            indicatorWeight: 3,

            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
            // 下划线颜色
            unselectedLabelStyle: TextStyle(
                color: Colors.black26,
                // fontSize: 14,
                fontWeight: FontWeight.w600),
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            controller: provider.ct,
            tabs: [
              Text('作品 ' + setData(userInfo['aweme_count'])),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('喜欢 '),
                  Icon(
                    Icons.lock,
                    size: 13,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class appbar extends StatefulWidget {
  appbar({Key key, this.provider}) : super(key: key);
  RecommendProvider provider;
  @override
  _appbarState createState() => _appbarState();
}

class _appbarState extends State<appbar> with SingleTickerProviderStateMixin {
  TabController _tabControlle;

  @override
  void initState() {
    super.initState();
    _tabControlle = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        //头部整个背景颜色
        // height: double.infinity,
        // color: Color(0xffcccccc),
        children: [
          Column(mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth,
                  height: 100,
                  child: Image(
                    image:
                        NetworkImage(widget.provider.userInfo['avatar_larger']),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.provider.userInfo['nickname'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 1),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: screenWidth,
                  child: Text(
                    '抖音号： ${widget.provider.userInfo['short_id']}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    color: Colors.grey,
                    width: screenWidth,
                    height: 0.2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(top: 8),
                  width: screenWidth,
                  child: Text(
                    widget.provider.userInfo['signature'],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(top: 8),
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 0.86 * screenWidth,
                          // margin: EdgeInsets.only(top: 10),
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.redAccent[400],
                              borderRadius: BorderRadius.circular(2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15,
                              ),
                              Text(
                                ' 关注',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          )),
                      Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey[500].withOpacity(0.3)),
                          child: Center(
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 20,
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                )
              ]),
          Positioned(
            child: _buildTabBarBg(screenWidth),
            top: 90,
          ),
          Positioned(
            top: 70,
            left: 10,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.provider.userInfo['avatar_larger'],
                height: 70.0,
                width: 70.0,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ]);
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
}

class Layout_appbar extends StatefulWidget {
  Layout_appbar({Key key, this.provider, this.updatafunction})
      : super(key: key);
  RecommendProvider provider;
  Function(double) updatafunction;

  @override
  _Layout_appbarState createState() => _Layout_appbarState();
}

class _Layout_appbarState extends State<Layout_appbar> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return appbar(provider: widget.provider);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox box = context.findRenderObject();
    double height =
        box.getMaxIntrinsicHeight(MediaQuery.of(context).size.width);
    widget.updatafunction(height);
  }
}

class profileView2 extends StatelessWidget {
  const profileView2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              // shadowColor: Colors.black12,
              elevation: 1.0,
              centerTitle: true,
              title: title_pr(),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
            )),
        body: CustomScrollView(
          slivers: <Widget>[
            _buildBanner(),
            _buildStickyBar(provider),

            // _buildStickyBar(),
            _buildList(provider),
          ],
        ));
  }

  Widget _buildList(RecommendProvider provider) {
    List img_url = [
      'https://p3.douyinpic.com/tos-cn-p-0015/41eecc42399445e48e17abc0ac4a79c8_1623992847~tplv-dy-360p.jpeg?from=4257465056&s=&se=false&sh=&sc=&l=2021061813283601021214407511011C83&biz_tag=feed_cover',
      'https://p3.douyinpic.com/tos-cn-p-0015/41eecc42399445e48e17abc0ac4a79c8_1623992847~tplv-dy-360p.jpeg?from=4257465056&s=&se=false&sh=&sc=&l=2021061813283601021214407511011C83&biz_tag=feed_cover',
      'https://p3.douyinpic.com/tos-cn-p-0015/41eecc42399445e48e17abc0ac4a79c8_1623992847~tplv-dy-360p.jpeg?from=4257465056&s=&se=false&sh=&sc=&l=2021061813283601021214407511011C83&biz_tag=feed_cover',
      'https://p3.douyinpic.com/tos-cn-p-0015/41eecc42399445e48e17abc0ac4a79c8_1623992847~tplv-dy-360p.jpeg?from=4257465056&s=&se=false&sh=&sc=&l=2021061813283601021214407511011C83&biz_tag=feed_cover',
      'https://p3.douyinpic.com/tos-cn-p-0015/41eecc42399445e48e17abc0ac4a79c8_1623992847~tplv-dy-360p.jpeg?from=4257465056&s=&se=false&sh=&sc=&l=2021061813283601021214407511011C83&biz_tag=feed_cover',
      'https://p3.douyinpic.com/tos-cn-p-0015/41eecc42399445e48e17abc0ac4a79c8_1623992847~tplv-dy-360p.jpeg?from=4257465056&s=&se=false&sh=&sc=&l=2021061813283601021214407511011C83&biz_tag=feed_cover'
    ];
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            childAspectRatio: 0.76),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
            child: Text(provider.currentUid),
            // child: Image(
            //   image: NetworkImage(
            //     img_url[index],
            //   ),
            //   fit: BoxFit.fitWidth,
            // ),
          );
        }, childCount: img_url.length));
  }

  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://www.andersonsobelcosmetic.com/wp-content/uploads/2018/09/chin-implant-vs-fillers-best-for-improving-profile-bellevue-washington-chin-surgery.jpg",
                  height: 100.0,
                  width: 100.0,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "@Charlotte21",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "232",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Following",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Container(
                color: Colors.black54,
                width: 1,
                height: 15,
                margin: EdgeInsets.symmetric(horizontal: 15),
              ),
              Column(
                children: [
                  Text(
                    "1.3k",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Followers",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Container(
                color: Colors.black54,
                width: 1,
                height: 15,
                margin: EdgeInsets.symmetric(horizontal: 15),
              ),
              Column(
                children: [
                  Text(
                    "12k",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Likes",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 47,
                decoration: BoxDecoration(
                  color: Colors.pink[500],
                ),
                child: Center(
                  child: Text(
                    "Follow",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 45,
                height: 47,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Center(child: Icon(Icons.camera_alt)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 35,
                height: 47,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Center(child: Icon(Icons.arrow_drop_down)),
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBar(RecommendProvider provider) {
    return SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 45, //收起的高度
        maxHeight: 45, //展开的最大高度
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12), color: Colors.white),
          child: TabBar(
            // indicatorSize: TabBarIndicatorSize.label,

            indicatorColor: Colors.yellow,
            indicatorWeight: 3,

            labelColor: Colors.black,
            unselectedLabelColor: Colors.black26,
            // 下划线颜色
            unselectedLabelStyle: TextStyle(
                color: Colors.black26,
                fontSize: 14,
                fontWeight: FontWeight.w600),
            labelStyle: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
            controller: provider.ct,
            tabs: [
              Icon(
                Icons.menu,
                // color: Colors.black,
              ),
              Icon(
                Icons.favorite_border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    double screenWigth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        ExtendedTabBarView(
          controller: provider.controller,
          children: [
            SameCity(),
            Sub(),
            Recomend(),
          ],
        ),
        Positioned(
            top: 15,
            height: 80,
            width: screenWigth,
            child: Container(decoration: BoxDecoration(), child: Tabbar())),
      ],
    );
  }
}

class Tabbar extends StatefulWidget {
  Tabbar({
    Key key,
  }) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    return Container(
      height: 40,
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.live_tv,
            color: Colors.grey[400],
          ),
          Container(
              width: 0.55 * screenWidth,
              child: ExtendedTabBar(
                indicatorSize: TabBarIndicatorSize.label,
                controller: provider.controller,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                // 下划线颜色
                unselectedLabelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700), //标签文字大小颜色
                tabs: [
                  Text('同城'),
                  Text('关注'),
                  Text('推荐'),
                ],
              )),
          Icon(
            Icons.search,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}

class Addicon extends StatelessWidget {
  const Addicon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    double screenWigth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddPage(
            provider: provider,
          );
        }));
      },
      child: Container(
          height: 28,
          width: 50,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(8)),
                ),
                height: 28,
                width: 45,
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8)),
                ),
                height: 28,
                width: 45,
                right: 0,
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
                height: 28,
                width: 45,
                right: 2.5,
              )
            ],
          )),
    );
  }
}

getbutton(String content, bool isselect) {
  return Text("$content",
      style: isselect
          ? TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700)
          : TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600));
}

class Title extends StatelessWidget {
  const Title({Key key, this.title, this.username, this.music})
      : super(key: key);
  final String title;
  final String username;
  final String music;

  @override
  Widget build(BuildContext context) {
    double screenWigth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Text(
                  '@$username',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Offstage(
                offstage: title == '',
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.music_note,
              color: Colors.white,
              // size: 20,
            ),
            Container(
                height: 20,
                width: screenWigth * 0.4,
                child: MarqueeWidget(
                  text: '$music',
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ))
          ],
        )
      ],
    );
  }
}

class RoateMusic extends StatefulWidget {
  RoateMusic({Key key, @required this.music_image}) : super(key: key);
  String music_image;
  @override
  _RoateMusicState createState() => _RoateMusicState(this.music_image);
}

class _RoateMusicState extends State<RoateMusic>
    with SingleTickerProviderStateMixin {
  String music_image;
  AnimationController controller;
  Animation animation;

  _RoateMusicState(this.music_image);
  @override
  void initState() {
    // print('建安十年酒啊就是卡死NSA九三$music_image');
    // TODO: implement initState
    super.initState();
    //chuang jian animationcontroller zhixing shijian
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3500),
    );
    //sheng ming donghua quxian
    // animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    //she zhi donghua zhide fanwei  shangmianshi 0-1 bushihe daxiao shuziqudongdonghua aniamte shi donghua donghuazhixngluxian quxian interval keyi shehziquxian
    animation = Tween(begin: 0.0, end: 2 * pi)
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 1.0)))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.forward(from: 0.0);
            }
          });
    //jian tin donghua
    animation.addListener(() {
      setState(() {});
    });
    //zhixing donghua rangdonghua fanfuzhixing

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Transform.rotate(
          angle: animation.value,
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.8),
                borderRadius: BorderRadius.circular(22.5)),
            child: Center(
              child: Container(
                width: 25,
                height: 25,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(music_image),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //dangqian zujiande shengmingzhouqi qiedou houtai

}

class IconText extends StatelessWidget {
  const IconText({Key key, this.icon, this.text}) : super(key: key);
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(
            text,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

showBottom(BuildContext context, double screenHeight, int commentcount,
    double screenWidth) {
  // RecommendProvider provider = Provider.of<RecommendProvider>(context);
  // provider.hideBottomBar();
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();

  showModalBottomSheet(
      // backgroundColor: Colors.black,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          height: 0.8 * screenHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                height: 30,
                width: screenWidth,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: BottomsheetTitle(
                  commentcount: commentcount,
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                width: screenWidth,
                height: screenHeight * 0.8 - 85,
                // padding: EdgeInsets.symmetric(horizontal: 10),
                // alignment: Alignment.topLeft,
                // margin: EdgeInsets.only(top: 5),
                // color: Colors.yellow,
                child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://p26.douyinpic.com/img/tos-cn-avt-0015/d9ea776bbe30db6f083b21e2136ce6a1~c5_1080x1080.jpeg?from=116350172'),
                        ),
                      ),
                      title: Text('小一',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12)),
                      subtitle: Text(
                        '哈哈撒娇谩骂满是',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.favorite,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: screenWidth,
                height: 50,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        color: Colors.black,
                        height: 50,
                        width: screenWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),

                                // margin: EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(15)),
                                width: 0.7 * screenWidth,
                                height: 30,
                                child: TextField(
                                  // maxLength: 50,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                  decoration: InputDecoration(
                                      // border: OutlineInputBorder(),
                                      border: InputBorder.none,
                                      hintText: '有爱评论，说点好听的~',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600])),
                                )),
                            Icon(
                              IconData(0xe60a, fontFamily: 'iconfont'),
                              color: Colors.grey[600],
                            ),
                            Icon(IconData(0xe7d9, fontFamily: 'iconfont'),
                                color: Colors.grey[600])
                          ],
                        ),
                      ),
                      bottom: 0,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
}

class BottomsheetTitle extends StatelessWidget {
  const BottomsheetTitle({Key key, this.commentcount}) : super(key: key);
  final int commentcount;
  @override
  Widget build(BuildContext context) {
    return commentcount > 0
        ? Text(
            '$commentcount条评论',
            style: TextStyle(color: Colors.white),
          )
        : Text(
            '暂无评论',
            style: TextStyle(color: Colors.white),
          );
  }
}

String setData(int count) {
  String data;
  if (count == null) {
    data = '';
  } else if (count >= 10000 && count < 100000000) {
    data = (count / 10000).toString() + "w";
  } else if (count >= 100000000) {
    data = (count / 100000000).toStringAsFixed(1) + "亿";
  } else {
    data = count.toString();
  }
  return data;
}
