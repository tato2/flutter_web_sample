import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// 無限スクロールページ
///
class InfiniteScrollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('無限スクロールページ'),
      ),
      body: Container(
        child: Form(),
      ),
    );
  }
}

class Form extends StatefulWidget {
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<Form> {
  List<int> listItem = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  bool waiting = false;

  Future asyncAddList() async {
    // 1秒まつ
    await Future.delayed(Duration(seconds: 1));

    // リストを追加
    var clone = [...listItem];
    for (var i = 0; i < 5; i++) {
      clone.add(clone.reduce(max) + 1);
    }
    setState(() {
      listItem = clone;
    });

    waiting = false;
  }

  bool _onScroll(notification) {
    if (notification is ScrollNotification) {
      // 一番下までスクロールしたらアイテムを追加
      if (notification.metrics.extentAfter == 0) {
        print("wait $waiting");
        if (!waiting) {
          waiting = true; // とりあえず重複CALL抑止
          asyncAddList();
        }
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) => _onScroll(notification),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index == listItem.length) {
            return Align(
              alignment: Alignment.center,
              child: Text(
                '更新中...',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          return Card(
            child: Padding(
              child: Text(
                listItem[index].toString(),
                style: TextStyle(fontSize: 20.0),
              ),
              padding: EdgeInsets.all(20.0),
            ),
          );
        },
        itemCount: listItem.length + 1,
      ),
    );
  }
}
