import 'package:beme_english/home/app_bottom_bar.dart';
import 'package:beme_english/home/view_model/import_csv_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';

//!Table
class ImportCSVPage extends BaseStatelessPage<ImportCSVPageViewModel> {
  static const String route = '/importCSVPage';
  const ImportCSVPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: const MaterialStatePropertyAll(appOrangeDarkColor),
          border: TableBorder.all(color: appBlueDeepColor),
          columns: _generateColumns(),
          rows: _generateRows(),
        ),
      ),
    );
  }

  List<DataColumn> _generateColumns() {
    var rawData = viewModel.courses.map((e) => e.toDataSheet()).first;
    var columns = rawData.keys
        .map(
          (e) => DataColumn(label: Text(e)),
        )
        .toList();
    return columns;
  }

  List<DataRow> _generateRows() {
    var rawData = viewModel.courses.map((e) => e.toDataSheet());
    var rows = rawData
        .map((e) => e.values.map((rawValue) => DataCell(Text(rawValue.toString()))).toList())
        .map((e) => DataRow(cells: e))
        .toList();
    return rows;
  }
}
