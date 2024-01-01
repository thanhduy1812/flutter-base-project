import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/personal_info/model/saved_traveller_model.dart';
import 'package:gtd_booking/modules/personal_info/view_model/saved_traveller_list_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_customer_repository/extension/gtd_saved_traveller_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_list_builder/gtd_alphabet_list.dart';

class SavedTravellerList extends BaseView<SaveTravellerListViewModel> {
  final GtdCallback<SavedTravellerModel>? onSelect;
  const SavedTravellerList({super.key, required super.viewModel, this.onSelect});

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
                hintText: 'Nhập tên khách, Email, Điện thoại...',
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
                stream: viewModel.savedTravellers.stream,
                builder: (context, snapshot) {
                  if ((snapshot.data ?? []).isEmpty) {
                    return const SizedBox(
                      child: Center(
                        child: Text("Không tìm thấy hành khách đã lưu"),
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
                          title: Row(
                            children: [
                              Text(
                                item.model.fullname,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                              ),
                              (item.model.adultTypeEnum != null)
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Ink(
                                        color: CustomColors.mainOrange.shade50,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          child: Text(
                                            item.model.adultTypeEnum?.value ?? "",
                                            style: TextStyle(
                                                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.boldText),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          subtitle: Text(
                            item.model.subInfoEmailPhone,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                          ),
                          leading: item.model.isMale
                              ? const Icon(
                                  Icons.male_rounded,
                                  color: Colors.blueAccent,
                                )
                              : const Icon(
                                  Icons.female_rounded,
                                  color: Colors.pink,
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
