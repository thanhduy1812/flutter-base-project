import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/personal_info/model/saved_company_model.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_list_builder/gtd_alphabet_list.dart';

import '../view_model/saved_company_list_viewmodel.dart';

class SavedCompanyList extends BaseView<SavedCompanyListViewModel> {
  final GtdCallback<SavedCompanyModel>? onSelect;
  const SavedCompanyList({super.key, required super.viewModel, this.onSelect});

  @override
  Widget buildWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                hintText: 'Nhập tên DN, MST, Địa chỉ...',
                hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade50,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
              ),
              onChanged: (value) {
                viewModel.querySearchController.sink.add(value);
              },
            ),
          ),
        ),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: StreamBuilder(
                stream: viewModel.companyModelController.stream,
                builder: (context, snapshot) {
                  if ((snapshot.data ?? []).isEmpty) {
                    return const SizedBox(
                      child: Center(
                        child: Text("Không tìm thấy doanh nghiệp đã lưu"),
                      ),
                    );
                  } else {
                    return GtdAlphabetList(
                      data: snapshot.data!,
                      headerBuilder: (context, item) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            item.groupName,
                            style: TextStyle(color: AppColors.boldText, fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                      footerBuilder: (context, item) {
                        return Ink(
                          color: Colors.grey.shade50,
                          height: 8,
                        );
                      },
                      itemBuilder: (context, item) => InkWell(
                        onTap: () => onSelect?.call(item),
                        child: ListTile(
                          title: Text(
                            item.model.businessName ?? "----",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                          ),
                          subtitle: Text.rich(TextSpan(
                              text: "${item.model.taxCode ?? "---"} \n",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                              children: [
                                TextSpan(
                                    text: item.model.address ?? "",
                                    style:
                                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText))
                              ])),
                          leading: Icon(
                            Icons.monetization_on,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }
}
