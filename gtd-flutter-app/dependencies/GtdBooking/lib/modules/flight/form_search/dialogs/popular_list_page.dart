import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/views/bloc/get_popular_info/get_popular_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/models/json_models/airport.dart';

typedef OnTapCallback = void Function(Airport newValue);

class PopularListPage extends StatefulWidget {
  final OnTapCallback onPressed;
  const PopularListPage({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

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
    return BlocBuilder<GetPopularBloc, GetPopularState>(builder: (context, state) {
      switch (state.status) {
        case GetPopularStatus.failure:
          return const Center(child: Text("No content"));

        case GetPopularStatus.success:
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  widget.onPressed(state.popularAirportRS!.internationalCities![index]);
                },
                child: ListTile(
                  title: Text('${state.popularAirportRS!.internationalCities![index].city2}'
                      ' (${state.popularAirportRS!.internationalCities![index].cityCode})'),
                  subtitle: Text('${state.popularAirportRS!.internationalCities![index].country2}'),
                ),
              );
            },
            itemCount: state.popularAirportRS!.internationalCities!.length,
          );
        case GetPopularStatus.loading:
          return const Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
          ));
        default:
          return const SizedBox();
      }
    });
  }
}
