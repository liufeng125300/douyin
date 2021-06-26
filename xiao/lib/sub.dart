import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:xiao/RecommendProvider.dart';
import 'package:xiao/utils.dart';

import 'homePage.dart';

class Sub extends StatefulWidget {
  Sub({Key key}) : super(key: key);

  @override
  _SubState createState() => _SubState();
}

class _SubState extends State<Sub> with AutomaticKeepAliveClientMixin {
  SwiperController controller = SwiperController();
  List videoData = [];
  int key = 1;
  Map userInfo = {};
  @override
  @override
  void initState() {
    super.initState();
    getData();
    controller.addListener(() {});
  }

  getData() async {
    Response re =
        await Dio().get('http://101.200.141.108:8080/douyin/getdata?key=$key');
    if (mounted) {
      key++;
      setState(() {
        print(re.data);
        videoData.addAll(re.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);

    return Swiper(
      physics: ClampingScrollPhysics(),
      controller: controller,
      loop: false,
      onIndexChanged: (index) {
        provider.setSubUid(videoData[index]['uid']);
        if (index == videoData.length - 1) {
          getData();
        }

        print("当前index是$index");
        print(provider.currentUid);
      },
      itemCount: videoData.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Subcontent(
          data: videoData[index],
          index: index,
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Subcontent extends StatefulWidget {
  const Subcontent({Key key, this.data, this.index}) : super(key: key);
  final int index;
  final Map data;
  @override
  _SubcontentState createState() => _SubcontentState(this.data, this.index);
}

class _SubcontentState extends State<Subcontent> {
  final int index;
  final Map data;

  _SubcontentState(this.data, this.index);
  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        VideoPlayerSub(
          url: data['download_addr'],
          uid: data['uid'],
          provider: provider,
          index: index,
        ),
        GestureDetector(
          child: Container(
            color: Colors.transparent,
          ),
          onTap: () {
            if (provider.videoPlayersub.value.isInitialized) {
              if (provider.videoPlayersub.value.isPlaying) {
                provider.videoPlayersub.pause();
                provider.setIsplayingsub();
              } else {
                provider.videoPlayersub.play();
                provider.setIsplayingsub();
              }
              setState(() {});
            } else {}
          },
        ),
        Positioned(
            bottom: 5,
            // width: 0.80 * screenWigth,
            // height: 100,

            child: Container(
              decoration: BoxDecoration(),
              constraints: BoxConstraints(maxWidth: 0.80 * screenWidth),
              child: Title(
                username: data['nickname'],
                title: data['desc'],
                music: data['music'],
              ),
            )),
        Positioned(
            right: 0,
            width: screenWidth * 0.15,
            height: 0.5 * screenHeight,
            bottom: 5,
            child: Container(
              decoration: BoxDecoration(),
              child: getButtonList(
                  context,
                  data['avatar_larger'],
                  data['comment_count'],
                  data['digg_count'],
                  data['share_count'],
                  data['music_image'],
                  screenHeight,
                  screenWidth,
                  provider.subInfo,
                  provider.currentSubuid,
                  provider.videoPlayersub,
                  provider.isplayingsub,
                  false),
            )),
      ],
    );
  }
}

class Subcontent1 extends StatelessWidget {
  const Subcontent1({Key key, this.data, this.index}) : super(key: key);
  final int index;
  final Map data;
  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        VideoPlayerSub(
          url: data['download_addr'],
          uid: data['uid'],
          provider: provider,
          index: index,
        ),
        Positioned(
            bottom: 5,
            // width: 0.80 * screenWigth,
            // height: 100,

            child: Container(
              decoration: BoxDecoration(),
              constraints: BoxConstraints(maxWidth: 0.80 * screenWidth),
              child: Title(
                username: data['nickname'],
                title: data['desc'],
                music: data['music'],
              ),
            )),
        Positioned(
            right: 0,
            width: screenWidth * 0.15,
            height: 0.5 * screenHeight,
            bottom: 5,
            child: Container(
              decoration: BoxDecoration(),
              child: getButtonList(
                  context,
                  data['avatar_larger'],
                  data['comment_count'],
                  data['digg_count'],
                  data['share_count'],
                  data['music_image'],
                  screenHeight,
                  screenWidth,
                  provider.subInfo,
                  provider.currentSubuid,
                  provider.videoPlayersub,
                  provider.isplayingsub,
                  false),
            )),
      ],
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

class VideoPlayerSub extends StatefulWidget {
  VideoPlayerSub(
      {Key key, @required this.url, this.provider, this.uid, this.index})
      : super(key: key);
  int index;
  String url;
  String uid;
  RecommendProvider provider;
  @override
  _VideoPlayerSubState createState() =>
      _VideoPlayerSubState(this.url, this.provider, this.uid, this.index);
}

class _VideoPlayerSubState extends State<VideoPlayerSub> {
  _VideoPlayerSubState(this.url, this.provider, this.uid, this.index);
  String url;
  String uid;
  int index;
  RecommendProvider provider;
  VideoPlayerController videoPlayersub;
  //控制更新视频加载初始化完成状态更新
  Future videoPalyFuture;
  double asp;

  @override
  void initState() {
    super.initState();

    provider.intiIsplayingSub();
    videoPlayersub = VideoPlayerController.network(url);
    provider.setvideoPlayersub(videoPlayersub);
    videoPlayersub.setLooping(true);

    videoPalyFuture = videoPlayersub.initialize().then((_) {
      videoPlayersub.play();
      asp = videoPlayersub.value.aspectRatio;

      if (widget.index == 0) {
        provider.setSubUid(this.uid);
      }

      var uid = provider.currentSubuid;
      print('uid是这个：$uid');
      setState(() {});

      getUserInfo(uid);
    });
  }

  getUserInfo(String uid) async {
    Response re = await Dio()
        .get('http://101.200.141.108:8080/douyin/getUserInfo?uid=$uid');
    // key++;
    if (mounted) {
      setState(() {
        // userInfo.addAll(re.data);
        widget.provider.setSubInfo(re.data);
      });
    }
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
    print("psize：$as1");

    return FutureBuilder(
      future: videoPalyFuture,
      builder: (BuildContext context, value) {
        if (value.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              if (videoPlayersub.value.isInitialized) {
                if (videoPlayersub.value.isPlaying) {
                  videoPlayersub.pause();
                  provider.setIsplayingsub();
                } else {
                  videoPlayersub.play();
                  provider.setIsplayingsub();
                }
                setState(() {});
              } else {}
            },
            child: Center(
              child: AspectRatio(
                aspectRatio: resize(asp, as1),
                child: VideoPlayer(
                  videoPlayersub,
                ),
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  videobutton() {
    Widget item = Container();
    if (videoPlayersub.value.isInitialized && !videoPlayersub.value.isPlaying) {
      item = GestureDetector(
        onTap: () {
          videoPlayersub.play();
          provider.setIsplayingsub();
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
        offstage: provider.isplayingsub,
      ),
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
    videoPlayersub.dispose();

    // 目前是全局只有一个videoplayer所以不用每一个视频结束后dispose  这个只有一个要销毁 现在不能销毁 只有一个
    // provider.videoPlayersub.dispose();
  }
}
