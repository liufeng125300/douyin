import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 10),
            child: Text('创建群聊', style: TextStyle(fontSize: 12)),
          )
        ],
        title: Text(
          '消息',
          style: TextStyle(fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: screenWidth - 20,
                height: 35,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[400].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3)),
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: '搜索',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Colors.grey[850]))),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                primary: true,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://p3.douyinpic.com/img/tos-cn-avt-0015/55b4d8a4ddd3b06bb49048ca74afee7a~c5_1080x1080.jpeg?from=116350172',
                              ),
                            ),
                          ),
                          Text(
                            '张思思',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://p3.douyinpic.com/img/tos-cn-avt-0015/55b4d8a4ddd3b06bb49048ca74afee7a~c5_1080x1080.jpeg?from=116350172',
                              ),
                            ),
                          ),
                          Text(
                            '张思思',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://p3.douyinpic.com/img/tos-cn-avt-0015/55b4d8a4ddd3b06bb49048ca74afee7a~c5_1080x1080.jpeg?from=116350172',
                              ),
                            ),
                          ),
                          Text(
                            '张思思',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://p3.douyinpic.com/img/tos-cn-avt-0015/55b4d8a4ddd3b06bb49048ca74afee7a~c5_1080x1080.jpeg?from=116350172',
                              ),
                            ),
                          ),
                          Text(
                            '张思思',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://p3.douyinpic.com/img/tos-cn-avt-0015/55b4d8a4ddd3b06bb49048ca74afee7a~c5_1080x1080.jpeg?from=116350172',
                              ),
                            ),
                          ),
                          Text(
                            '张思思',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://p3.douyinpic.com/img/tos-cn-avt-0015/55b4d8a4ddd3b06bb49048ca74afee7a~c5_1080x1080.jpeg?from=116350172',
                              ),
                            ),
                          ),
                          Text(
                            '张思思',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: messageList(),
          )
        ],
      ),
    );
  }
}

class messageList extends StatefulWidget {
  const messageList({Key key}) : super(key: key);

  @override
  _messageListState createState() => _messageListState();
}

class _messageListState extends State<messageList> {
  @override
  Widget build(BuildContext context) {
    List m = ['1', '2', '3', '4', '5', '1', '2', '3', '4', '5'];
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: m.length,
      // itemExtent: 60,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: [
              ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ftupian.enterdesk.com%2F2012%2F0913%2F1%2Fenterdesk%2520%285%29.JPG&refer=http%3A%2F%2Ftupian.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1627284638&t=92dad846041618fbd154c22d51bc147e'),
                  ),
                  title: Text(
                    '小米',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  subtitle: Text('10分钟内在线',
                      style: TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 13,
                  )),
              Divider(
                height: 1,
                color: Colors.grey[850].withOpacity(0.5),
              )
            ],
          ),
        );
      },
    );
  }
}
