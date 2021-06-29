import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:m_loading/m_loading.dart';

import 'package:provider/provider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:xiao/RecommendProvider.dart';

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
List newdata = [];

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
        newdata = re.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('samecity00000000000000000000000');
    double screenWith = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    if (xiaoData.isEmpty) {
      return Container(
        height: screenHeight / 2,
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
        ),
      );
    }
    return WaterfallFlow.builder(
      controller: controller,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: xiaoData.length + 1,
      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        lastChildLayoutTypeBuilder: (index) => index == xiaoData.length
            ? LastChildLayoutType.foot
            : LastChildLayoutType.none,
      ),
      itemBuilder: (context, index) {
        if (index == xiaoData.length) {
          return _loading();
        }
        return item(
          data: xiaoData[index],
          index: index,
        );
      },
    );
    // return StaggeredGridView.countBuilder(
    //   controller: controller,
    //   addAutomaticKeepAlives: true,
    //   physics: ClampingScrollPhysics(),
    //   primary: false,
    //   shrinkWrap: true,
    //   crossAxisCount: 4,
    //   itemCount: xiaoData.length,
    //   itemBuilder: (context, index) {
    //     return item(
    //       data: xiaoData[index],
    //       index: index,
    //     );
    //   },
    //   staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
    //   mainAxisSpacing: 1,
    //   crossAxisSpacing: 1,
    // );
  }

  Widget _loading() {
    if (xiaoData.isNotEmpty) {
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
}

class item extends StatelessWidget {
  const item({Key key, this.data, this.index}) : super(key: key);
  final Map data;
  final int index;
  @override
  Widget build(BuildContext context) {
    print('888888888');
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
