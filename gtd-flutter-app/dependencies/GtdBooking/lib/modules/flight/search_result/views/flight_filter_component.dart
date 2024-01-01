import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/search_result/bloc_cubit/flight_filter_options_cubit.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';

// enum GtdActionsBtnFilter { defaultFilter, applyFilter }

// class GtdActionDataFilter {
//   List<AllFilterOptionsDTO>? allFilterOptionsDTO;
//   GtdActionsBtnFilter action;
//   GtdActionDataFilter({
//     required this.action,
//     this.allFilterOptionsDTO,
//   });
// }

typedef OnTapCallback = void Function(List<AllFilterOptionsDTO>);

class FlightFilterResult extends StatefulWidget {
  final OnTapCallback whenDismiss;
  final List<AllFilterOptionsDTO> allFilterOptionsDTO;

  const FlightFilterResult({super.key, required this.allFilterOptionsDTO, required this.whenDismiss});

  @override
  State<FlightFilterResult> createState() => _FlightFilterResultState();
}

class _FlightFilterResultState extends State<FlightFilterResult> {
  @override
  Widget build(BuildContext context) {
    final allFilterOptionsDTO = widget.allFilterOptionsDTO;
    return BlocProvider(
      create: (context) => FlightFilterOptionsCubit()..initWithFilterOptions(allFilterOptionsDTO),
      child: BlocBuilder<FlightFilterOptionsCubit, FlightFilterOptionsState>(
        builder: (filterOptionscontext, filterOptionsState) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('flight.filter.filterOptions').tr(),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                )
              ],
            ),
            body: StreamBuilder(
                stream: BlocProvider.of<FlightFilterOptionsCubit>(filterOptionscontext).filterStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<AllFilterOptionsDTO> filterOptions = snapshot.data!;
                    return SafeArea(
                      bottom: true,
                      child: Stack(
                        children: [
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: filterOptions.length,
                              itemBuilder: (BuildContext contextView, int index) {
                                final filterOptionItem = filterOptions[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: const Text('flight.filter',
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))
                                          .tr(gender: filterOptionItem.type?.name),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: filterOptionItem.filterOptions?.length,
                                        itemBuilder: (BuildContext contextOption, int indexOption) {
                                          final filterOption = filterOptionItem.filterOptions?[indexOption];
                                          return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              BlocProvider.of<FlightFilterOptionsCubit>(filterOptionscontext)
                                                  .selectFilterItem(filterOption);
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Wrap(
                                                        spacing: filterOptionItem.showIcon ? 13 : 0,
                                                        crossAxisAlignment: WrapCrossAlignment.center,
                                                        children: [
                                                          (filterOptionItem.showIcon)
                                                              ? GtdImage.svgFromSupplier(
                                                                  assetName:
                                                                      'assets/icons/flight/${filterOption?.name}.svg')
                                                              : const SizedBox(),
                                                          (filterOptionItem.type == TypeFilter.airline)
                                                              ? Text(
                                                                  '${filterOption?.name}',
                                                                  style: const TextStyle(fontSize: 16),
                                                                )
                                                              : const Text(
                                                                  'flight.filter.filterName',
                                                                  style: TextStyle(fontSize: 16),
                                                                ).tr(gender: filterOption?.name)
                                                        ],
                                                      )),
                                                      (filterOption?.isSelected == true)
                                                          ? GtdImage.svgFromSupplier(
                                                              assetName: 'assets/icons/check.svg')
                                                          : const SizedBox(),
                                                      // GtdImageSvg.assetForPackage(
                                                      //     assetName: 'assets/icons/check.svg')
                                                    ],
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 0.2,
                                                )
                                              ],
                                            ),
                                          );
                                        })
                                  ],
                                );
                              }),
                          Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                color: Colors.white,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: GtdButton(
                                            text: 'Mặc định',
                                            height: 48,
                                            colorText: Colors.grey.shade900,
                                            borderRadius: 10,
                                            border: Border.all(color: Colors.grey.shade200, width: 2),
                                            onPressed: (val) {
                                              Navigator.pop(context, true);
                                              List<AllFilterOptionsDTO> defaultFilter =
                                                  filterOptions.map((e) => e.defaultFilter()).toList();
                                              widget.whenDismiss(defaultFilter);
                                            })),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: GtdButton(
                                            text: 'Áp dụng',
                                            height: 48,
                                            borderRadius: 10,
                                            gradient: GtdColors.appGradient(context),
                                            onPressed: (val) {
                                              Navigator.pop(context, true);
                                              widget.whenDismiss(filterOptions);
                                            })),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    );
                  } else {
                    //TODO: Handle empty list filter
                    return const SizedBox(
                      height: 100,
                    );
                  }
                }),
          );
        },
      ),
    );
  }
}
