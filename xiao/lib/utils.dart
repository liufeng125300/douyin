import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
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
import 'package:xiao/sameCity.dart';
import 'package:xiao/sub.dart';

import 'flutter_nest_page_view.dart';
import 'homePage.dart';
import 'mePage.dart';
import 'video.dart';
import 'package:xiao/profiles.dart';

getButtonList(
    context,
    String pic,
    int feedcount,
    int favcount,
    int share_count,
    String music_image,
    double screenHeight,
    double screenWidth,
    Map userInfo,
    String currentUid,
    VideoPlayerController videoplayer,
    bool isplaying,
    bool isprofile) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
          width: 50,
          height: 59,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  print(isplaying);
                  if (isprofile) {
                    Navigator.pop(context);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileS(
                        userInfo: userInfo,
                        currentUid: currentUid,
                        videoplayer: videoplayer,
                        isplaying: isplaying,
                      );
                    }));
                  }
                },
                child: Container(
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(pic),
                    )),
              ),
              Positioned(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(25)),
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                bottom: 0,
                left: 15,
              )
            ],
          )),
      IconText(
          icon: Icon(
            Icons.favorite,
            size: 40,
            color: Colors.white,
          ),
          text: setData(favcount)),
      GestureDetector(
        child: IconText(
            icon: Icon(
              IconData(0xe642, fontFamily: 'iconfont'),
              size: 40,
              color: Colors.white,
            ),
            text: setData(feedcount)),
        onTap: () {
          showBottom(context, screenHeight, feedcount, screenWidth);
        },
      ),
      IconText(
          icon: Icon(
            IconData(0xe72f, fontFamily: 'iconfont'),
            size: 40,
            color: Colors.white,
          ),
          text: setData(share_count)),
      RoateMusic(music_image: music_image)
    ],
  );
}
