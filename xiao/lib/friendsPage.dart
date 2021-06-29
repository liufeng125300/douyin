import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:m_loading/m_loading.dart';
import 'package:provider/provider.dart';
import 'package:xiao/RecommendProvider.dart';
import 'package:xiao/circileDetail.dart';
import 'package:xiao/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('pppppppppppppppppp');
    return NotePage1();
  }
}

class NotePage1 extends StatefulWidget {
  NotePage1({Key key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

//singticker 和autokeepalive会重复
class _NotePageState extends State<NotePage1> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    print('我是notepage');
    return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.adjust,
            color: Colors.black,
            size: 18,
          ),
          actions: [
            Icon(
              Icons.search,
              color: Colors.black,
              size: 18,
            ),
            SizedBox(
              width: 20,
            )
          ],
          primary: true,
          backgroundColor: Colors.white,
          toolbarHeight: 35,
          centerTitle: true,
          bottomOpacity: 0,
          elevation: 0.5,
          title: title(controller: provider.controllerTab),
        ),
        body: ExtendedTabBarView(
          controller: provider.controllerTab,
          children: [Text('data'), DiscoverPage(), Text('data')],
        ));
  }
}

//expandtab 有 bug singtick 要用provider 提供的 singtick

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    print('dicover');

    double screenwidth = MediaQuery.of(context).size.width;
    return Column(
      // mainAxisSize: MainAxisSize.max,
      children: [
        Theme(
          data: ThemeData(
            splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
            highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
          ),
          child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 0,
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ExtendedTabBar(
                controller: provider.tabs,
                isScrollable: true,
                tabs: [
                  Text('推荐'),
                  Text('音乐'),
                  Text('直播'),
                  Text('家居家装'),
                  Text('旅行'),
                  Text('科技数码'),
                  Text('Vlog'),
                  Text('搞笑'),
                  Text('美食'),
                  Text('情感')
                ],
                indicator: BoxDecoration(),
                labelColor: Colors.green[300],
                unselectedLabelColor: Colors.black45,
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                ),
                labelStyle:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              )),
        ),
        Expanded(
            child: Container(

                // decoration: BoxDecoration(color: Colors.black),
                padding: EdgeInsets.only(
                  left: screenwidth * 0.01,
                  right: screenwidth * 0.01,
                ),
                child: ExtendedTabBarView(controller: provider.tabs, children: [
                  MainItem(
                    category: 'recommend',
                  ),
                  MainItem(
                    category: 'music',
                  ),
                  MainItem(
                    category: 'live',
                  ),
                  MainItem(
                    category: 'residence',
                  ),
                  MainItem(
                    category: 'journey',
                  ),
                  MainItem(
                    category: 'science',
                  ),
                  MainItem(
                    category: 'Vlog',
                  ),
                  MainItem(
                    category: 'funny',
                  ),
                  MainItem(
                    category: 'food',
                  ),
                  MainItem(
                    category: 'feeling',
                  )
                ])))
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class cityPage extends StatefulWidget {
  cityPage({Key key}) : super(key: key);

  @override
  _cityPageState createState() => _cityPageState();
}

class _cityPageState extends State<cityPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('成都'),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class subPage extends StatefulWidget {
  subPage({Key key}) : super(key: key);

  @override
  _subPageState createState() => _subPageState();
}

class _subPageState extends State<subPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('关注'),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class title extends StatelessWidget {
  const title({Key key, this.controller}) : super(key: key);
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
        width: 0.5 * screenwidth,
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
            highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
          ),
          child: ExtendedTabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.redAccent,
            controller: controller,
            labelColor: Colors.black,
            tabs: [Text('关注'), Text('发现'), Text('成都')],
            labelStyle: TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 13),
            unselectedLabelColor: Colors.black45,
          ),
        ));
  }
}

class MainItem extends StatefulWidget {
  MainItem({Key key, this.category}) : super(key: key);
  final String category;
  @override
  _MainItemState createState() => _MainItemState();
}

