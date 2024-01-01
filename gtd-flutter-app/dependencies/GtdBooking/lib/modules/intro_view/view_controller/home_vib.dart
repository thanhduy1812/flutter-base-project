import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/bloc/local_cubit.dart';
import 'package:gtd_utils/base/bloc/local_state.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/native_communicate/gtd_native_channel.dart';

class HomeVibPage extends StatefulWidget {
  const HomeVibPage({super.key});

  @override
  State<HomeVibPage> createState() => _HomeVibPageState();
}

class _HomeVibPageState extends State<HomeVibPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    GtdNativeChannel.shared.handleNativeNavigation(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LocalCubit()..getSavedLanguage()),
        ],
        child: BlocBuilder<LocalCubit, LocalState>(
          builder: (context, state) {
            if (state is LocalLanguageState) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text('global.bookFlight'.tr()),
                  automaticallyImplyLeading: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                        ),
                        onPressed: () {
                          GtdNativeChannel.shared.popToPartnerHome();
                          // SystemNavigator.pop(animated: true);
                        },
                      ),
                    )
                  ],
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Transform.translate(
                            offset: const Offset(0, -100),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GtdImage.giftFromSupplier(assetName: "assets/images/vib-home.gif"),
                                  const Text(
                                    'Đặt vé máy bay Quốc tế trên MyVIB',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Tìm chuyến bay phù hợp nhanh chóng và quản lý chuyến bay tiện lợi',
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )),
                      ),
                      GestureDetector(
                          onTap: () {
                            context.push('/flightSearch');
                            // context.push(PaymentMethodPage.route);
                            // await GtdNativeChannel.shared.gotoPaymentModule("bookingNumber");

                            // context.pushNamed('flightSearchResult', params: {"id": "1"}),
                            // Navigator.of(context, rootNavigator: true).push(
                            //     MaterialPageRoute(builder: (context) => const FlightSearchResultPage())
                            // )
                          },
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: GtdColors.appMainColor(context),
                              gradient: GtdColors.appGradient(context),
                            ),
                            child: const Text(
                              'flight.formSearch.btnSearch',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ).tr(),
                          ))
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }
}
