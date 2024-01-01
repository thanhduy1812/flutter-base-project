import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/models/response/booking_detail_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';

class PassengerDetail extends StatefulWidget {

  const PassengerDetail({
    super.key,
    this.travelerInfo,
    required this.flightDirection,
  });
  final List<TravelerInfoElement>? travelerInfo;
  final FlightDirection flightDirection;

  @override
  State<PassengerDetail> createState() => _PassengerDetailState();
}

class _PassengerDetailState extends State<PassengerDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.grey.shade50,
          thickness: 8,
          height: 0,
        ),
        GestureDetector(
          onTap: () => widget.travelerInfo != null? showModalBottomSheet<bool>(
            useRootNavigator: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(38.0),
              ),
            ),
            context: context,
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.92,
                child: travelerInfo(widget.travelerInfo),
              );
            },
            isScrollControlled: true,
          ): {},
          child: const ListTile(
            title: Text(
              'Hành khách chuyến đi',
              style: TextStyle(
                fontSize: 15
              ),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        )
      ],
    );
  }
  Widget travelerInfo(List<TravelerInfoElement>? travelerInfos) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('flight.passengers',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.center
              ).tr(gender: widget.flightDirection.value),
              leading: const SizedBox(width: 30),
              trailing: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                child: Container(
                  width: 30,
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey.shade900,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: travelerInfos?.length,
                itemBuilder: (context, index) {
                  TravelerInfoElement travelerItem = (travelerInfos?[index])!;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Wrap(
                            spacing: 0,
                            children: [
                              Text(
                                '${'traveler.${travelerItem.adultType}'.tr()}: '
                              ),
                              Text(
                                ('${travelerItem.surName} '
                                '${travelerItem.firstName}').toUpperCase()
                              )
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'traveler.gender',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.normal,
                              fontSize: 15
                            ),
                          ).tr(),
                          trailing: const Text(
                            'traveler',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15
                            ),
                          ).tr(gender: travelerItem.gender),
                        ),
                        SizedBox(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: travelerItem.serviceRequests?.length ?? 0,
                            itemBuilder: (contextSsr, indexSsr) {
                              ServiceRequest ssrItem = (travelerItem.serviceRequests![indexSsr]);
                              return ListTile(
                                title: Text(
                                  'Hành lý',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15
                                  ),
                                ),
                                trailing: Text(
                                  '${ssrItem.ssrName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15
                                  ),
                                ),
                              );
                            }
                          ),
                        )
                      ],
                    ),
                  );
                }
              )
            )
          ]
        )
      )
    );
  }
}





