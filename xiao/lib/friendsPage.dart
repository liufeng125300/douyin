import 'package:dio/dio.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:provider/provider.dart';
import 'package:xiao/RecommendProvider.dart';
import 'package:xiao/circileDetail.dart';
import 'package:xiao/homePage.dart';
import 'package:xiao/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FriendPage extends StatefulWidget {
  FriendPage({Key key, this.provider}) : super(key: key);
  RecommendProvider provider;
  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController tabController;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    print('我是friend初始化');
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void deactivate() {
    print('de');
    bool isBack = ModalRoute.of(context).isCurrent;
    if (isBack) {
      // 限于从其他页面返回到当前页面时执行，首次进入当前页面不执行
      // 注：此方法在iOS手势返回时，不执行此处
      print('从其他页面返回到${widget.runtimeType}页');
    } else {
      // 离开当前页面或退出当前页面时执行
      print('离开或退出${widget.runtimeType}页');
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    double screenwidth = MediaQuery.of(context).size.width;

    super.build(context);
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
          // backgroundColor: Theme.of(context).primaryColor,
          bottomOpacity: 0,
          elevation: 0.5,
          title: title(controller: tabController),
        ),
        body: ExtendedTabBarView(
          controller: tabController,
          children: [subPage(), discoverPage(), cityPage()],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    print('我是frienddispos');
  }
}

class discoverPage extends StatefulWidget {
  discoverPage({Key key}) : super(key: key);

  @override
  _discoverPageState createState() => _discoverPageState();
}

class _discoverPageState extends State<discoverPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
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

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 50) {
        print('加载更多$key');
        getData();
      }
    });
    getData();
  }

  getData() async {
    Response re =
        await Dio().get('http://101.200.141.108:8080/douyin/test?key=$key');
    key++;
    setState(() {
      // print(re.data);
      xiaoData.addAll(re.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return StaggeredGridView.countBuilder(
      physics: ClampingScrollPhysics(),
      controller: controller,
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: xiaoData.length,
      itemBuilder: (context, index) {
        return Item(
          data: xiaoData[index],
          index: index,
          category: widget.category,
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: screenwidth * 0.01,
      crossAxisSpacing: screenwidth * 0.01,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Item extends StatelessWidget {
  const Item({Key key, this.data, this.index, this.category}) : super(key: key);
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
                      child: Image(
                        image: NetworkImage(data['cover']),
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
