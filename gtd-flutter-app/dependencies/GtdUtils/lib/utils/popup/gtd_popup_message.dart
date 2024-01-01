import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';

class GtdPopupMessage {
  late BuildContext context;
  GtdPopupMessage(this.context);

  Future<void> showError(
      {String title = "", String error = "", GtdVoidCallback? onCancel, GtdCallback? onConfirm}) async {
    //Show popup error and dismiss or callback handle if touch OK/ Cancel
    return await showDialog(
      context: context,
      builder: (BuildContext builder) => AlertDialog(
        // title: Text(
        //   title,
        //   textAlign: TextAlign.center,
        // ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        content: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              child: Padding(
            padding: EdgeInsets.all(title.isEmpty ? 0.0 : 10.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )),
          SizedBox(
              child: Padding(
            padding: EdgeInsets.all(error.isEmpty ? 0.0 : 10.0),
            child: Text(error),
          )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GtdButton(
                    text: "Cancel",
                    height: 40,
                    borderRadius: 10,
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                    colorText: Colors.black,
                    onPressed: (a) {
                      Navigator.of(context).pop<bool>(false);
                      onCancel?.call();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GtdButton(
                    text: "OK",
                    height: 40,
                    borderRadius: 10,
                    gradient: GtdColors.appGradient(context),
                    onPressed: (a) {
                      Navigator.of(context).pop<bool>(true);
                      onConfirm?.call(a);
                    },
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  static void showConfirm(
      {required BuildContext context,
      String title = "",
      String error = "",
      Function()? onConfirm,
      Function()? onCancel}) async {
    //Show popup error and dismiss or callback handle if touch OK/ Cancel
    return await showDialog(
      context: context,
      builder: (BuildContext builder) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 0.0,
        content: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              child: Padding(
            padding: EdgeInsets.all(title.isEmpty ? 0.0 : 10.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )),
          SizedBox(
              child: Padding(
            padding: EdgeInsets.all(error.isEmpty ? 0.0 : 10.0),
            child: Text(error),
          )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GtdButton(
                    text: "Cancel",
                    height: 40,
                    borderRadius: 10,
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                    colorText: Colors.black,
                    onPressed: (a) {
                      Navigator.of(context).pop<bool>(false);
                      onCancel?.call();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GtdButton(
                    text: "OK",
                    height: 40,
                    borderRadius: 10,
                    gradient: GtdColors.appGradient(context),
                    onPressed: (a) {
                      Navigator.of(context).pop<bool>(true);
                      onConfirm?.call();
                    },
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
