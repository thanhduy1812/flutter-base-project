import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/views/bloc/get_location_info/get_location_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/models/json_models/search_airport.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';

typedef OnTapCallback = void Function(SearchAirport newValue);

class LocationListPage extends StatefulWidget {
  final OnTapCallback onPressed;

  const LocationListPage({
    super.key,
    required this.onPressed,
  });

  @override
  LocationList createState() => LocationList();
}

class LocationList extends State<LocationListPage> {
  late final ScrollController scrollController;

  bool isLoading = false;
  String? keyword;

  @override
  void initState() {
    super.initState();
    keyword = '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetLocationBloc, GetLocationState>(
      builder: (context, state) {
        switch (state.status) {
          case GetLocationStatus.failure:
            return const Center(child: Text('Không tìm thấy bài viết nào'));
          case GetLocationStatus.success:
            if (state.cities.isEmpty) {
              return const Center(child: Text('Không tìm thấy bài viết nào!'));
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = state.cities[index];
                return GestureDetector(
                  onTap: () {
                    widget.onPressed(item);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.city} (${item.code})',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${item.country}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: GtdColors.steelGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        color: GtdColors.whiteWash,
                        child: Row(
                          children: [
                            GtdAppIcon.iconNamedSupplier(
                              iconName: "flight/arrow-turn-right.svg",
                              width: 40,
                              color: Colors.black,
                            ),
                            Expanded(
                              child: Text(
                                '(${item.code}) ${item.name}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: state.cities.length,
            );
          case GetLocationStatus.loading:
            return const Center(child: CircularProgressIndicator());
          default:
            return const SizedBox();
        }
      },
    );
  }
}
