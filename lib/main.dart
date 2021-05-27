import 'package:flutter/material.dart';
import 'datatable_page.dart';
import 'infinite_scroll_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Sample',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("DataTableページ"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DataTablePage()));
              },
            ),
            ListTile(
              title: Text("無限スクロールページ"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfiniteScrollPage()));
              },
            ),
            ListTile(
              title: Text("押せないメニュー"),
              onTap: () => asyncShowOkDialog("タイトル", "押せません"),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> asyncShowOkDialog(String title, String content) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop("OK"),
            ),
          ],
        );
      },
    );
    return Future.value(result);
  }
}
