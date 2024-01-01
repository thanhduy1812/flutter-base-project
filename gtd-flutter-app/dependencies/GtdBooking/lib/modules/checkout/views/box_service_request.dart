import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/base/view/components/list_item_select_view.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../cubit/flight_checkout_cubit.dart';
import '../view_model/checkout_traveller_form_vm.dart';
import '../view_model/ssr_item_vm.dart';

class BoxServiceRequest extends StatelessWidget {
  final ValueKey<int> position;
  const BoxServiceRequest({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    CheckoutTravellerFormVM travellerForm =
        BlocProvider.of<FlightCheckoutCubit>(context).passengersFormSubject.value[position.value];
    bool isRoundTrip = BlocProvider.of<FlightCheckoutCubit>(context).isRoundTrip;
    return StreamBuilder(
        stream: BlocProvider.of<FlightCheckoutCubit>(context).ssrItemsStream,
        builder: (context, snapshot) {
          bool isFetchedSSR = snapshot.data?.item1 ?? false;
          List<SsrItemVM> departItems = (snapshot.data?.item2 ?? [])
              .where((element) => element.data.bookingDirection == FlightDirection.d)
              .toList()
              .sorted((a, b) => a.data.ssrAmount.compareTo(b.data.ssrAmount))
              .mapIndexed((index, element) {
            // element.isSelected = index == 0;
            return element;
          }).toList();
          List<SsrItemVM> returnItems = (snapshot.data?.item2 ?? [])
              .where((element) => element.data.bookingDirection == FlightDirection.r)
              .toList()
              .sorted((a, b) => a.data.ssrAmount.compareTo(b.data.ssrAmount))
              .mapIndexed((index, element) {
            // element.isSelected = index == 0;
            return element;
          }).toList();
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 4),
                  child: GtdTextField(
                    viewModel: travellerForm.departBaggage!,
                    rightIcon: !isFetchedSSR
                        ? Transform.scale(
                            scale: 0.4,
                            child: const CircularProgressIndicator(
                              strokeWidth: 6,
                            ),
                          )
                        : const Icon(Icons.chevron_right),
                    height: 60,
                    isDisable: departItems.isEmpty,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    onSelect: departItems.isEmpty
                        ? null
                        : () => GtdPresentViewHelper.presentView<SsrItemVM>(
                              title: 'Hành lý chuyến đi',
                              builder: Builder(
                                builder: (context) {
                                  return ListItemSelectView(
                                    viewmodels: departItems,
                                    rightIconSelected: Icon(
                                      Icons.radio_button_checked_rounded,
                                      color: Colors.grey.shade900,
                                    ),
                                    rightIconUnSelected: Icon(
                                      Icons.radio_button_off,
                                      color: Colors.grey.shade900,
                                    ),
                                    onSelectItem: (item) {
                                      Navigator.of(context).pop(item);
                                    },
                                  );
                                },
                              ),
                              context: context,
                              onChanged: (item) {
                                print(item.isSelected);
                                travellerForm.departBaggage?.onSelectedService(item);
                                BlocProvider.of<FlightCheckoutCubit>(context).updatePassenger(key: position);
                              },
                            ),
                  ),
                ),
                const Divider(
                  color: Color.fromRGBO(241, 241, 241, 1),
                  height: 0,
                ),
                isRoundTrip
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 4),
                        child: GtdTextField(
                          viewModel: travellerForm.returnBaggage!,
                          isBoldTextWhenEmpty: true,
                          rightIcon: !isFetchedSSR
                              ? Transform.scale(
                                  scale: 0.4,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 6,
                                  ))
                              : const Icon(Icons.chevron_right),
                          height: 60,
                          isDisable: returnItems.isEmpty,
                          onSelect: returnItems.isEmpty
                              ? null
                              : () => GtdPresentViewHelper.presentView<SsrItemVM>(
                                    title: 'Hành lý chuyến về',
                                    builder: Builder(
                                      builder: (context) {
                                        return ListItemSelectView(
                                          viewmodels: returnItems,
                                          rightIconSelected: Icon(
                                            Icons.radio_button_checked_rounded,
                                            color: Colors.grey.shade900,
                                          ),
                                          rightIconUnSelected: Icon(
                                            Icons.radio_button_off,
                                            color: Colors.grey.shade900,
                                          ),
                                          onSelectItem: (item) {
                                            Navigator.of(context).pop(item);
                                          },
                                        );
                                      },
                                    ),
                                    context: context,
                                    onChanged: (item) {
                                      print(item.isSelected);
                                      travellerForm.returnBaggage?.onSelectedService(item);
                                      BlocProvider.of<FlightCheckoutCubit>(context).updatePassenger(key: position);
                                    },
                                  ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          );
        });
  }
}
