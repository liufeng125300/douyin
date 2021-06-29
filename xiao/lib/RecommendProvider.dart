import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RecommendProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {
  bool ifShowBottom = true;
  double screenHeight;
  TabController controller;
  double screenWidth;
  TabController ct;
  String currentUid;
  ScrollController controllerMin;
  PageController pageController;
  int currentHomePageindex = 2;
  TabController HomePageController;

  String VideoWidgetUid;
  Map VideoWidgetUserInfo;

  String currentSubuid;

  int currentPageIndex;
  Map userInfo;
  Map subInfo;
  int currentPage;
  bool isplaying = true;
  VideoPlayerController videoPlayer;
  VideoPlayerController videoPlayeruser;
  VideoPlayerController videoPlayersub;
  VideoPlayerController videoPlayervideos;
  VideoPlayerController videoPlayerSC;
  bool isplayingsub = true;
  bool isplayingVideoSC = true;
  String CurrentTypeUid;
  int test = 0;
  bool isplayingVideros = true;
  TabController controllerTab;
  Map currentUserInfo;

  TabController tabs;

  String userId = '58991889272';
  Map meInfo;
  int currentBottomPageIndex = 0;
  setTest() {
    test++;
    notifyListeners();
  }

  setcurrentBottomPageIndex(data) {
    currentBottomPageIndex = data;
    notifyListeners();
  }
  // videoplayerWidgetDispose() {
  //   videoPlayWidget.dispose();
  // }

  setVideoPalyerVideos(data) {
    videoPlayervideos = data;
    notifyListeners();
  }

  setmeInfo(data) {
    meInfo = data;
    notifyListeners();
  }

  setIsplayingVideos() {
    isplayingVideros = !isplayingVideros;
    notifyListeners();
  }

  initIsplayingVideos() {
    isplayingVideros = true;
    notifyListeners();
  }

  initisplayingVideoWidget() {
    isplayingVideoSC = true;
    notifyListeners();
  }

  setCurrentUserInfo(data) {
    currentUserInfo = data;
    notifyListeners();
  }

  setCurrentTypeUid(data) {
    CurrentTypeUid = data;
    notifyListeners();
  }

  setSubInfo(data) {
    subInfo = data;
    notifyListeners();
  }

  setvideoPlayersub(data) {
    videoPlayersub = data;
    notifyListeners();
  }

  setvideocontrol(data) {
    videoPlayer = data;
    notifyListeners();
  }

  setVideroWidgetPlayder(data) {
    videoPlayerSC = data;
    notifyListeners();
  }

  initIsplaying() {
    isplaying = true;
    notifyListeners();
  }

  intiIsplayingSub() {
    isplayingsub = true;
    notifyListeners();
  }

  // setTabcontroller(ctrl) {
  //   controller = ctrl;
  //   // notifyListeners();
  // }
  // ignore: deprecated_member_use
  // List<MainInfo> infos = List<MainInfo>();
  // List<MainInfo> followed = List<MainInfo>();
  // TabController controller;

  sethomepageindex(int index) {
    currentHomePageindex = index;
    notifyListeners();
  }

  setIsplaying() {
    isplaying = !isplaying;
    notifyListeners();
  }

  setIsplayingvideowidget() {
    isplayingVideoSC = !isplayingVideoSC;
    notifyListeners();
  }

  setIsplayingsub() {
    isplayingsub = !isplayingsub;
    notifyListeners();
  }

  setScreenHeight(height) {
    screenHeight = height;
    notifyListeners();
  }

  setUid(uid) {
    currentUid = uid;
    notifyListeners();
  }

  setSubUid(uid) {
    currentSubuid = uid;
    notifyListeners();
  }

  setuserInfo(data) {
    userInfo = data;
    notifyListeners();
  }

  RecommendProvider() {
    isplaying = true;
    controller = TabController(length: 3, vsync: this, initialIndex: 2);
    ct = TabController(length: 2, vsync: this, initialIndex: 0);
    controllerMin = ScrollController();
    pageController = PageController();
    currentPage = 0;
    tabs = TabController(length: 10, vsync: this, initialIndex: 0);
    HomePageController = TabController(length: 2, vsync: this, initialIndex: 0);
    controllerTab = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  MainInfo maininfo = MainInfo(
      avatarUrl:
          'https://img.xiaohongshu.com/avatar/5fd1f2c386dda400016f9590.jpg@80w_80h_90q_1e_1c_1x.jpg',
      content: '正好',
      desc: "小视频",
      favCount: 990,
      ifFaved: true,
      shareCount: 500,
      userName: '小可爱',
      videoPath:
          'https://img.xiaohongshu.com/avatar/5fd1f2c386dda400016f9590.jpg@80w_80h_90q_1e_1c_1x.jpg');
  // ignore: deprecated_member_use
  Reply reply = Reply(
      // ignore: deprecated_member_use
      afterReplies: List.filled(1, null),
      ifFaved: true,
      replyContent: "哈哈",
      replyMakerAvatar:
          'https://img.xiaohongshu.com/avatar/5c5c4bbad9e25f0001908c62.jpg@80w_80h_90q_1e_1c_1x.jpg',
      replyMakerName: '糖糖',
      whenReplied: '3小时前');

  tapFav() {
    maininfo.ifFaved = !maininfo.ifFaved;
    if (maininfo.ifFaved) {
      maininfo.favCount += 1;
    } else {
      maininfo.favCount -= 1;
    }
    notifyListeners();
  }

  hideBottomBar() {
    ifShowBottom = false;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MainInfo {
  String avatarUrl;
  String userName;
  String content;
  String videoPath;
  int favCount;
  int shareCount;
  String desc;
  bool ifFaved;
  MainInfo(
      {this.avatarUrl,
      this.content,
      this.desc,
      this.favCount,
      this.ifFaved,
      this.shareCount,
      this.userName,
      this.videoPath});
}

class Reply {
  String replyMakerName;
  String replyMakerAvatar;
  String replyContent;
  String whenReplied;
  bool ifFaved;
  List afterReplies;
  Reply(
      {this.afterReplies,
      this.ifFaved,
      this.replyContent,
      this.replyMakerAvatar,
      this.replyMakerName,
      this.whenReplied});
}
