import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';

class InputPassengerView extends StatelessWidget {
  final GtdInputTextFieldVM viewModel;
  const InputPassengerView({super.key, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    final textFieldViewModel = GtdInputTextFieldVM(
        label: viewModel.placeholder,
        type: viewModel.type,
        inputValidateBehavior: GtdInputValidateBehavior.auto);
    return Builder(builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Nhập ${viewModel.label.toLowerCase()}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 24,
              ),
              GtdTextField(
                viewModel: textFieldViewModel,
                height: 60,
                rightIcon: IconButton(
                  onPressed: () {
                    textFieldViewModel.text = "";
                  },
                  icon: const Icon(Icons.close),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                boxBorder: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade500, width: 1.0),
                    borderRadius: BorderRadius.circular(6)),
              ),
              // Expanded(
              //   child: ListView.builder(
              //       scrollDirection: Axis.vertical,
              //       itemCount: 20,
              //       shrinkWrap: true,
              //       itemBuilder: (context, index) {
              //         return const ListTile(
              //           title: Text("Title"),
              //           subtitle: Text("bbb"),
              //         );
              //       }),
              // ),
              const Expanded(child: SizedBox()),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: GtdButton(
                    borderRadius: 24,
                    onPressed: (value) {
                      Navigator.of(context).pop(textFieldViewModel.text);
                    },
                    gradient: GtdColors.appGradient(context),
                    text: "Tiếp tục"),
              ),
            ],
          )),
        ],
      );
    });
  }
}
