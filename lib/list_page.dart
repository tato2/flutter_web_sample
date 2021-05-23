import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

///
/// 一覧画面
///
class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("ListPage build");

    return Scaffold(
      appBar: AppBar(
        title: Text('一覧画面'),
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
  late Future _future; // late:遅延初期化
  List _dataTable = [];

  @override
  void initState() {
    super.initState();
    _future = asyncGetData();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('3秒待ちます'),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: PaginatedDataTable(
                rowsPerPage: 10,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('証券コード'),
                  ),
                  DataColumn(
                    label: Text('証券名'),
                  ),
                  DataColumn(
                    label: Text('市場'),
                  ),
                ],
                source: MyDataSource(_dataTable),
              ));
        });
  }

  Future<void> asyncGetData() async {
    // 3秒待つ
    await Future.delayed(Duration(seconds: 3));

    String text = await rootBundle.loadString('assets/list.json');
    var data = json.decode(text);
    setState(() {
      _dataTable = data;
    });
  }
}

class MyDataSource extends DataTableSource {
  final List<dynamic> _dataTable;

  MyDataSource(this._dataTable);

  @override
  DataRow getRow(int index) {
    /// 1行文のデータ
    return DataRow(cells: [
      // 中身のデータは DataCell として追加する
      DataCell(Text(_dataTable[index]['code'])),
      DataCell(Text(_dataTable[index]['name'])),
      DataCell(Text(_dataTable[index]['item'])),
    ]);
  }

  @override
  int get rowCount => _dataTable.length;
  @override
  bool get isRowCountApproximate => true;
  @override
  int get selectedRowCount => 0;
}
