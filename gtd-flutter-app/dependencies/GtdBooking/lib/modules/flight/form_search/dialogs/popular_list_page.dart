import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/views/bloc/get_popular_info/get_popular_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/models/json_models/airport.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';

typedef OnTapCallback = void Function(Airport newValue);

enum PopularListType { popular, domestic }

class PopularListPage extends StatefulWidget {
  final OnTapCallback onPressed;
  final PopularListType type;

  const PopularListPage({
    super.key,
    required this.onPressed,
    required this.type,
  });

  @override
  PopularListState createState() => PopularListState();
}

class PopularListState extends State<PopularListPage> {
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
    return BlocBuilder<GetPopularBloc, GetPopularState>(
      builder: (context, state) {
        switch (state.status) {
          case GetPopularStatus.failure:
            return const Center(
              child: Text(
                "No content",
              ),
            );

          case GetPopularStatus.success:
            List<Airport> citiesList = [];
            if (widget.type == PopularListType.popular) {
              citiesList = state.popular ?? [];
            } else {
              citiesList = state.domestic ?? [];
            }

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = citiesList[index];
                return GestureDetector(
                  onTap: () {
                    widget.onPressed(
                      citiesList[index],
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _title(item, index),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          _subtitle(item, index),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: GtdColors.steelGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: citiesList.length,
            );
          case GetPopularStatus.loading:
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  String _title(Airport airport, int index) {
    return '${airport.city2}'
        ' (${airport.cityCode})';
  }

  String _subtitle(Airport airport, int index) {
    return '${airport.country2}';
  }
}
