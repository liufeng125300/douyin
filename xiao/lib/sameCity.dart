import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:xiao/RecommendProvider.dart';
import 'package:xiao/video.dart';
import 'package:xiao/samecityvideo.dart';

import 'homePage.dart';

class SameCity extends StatefulWidget {
  SameCity({Key key}) : super(key: key);

  @override
  _SameCityState createState() => _SameCityState();
}

class _SameCityState extends State<SameCity>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          width: width,
          // color: Colors.yellow,
          padding: EdgeInsets.only(top: 70),
          child: Maincotent(),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Maincotent extends StatefulWidget {
  Maincotent({Key key}) : super(key: key);

  @override
  _MaincotentState createState() => _MaincotentState();
}

List xiaoData = [];
int key = 1;

ScrollController controller;

class _MaincotentState extends State<Maincotent> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print('加载更多$key');
        getData();
      }
    });
  }

  getData() async {
    Response re =
        await Dio().get('http://101.200.141.108:8080/douyin/getdata?key=$key');
    key++;
    if (mounted) {
      setState(() {
        // print(re.data);
        xiaoData.addAll(re.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWith = MediaQuery.of(context).size.width;
    return StaggeredGridView.countBuilder(
      controller: controller,
      physics: ClampingScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: xiaoData.length,
      itemBuilder: (context, index) {
        return item(
          data: xiaoData[index],
          index: index,
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
    );
  }
}

class item extends StatelessWidget {
  const item({Key key, this.data, this.index}) : super(key: key);
  final Map data;
  final int index;
  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    // print(data['cover']);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return videoSM(
              videodata: data,
              provider: provider,
              index: index,
              isprofile: false,
            );
          },
        ));
      },
      child: Hero(
        child: Image(
          image: NetworkImage(data['cover']),
          fit: BoxFit.fitWidth,
        ),
        tag: index.toString() + 'false',
      ),
    );
  }
}
