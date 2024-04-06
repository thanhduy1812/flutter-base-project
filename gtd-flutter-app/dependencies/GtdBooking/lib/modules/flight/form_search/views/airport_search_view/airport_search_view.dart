import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/dialogs/location_list_item.dart';
import 'package:gtd_booking/modules/flight/form_search/dialogs/popular_list_page.dart';
import 'package:gtd_booking/modules/flight/form_search/views/bloc/get_location_info/get_location_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/views/bloc/get_popular_info/get_popular_bloc.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/helpers/extension/string_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';

import '../../model/destination.dart';

// ignore: must_be_immutable
class AirportSearchView extends StatelessWidget {
  final GtdCallback<Destination> onPressed;
  final String flightType;
  final TextEditingController controllerSearch = TextEditingController();
  late final ScrollController scrollController;
  late final GetLocationBloc _searchBloc;
  late final GetPopularBloc _getPopularBloc;

  AirportSearchView({
    super.key,
    required this.onPressed,
    required this.flightType,
  }) {
    scrollController = ScrollController(
      keepScrollOffset: true,
      debugLabel: 'pageBodyScroll',
    );
  }

  String keyword = '';

  String _searchText() {
    if (flightType == 'destination') {
      return 'flight.formSearch.destination'.tr();
    } else {
      return 'flight.formSearch.departure'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    _searchBloc = context.read<GetLocationBloc>();
    _getPopularBloc = context.read<GetPopularBloc>();
    _getPopularBloc.add(const GetAllPopularFetched());

    return Column(
      children: [
        // Top Itinerary
        _inputSearch(),
        Expanded(
          child: BlocBuilder<GetLocationBloc, GetLocationState>(
            builder: (context, state) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _recentSearch(),
                      //Chon chuyen di
                      _locationList(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _locationList() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 12),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: _Title(
              title: 'flight.formSearch.popularSearch'.tr(),
            ),
          ),
          keyword != '' ? _searchList() : _popularList(),
        ],
      ),
    );
  }

  Widget _popularList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PopularListPage(
          type: PopularListType.popular,
          onPressed: (itemLocation) {
            onPressed(
              Destination(
                code: itemLocation.airportCode,
                name: itemLocation.city2,
                nameEn: itemLocation.city,
                country: itemLocation.country2,
                countryEn: itemLocation.country,
                airportName: itemLocation.airportName2,
                airportNameEn: itemLocation.airportName,
                type: flightType,
              ),
            );
          },
        ),
        const Divider(thickness: 12, height: 24,),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: _Title(
            title: 'flight.formSearch.vietNam'.tr(),
          ),
        ),
        PopularListPage(
          type: PopularListType.domestic,
          onPressed: (itemLocation) {
            onPressed(
              Destination(
                code: itemLocation.airportCode,
                name: itemLocation.city2,
                nameEn: itemLocation.city,
                country: itemLocation.country2,
                countryEn: itemLocation.country,
                airportName: itemLocation.airportName2,
                airportNameEn: itemLocation.airportName,
                type: flightType,
              ),
            );
          },
        ),
      ],
    );
  }

  LocationListPage _searchList() {
    return LocationListPage(
      onPressed: (itemLocation) {
        onPressed(
          Destination(
            code: itemLocation.code,
            name: itemLocation.city,
            nameEn: itemLocation.city2,
            country: itemLocation.country,
            countryEn: itemLocation.country,
            airportName: itemLocation.name,
            airportNameEn: itemLocation.name2,
            type: flightType,
          ),
        );
      },
    );
  }

  Widget _recentSearch() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.center,
      child: keyword != ''
          ? const SizedBox()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(
                    title: 'flight.formSearch.recentSearch'.tr(),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50,
                    ),
                    child: Wrap(
                      runSpacing: 10,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GtdImage.svgFromSupplier(
                              assetName:
                                  "assets/icons/flight/departure_grey.svg",
                              width: 20,
                            ),
                            Expanded(
                              child: GtdImage.svgFromSupplier(
                                assetName:
                                    "assets/icons/flight/line-itinerary.svg",
                              ),
                            ),
                            GtdImage.svgFromSupplier(
                              assetName:
                                  "assets/icons/flight/destination_grey.svg",
                              width: 20,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SGN',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Hồ Chí Minh',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'HAN',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Hà Nội',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _inputSearch() {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: TextFormField(
            controller: controllerSearch,
            onChanged: (value) {
              keyword = value;
              _searchBloc.add(GetLocationFetched(keyword: value));
            },
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: '${'global.enter'.tr()} ${_searchText()}'.capitalize(),
              hintStyle: const TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(108, 114, 127, 1),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(10, 7, 5, 7),
                child: GtdImage.svgFromSupplier(
                  assetName: "assets/icons/search.svg",
                  width: 24,
                ),
              ),
              filled: true,
              isDense: true,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 0,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              fillColor: Colors.grey.shade50,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
    );
  }
}
