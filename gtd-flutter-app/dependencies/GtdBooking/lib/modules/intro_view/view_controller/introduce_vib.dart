import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/bloc/local_cubit.dart';
import 'package:gtd_utils/base/bloc/local_state.dart';

class VIBIntroWidget extends StatelessWidget {
  const VIBIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LocalCubit()..getSavedLanguage()),
        ],
        child: BlocBuilder<LocalCubit, LocalState>(
          builder: (context, state) {
            if (state is LocalLanguageState) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('global.bookFlight'.tr()),
                  automaticallyImplyLeading: true,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          context.push("/flightSearch");
                          // context.push("/paymentMethod");
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => GtdSearchBookWidget.shared
                          //         .pushToBookingModule('en', appRouter)));
                        },
                        child: const Text('VIB Search Flight'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          BlocProvider.of<LocalCubit>(context).changeLanguage("en");
                          context.setLocale(const Locale("en"));
                        },
                        child: const Text('EN'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          BlocProvider.of<LocalCubit>(context).changeLanguage("vi");
                          context.setLocale(const Locale("vi"));
                        },
                        child: const Text('VI'),
                      ),
                    ],
                  ),
                ), // This trailing comma makes auto-formatting nicer for build methods.
              );
            }
            return const SizedBox();
          },
        ));
  }
}
