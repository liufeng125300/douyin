import 'package:xiao/RecommendProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReplyFullList extends StatelessWidget {
  const ReplyFullList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    Reply reply = provider.reply;
    List<Reply> replies = [];
    replies.add(reply);
    replies.add(reply);
    return Container(
      child: Column(
        children: [
          Container(
            height: 80 * rpx,
            child: ListTile(
              leading: Container(
                width: 10 * rpx,
              ),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {},
              ),
              title: Center(child: Text('10条评论')),
            ),
          ),
          genReplyList(replies)
        ],
      ),
    );
  }
}

class ReplyList extends StatelessWidget {
  const ReplyList({Key key, this.reply}) : super(key: key);
  final Reply reply;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    List<Reply> replies = [];
    replies.add(reply);
    replies.add(reply);

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100 * rpx,
                child: CircleAvatar(
                  backgroundImage: NetworkImage("${reply.replyMakerAvatar}"),
                ),
              ),
              Container(
                width: 550 * rpx,
                child: ListTile(
                  title: Text("${reply.replyMakerName}"),
                  subtitle: Text(
                    "${reply.replyContent}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                width: 100 * rpx,
                child: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.grey[300]),
                  onPressed: () {},
                ),
              )
            ],
          ),
          genAfterReply(replies)
        ],
      ),
    );
  }
}

class AfterReply extends StatelessWidget {
  const AfterReply({Key key, this.afterReply}) : super(key: key);
  final Reply afterReply;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100 * rpx,
              ),
              Container(
                width: 550 * rpx,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage('${afterReply.replyMakerAvatar}'),
                      ),
                    ),
                    Container(
                      width: 480,
                      child: ListTile(
                        title: Text('${afterReply.replyMakerName}'),
                        subtitle: Text(
                          "${afterReply.replyContent}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 100 * rpx,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.grey[300],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

genReplyList(List<Reply> replies) {
  return ListView.builder(
    itemCount: replies.length,
    itemBuilder: (context, index) {
      return ReplyList(reply: replies[index]);
    },
  );
}

genAfterReply(List<Reply> replies) {
  return ListView.builder(
    itemCount: replies.length <= 2 ? replies.length : 2,
    itemBuilder: (context, index) {
      return AfterReply(afterReply: replies[index]);
    },
  );
}
