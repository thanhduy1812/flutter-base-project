import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/personal_info/model/nationality_model.dart';
import 'package:gtd_booking/modules/personal_info/view_model/nationality_list_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_list_builder/gtd_alphabet_list.dart';

class NationalityList extends BaseView<NationalityListViewModel> {
  final GtdCallback<NationalityModel>? onSelect;
  const NationalityList({super.key, required super.viewModel, this.onSelect});

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
                hintText: 'Nhập tên quốc gia',
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
                stream: viewModel.nationalityController.stream,
                builder: (context, snapshot) {
                  if ((snapshot.data ?? []).isEmpty) {
                    return const SizedBox();
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
                        return Material(
                          clipBehavior: Clip.antiAlias,
                          child: Ink(
                            color: Colors.grey.shade50,
                            height: 8,
                          ),
                        );
                      },
                      itemBuilder: (context, item) => InkWell(
                        onTap: () => onSelect?.call(item),
                        child: ListTile(
                          title: Text(item.model.name ?? ""),
                          leading: const Icon(
                            Icons.my_location,
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
