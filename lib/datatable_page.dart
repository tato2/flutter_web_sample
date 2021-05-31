import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

///
/// DataTableページ
///
class DataTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("DataTablePage build");

    return Scaffold(
      appBar: AppBar(
        title: Text('DataTableページ'),
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
  List _dataTable = [];
  late StreamController _itemsController; // late:遅延初期化

  String _code = '';

  @override
  void initState() {
    super.initState();
    _itemsController = StreamController();
    _itemsController.add(null); // null=loadingとみなす
    asyncGetData(_code);
  }

  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            firstContainer(),
            secondContainer(),
          ],
        ));
  }

  Widget firstContainer() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Text('証券コード'),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onChanged: (e) {
                  _handleChanged('code', e);
                },
                maxLength: 4,
              ),
            ),
          ],
        ),
        Row(children: [
          ElevatedButton(
            onPressed: () {
              _itemsController.add(null);
              asyncGetData(_code);
            },
            child: Text('検索'),
          ),
        ]),
      ],
    );
  }

  Widget secondContainer() {
    return StreamBuilder(
        stream: _itemsController.stream,
        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
          print('builder ' + snapshot.hasData.toString());

          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(''),
                  CircularProgressIndicator(),
                  Text('3秒待ちます'),
                ],
              ),
            );
          }

          if (_dataTable.length == 0) {
            return Text('データなし');
          }

          return PaginatedDataTable(
            rowsPerPage: _dataTable.length > 10 ? 10 : _dataTable.length,
            columns: const <DataColumn>[
              DataColumn(label: Text('証券コード')),
              DataColumn(label: Text('証券名')),
              DataColumn(label: Text('市場')),
            ],
            source: MyDataSource(_dataTable),
          );
        });
  }

  Future<void> asyncGetData(String code) async {
    // 3秒待つ
    await Future.delayed(Duration(seconds: 3));

    String text = await rootBundle.loadString('assets/list.json');
    _dataTable = json.decode(text);

    if (_code != '') {
      _dataTable.removeWhere(
          (element) => !element['code'].toString().startsWith(code));
    }
    _itemsController.add(_dataTable);
  }

  void _handleChanged(String control, String e) {
    switch (control) {
      case 'code':
        _code = e;
        break;
    }
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
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
