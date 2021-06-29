import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:xiao/video.dart';

import 'RecommendProvider.dart';
import 'homePage.dart';
import 'package:m_loading/m_loading.dart';

class ProfileS extends StatefulWidget {
  ProfileS(
      {Key key,
      this.userInfo,
      this.currentUid,
      this.videoplayer,
      this.isplaying})
      : super(key: key);
  String pagetype;
  Map userInfo;
  String currentUid;
  VideoPlayerController videoplayer;
  bool isplaying;

  @override
  _ProfileSState createState() => _ProfileSState();
}

class _ProfileSState extends State<ProfileS> {
  @override
  void initState() {
    super.initState();
    widget.videoplayer.pause();
  }

  @override
  void dispose() {
    // print('哈设备把俺不是那俺三阿巴斯那傻不傻那是啊');
    if (widget.isplaying) {
      widget.videoplayer.play();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('profile');
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    return profileView(
      provider: provider,
      userInfo: widget.userInfo,
      currentUid: widget.currentUid,
      videoplayer: widget.videoplayer,
      isplaying: widget.isplaying,
    );
  }
}

class profileView extends StatefulWidget {
  profileView(
      {Key key,
      this.provider,
      this.userInfo,
      this.currentUid,
      this.videoplayer,
      this.isplaying})
      : super(key: key);
  RecommendProvider provider;
  Map userInfo;
  String currentUid;
  VideoPlayerController videoplayer;
  bool isplaying;

  @override
  _profileViewState createState() =>
      _profileViewState(this.provider, this.userInfo, this.currentUid);
}

class _profileViewState extends State<profileView>
    with SingleTickerProviderStateMixin {
  RecommendProvider provider;
  _profileViewState(this.provider, this.userInfo, this.currentUid);
  int key = 1;
  List videoData = [];
  bool isnull = false;
  Map userInfo;
  String currentUid;
  List newdata = [];

  TabController _tabController;
  double expandheight;

  ScrollController controller = ScrollController();
  bool offsate = true;
  bool isoffsate = false;
  //  初始化只执行一次

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      print("  页面渲染完毕");
    });
    super.initState();
    provider.setCurrentUserInfo(userInfo);
    provider.setCurrentTypeUid(currentUid);
    _tabController = TabController(vsync: this, length: 2);

    // getUserInfo(uid);
    getData(currentUid);
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
        getData(currentUid);
        print('加载更多$key');
      }
    });
  }

  setExpandHeight(height) {
    setState(() {
      expandheight = height;
    });
  }

  setoffsate(bool data) {
    setState(() {
      isoffsate = data;
    });
  }

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
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
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
            layout_List(
              videoData: videoData,
              isloading: setoffsate,
            ),
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

  Widget _appbar() {
    return SliverAppBar(
        // toolbarHeight: 50,
        title: Offstage(
          child: Text(
            userInfo['nickname'],
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
            Navigator.pop(context);
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
              data: userInfo,
              updatafunction: setExpandHeight,
            ))),
        bottom: PreferredSize(
          child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.yellow,
              tabs: [
                Tab(text: "作品 " + setData(userInfo['aweme_count'])),
                Tab(text: "喜欢 " + setData(userInfo['favoriting_count'])),
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
                    // width: 2000,
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
}

class appbar extends StatefulWidget {
  appbar({Key key, this.provider, this.userInfo}) : super(key: key);
  RecommendProvider provider;
  Map userInfo;
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
                    image: NetworkImage(widget.userInfo['avatar_larger']),
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
                    widget.userInfo['nickname'],
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
                    '抖音号： ${widget.userInfo['short_id']}',
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
                    widget.userInfo['signature'],
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
                imageUrl: widget.userInfo['avatar_larger'],
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
                      setData(widget.userInfo['total_favorited']),
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
                      setData(widget.userInfo['follower_count']),
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
                      setData(widget.userInfo['following_count']),
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
  Layout_appbar({Key key, this.provider, this.updatafunction, this.data})
      : super(key: key);
  RecommendProvider provider;
  Function(double) updatafunction;
  Map data;

  @override
  _Layout_appbarState createState() => _Layout_appbarState();
}

class _Layout_appbarState extends State<Layout_appbar> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return appbar(
      provider: widget.provider,
      userInfo: widget.data,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox box = context.findRenderObject();
    double height =
        box.getMaxIntrinsicHeight(MediaQuery.of(context).size.width);
    widget.updatafunction(height);
  }
}

class layout_List extends StatefulWidget {
  layout_List({Key key, this.videoData, this.isloading}) : super(key: key);
  final List videoData;
  Function(bool) isloading;
  @override
  _layout_ListState createState() => _layout_ListState();
}

class _layout_ListState extends State<layout_List> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return itemLsit(videoData: widget.videoData);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    widget.isloading(true);
  }
}

class itemLsit extends StatefulWidget {
  itemLsit({Key key, this.videoData}) : super(key: key);
  List videoData;

  @override
  _itemLsitState createState() => _itemLsitState(this.videoData);
}

class _itemLsitState extends State<itemLsit> {
  List videoData;

  _itemLsitState(this.videoData);
  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
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
}
