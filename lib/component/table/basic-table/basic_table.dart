import 'package:flutter/material.dart';
import 'package:namer_app/config/color.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class BasicTable extends StatefulWidget {
  BasicTable({
    Key? key,
    required this.header,
    required this.width,
    required this.data,
  }) : super(key: key);

  final List<String> header;
  final List<double> width;
  final List<dynamic> data;

  @override
  BasicTableState createState() => BasicTableState();
}

class BasicTableState extends State<BasicTable> {
  late DataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = DataSource(
      header: widget.header,
      width: widget.width,
      data: widget.data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          rowHoverColor: grayLight,
          rowHoverTextStyle: TextStyle(
            color: blackTextColor,
            fontSize: 14,
          ),
          headerColor: primaryLight,
          headerHoverColor: Colors.transparent,
          columnResizeIndicatorColor: primaryMain,
          columnResizeIndicatorStrokeWidth: 2.0,
          gridLineColor: borderColor),
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.fill,
        headerGridLinesVisibility: GridLinesVisibility.both,
        gridLinesVisibility: GridLinesVisibility.both,
        headerRowHeight: 40,
        rowHeight: 40,
        source: dataSource,
        columns: dataSource.buildColumns(),
        onCellTap: (DataGridCellTapDetails details) {
          print(details.rowColumnIndex.rowIndex);
          // 행을 탭했을 때 호출됩니다.
          // dataSource.handleRowTap(details.rowIndex);
        },
      ),
    );
  }
}

class DataSource extends DataGridSource {
  DataSource({
    required this.header,
    required this.width,
    required this.data,
  }) {
    _data = convertToDataGridRows();
  }

  final List<String> header;
  final List<double> width;
  final List<dynamic> data;

  List<DataGridRow> _data = [];

  List<DataGridRow> convertToDataGridRows() {
    return data.map<DataGridRow>((row) {
      if (row is Map<String, dynamic>) {
        // If the row is a Map, assume it is already in the correct format
        List<DataGridCell<dynamic>> cells = [];
        row.forEach((key, value) {
          cells.add(DataGridCell<dynamic>(columnName: key, value: value));
        });
        return DataGridRow(cells: cells);
      } else if (row is Employee) {
        // If the row is an object, convert it to a Map
        List<DataGridCell<dynamic>> cells = [];
        Map<String, dynamic> rowData = row.toJson();
        rowData.forEach((key, value) {
          cells.add(DataGridCell<dynamic>(columnName: key, value: value));
        });
        return DataGridRow(cells: cells);
      }
      // Handle other data types as needed
      return DataGridRow(cells: []);
    }).toList();
  }

  void handleRowTap(int rowIndex) {
    // 행이 탭되었을 때 호출됩니다.
    // 선택된 행의 ID를 가져와서 처리합니다.
    // onRowSelected(_data[rowIndex].getCells()[0].value);
    print(1);
  }

  List<GridColumn> buildColumns() {
    return List.generate(header.length, (index) {
      return GridColumn(
        columnName: '$index',
        label: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            header[index],
            overflow: TextOverflow.ellipsis,
          ),
        ),
        width: width[index],
      );
    });
  }

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);
  final int id;
  final String name;
  final String designation;
  final int salary;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'salary': salary,
    };
  }
}
