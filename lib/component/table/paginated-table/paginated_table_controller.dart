import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PaginatedTableController extends DataGridSource {
  PaginatedTableController(
      {required this.datas,
      required this.header,
      required this.rowsPerPage,
      required this.totalPage,
      required this.onPageClicked}) {
    dataPerPage = datas.getRange(0, rowsPerPage).toList();
    buildPaginatedDataGridRows(header);
  }
  final DataPagerController dataPagerController = DataPagerController();

  int rowsPerPage = 0;
  int totalPage = 0;
  List<String> header = [];
  List<dynamic> datas = [];
  List<dynamic> dataPerPage = [];
  late Function(int) onPageClicked;

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }).toList());
  }

  @override
  // Syncfusion DataPager에서 페이지가 변경될 때 호출되는 콜백 함수
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    dataPagerController.lastPage();
    if (newPageIndex != 0) {
      var additionalData = await onPageClicked(startIndex);
      if (additionalData is List) {
        datas.addAll(additionalData);
      }
    }

    if (startIndex < datas.length && endIndex <= datas.length) {
      await Future.delayed(Duration(milliseconds: 1000));
      dataPerPage = datas.getRange(startIndex, endIndex).toList();
      buildPaginatedDataGridRows(header);
      notifyListeners();
    } else {
      dataPerPage = [];
    }

    return true;
  }

  void buildPaginatedDataGridRows(List<String> header) {
    dataGridRows = dataPerPage.map<DataGridRow>((dataGridRow) {
      List<DataGridCell> cells = [];
      var dataMap = dataGridRow.toMap();
      for (var columnName in header) {
        var value = dataMap[columnName];
        cells.add(DataGridCell(columnName: columnName, value: value));
      }
      return DataGridRow(cells: cells);
    }).toList();
  }

  void previousPage() {}

  void onNextPageClicked() {
    print('bye');
  }

  void onFirstPageClicked() {}

  void onLastPageClicked() {}
}
