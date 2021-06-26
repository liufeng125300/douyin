import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:xiao/RecommendProvider.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key, this.provider}) : super(key: key);
  RecommendProvider provider;
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  void initState() {
    super.initState();
    if (widget.provider.currentBottomPageIndex == 0) {
      if (widget.provider.currentHomePageindex == 1) {
        widget.provider.videoPlayersub.pause();
      } else if (widget.provider.currentHomePageindex == 2) {
        widget.provider.videoPlayer.pause();
      }
    }
  }

  @override
  void dispose() {
    if (widget.provider.currentBottomPageIndex == 0) {
      if (widget.provider.currentHomePageindex == 1 &&
          widget.provider.isplayingsub) {
        widget.provider.videoPlayersub.play();
      } else if (widget.provider.currentHomePageindex == 2 &&
          widget.provider.isplaying) {
        widget.provider.videoPlayer.play();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          child: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            child: Image(
              image: AssetImage('images/3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              top: 50,
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // width: 0.3 * screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(11)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconData(0xe64f, fontFamily: 'iconfont'),
                            color: Colors.white,
                            size: 15,
                          ),
                          Text(
                            '  选择音乐',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 0.10 * screenWidth,
                    )
                  ],
                ),
              )),
          Positioned(
              right: 0,
              top: 50,
              child: Container(
                padding: EdgeInsets.only(right: 20),
                height: 0.35 * screenHeight,
                // width: 0.2 * screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconData(0xe614, fontFamily: 'iconfont'),
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          '翻转',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconData(0xe669, fontFamily: 'iconfont'),
                          color: Colors.white,
                          size: 25,
                        ),
                        Text(
                          '慢速度',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconData(0xe625, fontFamily: 'iconfont'),
                          color: Colors.white,
                          size: 25,
                        ),
                        Text(
                          '滤镜',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconData(0xe6db, fontFamily: 'iconfont'),
                          color: Colors.white,
                          size: 25,
                        ),
                        Text(
                          '美化',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconData(0xe621, fontFamily: 'iconfont'),
                          color: Colors.white,
                          size: 25,
                        ),
                        Text(
                          '倒计时',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        )
                      ],
                    )
                  ],
                ),
              )),
          Positioned(
              bottom: 40,
              child: Container(
                height: 0.18 * screenHeight,
                width: screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 0.4 * screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 35,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '照片',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 35,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '视频',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 35,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '文字',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Image(
                                    image: AssetImage('images/1.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    // color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(3)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '道具',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 8),
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              width: 53,
                              height: 53,
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(26.5)),
                              child: Icon(
                                IconData(0xe631, fontFamily: 'iconfont'),
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Image(
                                    image: AssetImage('images/2.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(3)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '相册',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 8),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
            bottom: 0,
            width: screenWidth,
            child: Center(
                child: Container(
              height: 40,
              width: screenWidth * 0.5,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '分段拍',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '快拍',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    '模板',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '开直播',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  )
                ],
              ),
            )),
          )
        ],
      )),
    );
  }
}