class _MainItemState extends State<MainItem>
    with AutomaticKeepAliveClientMixin {
  List xiaoData = [];
  int key = 1;
  ScrollController controller = ScrollController();
  List newdata = [];

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
        await Dio().get('http://101.200.141.108:8080/douyin/test?key=$key');
    print('k是$key');
    key++;
    setState(() {
      // print(re.data);
      xiaoData.addAll(re.data);
      newdata = re.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('000000000000');
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (xiaoData.isEmpty) {
      return Container(
        height: screenheight / 2,
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
        crossAxisSpacing: screenwidth * 0.01,
        mainAxisSpacing: screenwidth * 0.01,
        lastChildLayoutTypeBuilder: (index) => index == xiaoData.length
            ? LastChildLayoutType.fullCrossAxisExtent
            : LastChildLayoutType.none,
      ),
      itemBuilder: (context, index) {
        if (index == xiaoData.length) {
          return _loading();
        }
        return Item(
          data: xiaoData[index],
          index: index,
          category: widget.category,
        );
      },
    );

    // // SliverGrid(
    // //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    // //         crossAxisCount: 2,
    // //         mainAxisSpacing: 1.5,
    // //         crossAxisSpacing: 1.5,
    // //         childAspectRatio: 0.4),
    // //     delegate:
    // //         SliverChildBuilderDelegate((BuildContext context, int index) {
    // //       return Item(
    // //         data: xiaoData[index],
    // //         index: index,
    // //         category: widget.category,
    // //       );
    // //     })),
    // //   SliverToBoxAdapter(
    // //     child: StaggeredGridView.countBuilder(
    // //       // physics: ClampingScrollPhysics(),
    // //       // controller: controller,
    // //       primary: false,
    // //       shrinkWrap: true,
    // //       crossAxisCount: 4,
    // //       itemCount: xiaoData.length,
    // //       itemBuilder: (context, index) {
    // //         return Item(
    // //           data: xiaoData[index],
    // //           index: index,
    // //           category: widget.category,
    // //         );
    // //       },
    // //       staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
    // //       mainAxisSpacing: screenwidth * 0.01,
    // //       crossAxisSpacing: screenwidth * 0.01,
    // //     ),
    // //   )

    // if (xiaoData.isEmpty) {
    //   return Container(
    //     height: screenheight / 2,
    //     alignment: Alignment.center,
    //     child: Container(
    //       width: 50,
    //       child: BallPulseLoading(
    //         ballStyle: BallStyle(
    //           size: 8,
    //           color: Colors.cyan,
    //           ballType: BallType.solid,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // return SingleChildScrollView(
    //   controller: controller,
    //   physics: ClampingScrollPhysics(),
    //   child: Column(
    //     children: [
    //       WaterfallFlow.builder(
    //         physics: NeverScrollableScrollPhysics(),
    //         shrinkWrap: true,
    //         itemCount: xiaoData.length,
    //         gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2,
    //           crossAxisSpacing: screenwidth * 0.01,
    //           mainAxisSpacing: screenwidth * 0.01,
    //         ),
    //         itemBuilder: (context, index) {
    //           return Item(
    //             data: xiaoData[index],
    //             index: index,
    //             category: widget.category,
    //           );
    //         },
    //       ),
    //       _loading()
    //     ],
    //   ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Item extends StatefulWidget {
  Item({Key key, this.category, this.data, this.index}) : super(key: key);
  final Map data;
  final int index;
  final String category;
  @override
  _ItemState createState() => _ItemState(this.category, this.data, this.index);
}

class _ItemState extends State<Item> {
  final Map data;
  final int index;
  final String category;

  _ItemState(this.category, this.data, this.index);
  @override
  Widget build(BuildContext context) {
    print(11111111111111111);
    double screenWith = MediaQuery.of(context).size.width;

    return Container(
        // height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return Circle(
                      data: index,
                      category: category,
                      item: data,
                    );
                  },
                ),
              );
            },
            //当hero组件中有max时会出现一处  hero源于目标必须一样，否则会溢出，比如同为图片
            //出现重复是因为有页面是keepalive的，hero对象一直存在，改为不同即可，个人页面是变化的，所以hero的tag不重复

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Hero(
                      child: CachedNetworkImage(
                        imageUrl: data['cover'],
                        fit: BoxFit.fitWidth,
                      ),
                      tag: index.toString() + category,
                    )),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(),
                    child: Text(
                      data['title'],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  // padding: EdgeInsets.symmetric(horizontal: 5),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(data['userPic']),
                            ),
                          ),
                          Container(
                            width: 70,
                            child: Text(
                              data['userName'],
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 20,
                            color: Colors.redAccent,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              setData(data['sub']),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}

class Item1 extends StatelessWidget {
  const Item1({Key key, this.data, this.index, this.category})
      : super(key: key);
  final Map data;
  final int index;
  final String category;

  @override
  Widget build(BuildContext context) {
    print('123456789');
    // print("data是$data");
    double screenWith = MediaQuery.of(context).size.width;

    return Container(
        // height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return Circle(
                      data: index,
                      category: category,
                      item: data,
                    );
                  },
                ),
              );
            },
            //当hero组件中有max时会出现一处  hero源于目标必须一样，否则会溢出，比如同为图片
            //出现重复是因为有页面是keepalive的，hero对象一直存在，改为不同即可，个人页面是变化的，所以hero的tag不重复

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Hero(
                      child: CachedNetworkImage(
                        imageUrl: data['cover'],
                        fit: BoxFit.fitWidth,
                      ),
                      tag: index.toString() + category,
                    )),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(),
                    child: Text(
                      data['title'],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    // padding: EdgeInsets.symmetric(horizontal: 5),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['userPic']),
                                ),
                              ),
                              Container(
                                width: 70,
                                child: Text(
                                  data['userName'],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 20,
                                color: Colors.redAccent,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Text(
                                  setData(data['sub']),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            )));
  }
}

String setData(count) {
  String data;

  if (count >= 10000) {
    print(count);
    double result = count / 10000;
    data = result.toStringAsFixed(1) + 'w';
  } else {
    data = count.toString();
  }

  return data;
}
