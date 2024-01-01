import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';

class BoxInvoiceInfo extends StatelessWidget {
  const BoxInvoiceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  static Widget invoiceInfo({required String invoiceTitle, GtdVoidCallback? onSelect, required BuildContext context}) {
    return InkWell(
      onTap: onSelect,
      child: SizedBox(
        height: 55,
        child: Ink(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GtdInfoRow.seperatedRow(
                      title: Text(
                    invoiceTitle,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
