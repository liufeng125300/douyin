import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m_loading/m_loading.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:xiao/homePage.dart';
import 'package:xiao/utils.dart';

import 'RecommendProvider.dart';

class videoSM extends StatefulWidget {
  videoSM({
    Key key,
    this.videodata,
    this.provider,
    this.index,
    this.isprofile,
  }) : super(key: key);
  Map videodata;
  RecommendProvider provider;
  int index;
  bool isprofile;

  @override
  _videoSMState createState() => _videoSMState();
}

//页面跳转不涉及，页面切换才需要

class _videoSMState extends State<videoSM> {
  Map userInfo;
  String uid;
  @override
  void initState() {
    super.initState();
    uid = widget.videodata['uid'];
    getUserInfo(uid);
  }

  getUserInfo(String uid) async {
    Response re = await Dio()
        .get('http://101.200.141.108:8080/douyin/getUserInfo?uid=$uid');
    // key++;
    userInfo = re.data;
    if (mounted) {
      setState(() {}); //必须刷新因为这是stateflu组件，不setState数据不变不刷新
    }
  }

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);

    double screenWigth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Stack(
          children: [
            Hero(
              tag: widget.index.toString() + widget.isprofile.toString(),
              child: VideoPalyerSM(
                url: widget.videodata['download_addr'],
                uid: widget.videodata['uid'],
                provider: widget.provider,
                index: widget.index,
                isprofile: widget.isprofile,
              ),
            ),
            GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () {
                if (provider.videoPlayerSC.value.isInitialized) {
                  if (provider.videoPlayerSC.value.isPlaying) {
                    provider.videoPlayerSC.pause();
                    provider.setIsplayingvideowidget();
                  } else {
                    provider.videoPlayerSC.play();
                    provider.setIsplayingvideowidget();
                  }
                  setState(() {});
                } else {}
              },
            ),
            Positioned(
                top: 20,
                child: Container(
                  height: 40,
                  width: screenWigth,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      )
                    ],
                  ),
                )),
            Positioned(
                bottom: 5,
                // width: 0.80 * screenWigth,
                // height: 100,

                child: Container(
                  decoration: BoxDecoration(),
                  constraints: BoxConstraints(maxWidth: 0.80 * screenWigth),
                  child: Title(
                    username: widget.videodata['nickname'],
                    title: widget.videodata['desc'],
                    music: widget.videodata['music'],
                  ),
                )),
            Positioned(
                right: 0,
                width: screenWigth * 0.15,
                // top: 0.3 * screenHeight,S
                height: 0.5 * screenHeight,
                bottom: 5,
                child: Container(
                  decoration: BoxDecoration(),
                  child: getButtonList(
                      context,
                      widget.videodata['avatar_larger'],
                      widget.videodata['comment_count'],
                      widget.videodata['digg_count'],
                      widget.videodata['share_count'],
                      widget.videodata['music_image'],
                      screenHeight,
                      screenWigth,
                      userInfo,
                      uid,
                      provider.videoPlayerSC,
                      provider.isplayingVideoSC,
                      widget.isprofile),
                )),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, //e 空白相隔  ar 空白包围 aro 空白放中间平分
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
                    style: TextStyle(color: Colors.white, fontSize: 11),
                    decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        border: InputBorder.none,
                        hintText: '有爱评论，说点好听的~',
                        hintStyle: TextStyle(color: Colors.grey[600])),
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
      ),
    );
  }
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

class VideoPalyerSM extends StatefulWidget {
  VideoPalyerSM(
      {Key key,
      @required this.url,
      this.provider,
      this.uid,
      this.index,
      this.isprofile})
      : super(key: key);
  bool isprofile;
  int index;
  String url;
  String uid;
  RecommendProvider provider;
  @override
  _VideoPalyerSMState createState() => _VideoPalyerSMState(
      this.url, this.provider, this.uid, this.index, this.isprofile);
}

class _VideoPalyerSMState extends State<VideoPalyerSM> {
  bool isprofile;
  String url;
  String uid;
  VideoPlayerController videoPlayer;
  RecommendProvider provider;
  int index;

  //控制更新视频加载初始化完成状态更新
  Future videoPalyFuture;

  _VideoPalyerSMState(
      this.url, this.provider, this.uid, this.index, this.isprofile);
  Map userInfo;

  double asp;
  @override
  void initState() {
    super.initState();
    provider.initisplayingVideoWidget();
    videoPlayer = VideoPlayerController.network(url);
    provider.setVideroWidgetPlayder(videoPlayer);
    videoPlayer.setLooping(true);
    videoPalyFuture = videoPlayer.initialize().then((_) {
      videoPlayer.play();
      asp = videoPlayer.value.aspectRatio;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    double as1 = screenWidth / (screenheight - 50);

    return Container(
      width: screenWidth,
      child: Stack(
        children: [BuildVideoWidget(screenWidth, screenheight), videobutton()],
      ),
    );
  }

  BuildVideoWidget(double screenwidth, double screenheight) {
    double as1 = screenwidth / (screenheight - 50);

    return FutureBuilder(
      future: videoPalyFuture,
      builder: (BuildContext context, value) {
        if (value.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              if (videoPlayer.value.isInitialized) {
                if (videoPlayer.value.isPlaying) {
                  videoPlayer.pause();
                  provider.setIsplayingvideowidget();
                } else {
                  videoPlayer.play();
                  provider.setIsplayingvideowidget();
                }
                setState(() {});
              } else {}
            },
            child: Center(
              child: AspectRatio(
                aspectRatio: resize(asp, as1),
                child: VideoPlayer(
                  videoPlayer,
                ),
              ),
            ),
          );
        } else {
          return Container(
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
        }
      },
    );
  }

  videobutton() {
    Widget item = Container();
    if (videoPlayer.value.isInitialized && !videoPlayer.value.isPlaying) {
      item = GestureDetector(
        onTap: () {
          videoPlayer.play();
          provider.setIsplayingvideowidget();
          setState(() {});
        },
        child: Container(
          // width: 40,
          // height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Icon(
            IconData(0xe653, fontFamily: 'iconfont'),
            color: Colors.white.withOpacity(0.2),
            size: 40,
          ),
        ),
      );
    }
    return Align(
      alignment: Alignment(0, 0),
      child: Offstage(
        child: item,
        offstage: provider.isplayingVideoSC,
      ),
      //必须用变化的
    );
  }

  resize(double asp, double asp1) {
    if (this.asp < 1) {
      this.asp = asp1;
    }
    return this.asp;
  }

  @override
  void dispose() {
    super.dispose();

    // 目前是全局只有一个videoplayer所以不用每一个视频结束后dispose  这个只有一个要销毁
    videoPlayer.dispose();
  }
}
