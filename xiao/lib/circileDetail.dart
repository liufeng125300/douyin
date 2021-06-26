import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xiao/main.dart';
import 'package:xiao/sameCity.dart';

class Circle extends StatelessWidget {
  const Circle({Key key, this.data, this.category, @required this.item})
      : super(key: key);
  final int data;
  final String category;
  final Map item;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: Center(
              child: title(
                userPic: item['userPic'],
                userName: item['userName'],
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
          )),
      body: Container(
        child: MainContent(
          data: data,
          category: category,
          item: item,
        ),
      ),
      bottomNavigationBar: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Divider(
              height: 1,
              color: Colors.black12,
            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              // color: Colors.yellow,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),

                      // margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15)),
                      width: 0.4 * screenWidth,
                      height: 30,
                      child: TextField(
                        // maxLength: 50,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                        decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            border: InputBorder.none,
                            hintText: '说点什么...',
                            hintStyle: TextStyle(color: Colors.grey[600])),
                      )),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border),
                      Text(
                        '1836',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_border),
                      Text(
                        '1788',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(IconData(0xe642, fontFamily: 'iconfont')),
                      Text(
                        '98',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  MainContent({Key key, this.data, this.category, this.item}) : super(key: key);
  final int data;
  final String category;
  final Map item;
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return TopSwiper(
            data: data,
            category: category,
            item: item,
          );
        } else {
          return Article(
            item: item,
          );
        }
      },
    );
  }
}

class Article extends StatelessWidget {
  const Article({Key key, this.data, this.item}) : super(key: key);
  final String data;
  final Map item;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item['title'],
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Container(
            child: Text(
              item['circleDetail'],
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
                height: 1.8,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              height: 30,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                icon: Icon(
                  Icons.all_inclusive,
                  color: Colors.blue,
                  size: 12,
                ),
                label: Text(
                  '成都周边游',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
                disabledColor: Colors.blue[50],
              )),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['publish_date'],
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                Container(
                  height: 24,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 0.2)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 15,
                      ),
                      Text(
                        ' 不喜欢',
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 0.2,
            decoration: BoxDecoration(color: Colors.grey),
            margin: EdgeInsets.symmetric(vertical: 8),
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}

class TopSwiper extends StatelessWidget {
  TopSwiper({Key key, this.data, this.category, this.item}) : super(key: key);
  final int data;
  final String category;
  final SwiperController controller = SwiperController();
  final Map item;

  @override
  Widget build(BuildContext context) {
    List imageSrc;
    print(item['images']);
    if (item['images'] != '[]') {
      imageSrc = item['images']
          .replaceFirst('[', '')
          .replaceFirst(']', '')
          .replaceAll('\'', '')
          .replaceAll(' ', '')
          .split(',');
      return (Container(
        height: 400,
        child: Swiper(
          pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                color: Colors.grey[600],
                activeColor: Colors.redAccent,
                size: 5,
                activeSize: 5),
          ),

          // physics: NeverScrollableScrollPhysics(),
          itemCount: imageSrc.length,
          itemBuilder: (BuildContext context, int index) {
            return Hero(
                tag: data.toString() + category,
                child: Image(
                    image: NetworkImage(imageSrc[index]),
                    fit: BoxFit.fitWidth));
          },
        ),
      ));
    } else {
      return Container();
    }
  }
}

class title extends StatefulWidget {
  const title({Key key, this.userPic, this.userName}) : super(key: key);
  final String userPic;
  final String userName;
  @override
  _titleState createState() => _titleState();
}

class _titleState extends State<title> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      // decoration: BoxDecoration(color: Colors.green),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                width: 25,
                height: 25,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.userPic),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                // height: 25,
                child: Text(
                  widget.userName,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent, width: 0.5),
                      borderRadius: BorderRadius.circular(8.5)),
                  width: 40,
                  height: 17,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        print('我关注你了');
                      },
                      child: Text(
                        '关注',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 20,
                child: Icon(
                  Icons.launch,
                  color: Colors.black,
                  size: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
