import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/views/bloc/get_location_info/get_location_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/models/json_models/search_airport.dart';

typedef OnTapCallback = void Function(SearchAirport newValue);

class LocationListPage extends StatefulWidget {
  final OnTapCallback onPressed;

  const LocationListPage({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  LocationList createState()=> LocationList();
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
              return const Center(child: Text(
                  'Không tìm thấy bài viết nào'));
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
                  return GestureDetector(
                    onTap: () {
                      widget.onPressed(state.cities[index]);
                    },
                    child: ListTile(
                      title: Text('${state.cities[index].name} (${state.cities[index].code})'),
                      subtitle: Text('${state.cities[index].country}'),
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
        }
    );
  }
}