import 'package:beme_english/home/app_bottom_bar.dart';
import 'package:beme_english/home/view_model/import_csv_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

//!Table
class ImportCSVPage extends BaseStatelessPage<ImportCSVPageViewModel> {
  static const String route = '/importCSVPage';
  const ImportCSVPage({super.key, required super.viewModel});

  @override
  List<Widget> buildTrailingActions(BuildContext pageContext) {
    return [
      IconButton(
          onPressed: () {
            GtdPopupMessage(pageContext).showError(
              error: "Do you want Export?",
              onConfirm: (value) {
                viewModel.exportDataTableToCsv(viewModel.generateDataTable());
              },
            );
          },
          icon: const Icon(Icons.import_export, size: 36, color: Colors.green))
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return viewModel.generateDataTable();
          },
        ),
      ),
    );
  }

  // List<DataColumn> _generateColumns() {
  //   // var rawData = viewModel.courses.map((e) => e.toDataSheet()).first;
  //   var rawData = viewModel.generateColumn;
  //   var columns = rawData.keys
  //       .map(
  //         (e) => DataColumn(label: Text(e)),
  //       )
  //       .toList();
  //   return columns;
  // }

  // List<DataRow> _generateRows() {
  //   // var rawData = viewModel.courses.map((e) => e.toDataSheet());
  //   var rawData = viewModel.generateDataFeedbacks();
  //   var rows = rawData
  //       .map((e) => e.values.map((rawValue) => DataCell(Text(rawValue.toString()))).toList())
  //       .map((e) => DataRow(cells: e))
  //       .toList();
  //   return rows;
  // }
}
