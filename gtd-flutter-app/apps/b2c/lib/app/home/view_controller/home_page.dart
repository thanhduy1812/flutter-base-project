import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/booking_result.dart';
import 'package:gtd_utils/data/cache_helper/user_manager.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/banner_resource/banner_resource.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/helpers/extension/string_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_shimmer.dart';
import 'package:new_gotadi/app/home/cubit/home_banner_cubit.dart';
import 'package:new_gotadi/app/home/view_model/box_banner_mkt_view_model.dart';
import 'package:new_gotadi/app/home/views/box_banner_mkt.dart';
import 'package:new_gotadi/app/home/views/box_search_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:new_gotadi/app/notifications/view_controller/notifications_page.dart';

import 'package:uni_links/uni_links.dart';

import '../view_model/home_page_viewmodel.dart';

class HomePage extends StatefulWidget {
  final HomePageViewModel viewModel;
  const HomePage({super.key, required this.viewModel});

  static const String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  static bool _isDark(final Color color) => ThemeData.estimateBrightnessForColor(color) == Brightness.dark;

  StreamSubscription? _streamSubscription;
  bool _initialURILinkHandled = false;
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  @override
  void initState() {
    _initURIHandler();
    _incomingLinkHandler();

    ///Call get account data here so account data is saved in UserManager
    UserManager.shared.getAccountData();
    UserManager.shared.bookingResultWebViewCallback = (bookingNumber) {
      _navigateToBookingResult(bookingNumber);
    };

    UserManager.shared.popToHomeCallback = () {
      //TODO: Handle Later
      debugPrint("go home");
    };
    super.initState();
  }

  Future<void> _initURIHandler() async {
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      // 2
      // Fluttertoast.showToast(
      //     msg: "Invoked _initURIHandler",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white
      // );
      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        // 6
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  _navigateToBookingResult(String bookingNumber) {
    debugPrint('bookingNumber: $bookingNumber');
    final router = GoRouter.of(context);
    while (router.canPop()) {
      router.pop();
    }
    router.push(
      BookingResultPage.route,
      extra: {
        'bookingNumber': bookingNumber,
      },
    );
  }

  void _incomingLinkHandler() {
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        // context.goNamed(HomePage.route);
        final bookingNumber = uri?.queryParameters['bookingNumber'];
        if (!bookingNumber.isNullOrEmpty()) {
          _navigateToBookingResult(bookingNumber!);
        }
        debugPrint('Received URI: $uri');
        setState(() {
          _currentURI = uri;
          _err = null;
        });
        // 3
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final viewModel = widget.viewModel;
    super.build(context);
    return BlocProvider(
      create: (context) => HomeBannerCubit()
        ..loadHomeViewModel(viewModel)
        ..loadHomeBanners(isFristLoad: viewModel.isFristLoad)
        ..loadExisTopBanners(viewModel.topBanners)
        ..countUnreadMessage(),
      child: BlocBuilder<HomeBannerCubit, HomeBannerState>(
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0), // here the desired height
              child: AppBar(
                backgroundColor: _isDark(theme.colorScheme.surface) ? null : AppColors.mainColor,
                elevation: 0,
                leading: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _isDark(theme.colorScheme.surface)
                      ? GtdImage.svgFromAsset(assetPath: "assets/images/logo_b2c_dark.svg", width: 200)
                      : GtdImage.svgFromAsset(assetPath: "assets/images/logo_b2c.svg", width: 200),
                ),
                leadingWidth: 110,
                actions: [
                  IconButton(
                    icon: StreamBuilder<int>(
                        stream: BlocProvider.of<HomeBannerCubit>(context).countMessageStream,
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return Badge(
                            isLabelVisible: count != 0,
                            label: Text(
                              '$count',
                              style: const TextStyle(color: Colors.white),
                            ),
                            child: const Icon(Icons.notifications_outlined),
                          );
                        }),
                    tooltip: 'Notifications',
                    color: Colors.white,
                    onPressed: () {
                      context.push(NotificationsPage.route);
                    },
                  ),
                ],
              ),
            ),
            body: BlocBuilder<HomeBannerCubit, HomeBannerState>(
              // buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    viewModel.isFristLoad = false;
                    BlocProvider.of<HomeBannerCubit>(context).loadHomeBanners(isFristLoad: false, isRefresh: true);
                  },
                  child: CustomScrollView(
                    slivers: [
                      // TopGalleries(),
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: BoxSearchHeaderDelegate(),
                      ),
                      ...((state is HomeBannerLoading) ? [_loadingItems()] : _listBannerBody(context)),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _loadingItems() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                GtdShimmer(child: SizedBox(height: 120, width: double.infinity, child: GtdShimmer.cardLoading())),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: 5),
      ),
    );
  }

  List<Widget> _listBannerBody(BuildContext context) {
    final viewModel = widget.viewModel;
    return [
      //Promotion Banner
      SliverToBoxAdapter(
        child: StreamBuilder<List<GtdBannerRs>>(
            stream: BlocProvider.of<HomeBannerCubit>(context).sponsorStream,
            initialData: viewModel.sponsorBanners,
            builder: (context, snapshot) {
              viewModel.sponsorBanners = snapshot.data ?? [];
              viewModel.isFristLoad = true;
              if (viewModel.sponsorBanners.isEmpty == true) {
                return const SizedBox();
              }
              return Card(
                elevation: 0,
                color: Colors.transparent,
                margin: const EdgeInsets.all(10),
                child: BoxBannerMkt(
                  viewModel: BoxBannerMktViewModel(headerTitle: "", largeBanner: viewModel.sponsorBanners.first),
                ),
              );
            }),
      ),
      //Hotel Banner
      SliverToBoxAdapter(
        child: StreamBuilder<List<GtdBannerRs>>(
            stream: BlocProvider.of<HomeBannerCubit>(context).hotelStream,
            initialData: viewModel.hotelBanners,
            builder: (context, snapshot) {
              viewModel.hotelBanners = snapshot.data ?? [];
              viewModel.isFristLoad = true;
              if (viewModel.hotelBanners.isEmpty == true) {
                return const SizedBox();
              }
              return Card(
                elevation: 0,
                color: Colors.transparent,
                margin: const EdgeInsets.all(10),
                child: BoxBannerMkt(
                  viewModel: BoxBannerMktViewModel(headerTitle: "Khách sạn hot", banners: viewModel.hotelBanners),
                ),
              );
            }),
      ),

      //Combo Banner
      SliverToBoxAdapter(
        child: StreamBuilder<List<GtdBannerRs>>(
            stream: BlocProvider.of<HomeBannerCubit>(context).comboStream,
            initialData: viewModel.hotelBanners,
            builder: (context, snapshot) {
              viewModel.comboBanners = snapshot.data ?? [];
              viewModel.isFristLoad = true;
              if (viewModel.comboBanners.isEmpty == true) {
                return const SizedBox();
              }
              return Card(
                elevation: 0,
                color: Colors.transparent,
                margin: const EdgeInsets.all(10),
                child: BoxBannerMkt(
                  viewModel: BoxBannerMktViewModel(headerTitle: "Combo siêu hot", banners: viewModel.comboBanners),
                ),
              );
            }),
      ),

      //Chill Banner
      SliverToBoxAdapter(
        child: StreamBuilder<List<GtdBannerRs>>(
            stream: BlocProvider.of<HomeBannerCubit>(context).chillStream,
            initialData: viewModel.chillBanners,
            builder: (context, snapshot) {
              viewModel.chillBanners = snapshot.data ?? [];
              viewModel.isFristLoad = true;
              if (viewModel.chillBanners.isEmpty == true) {
                return const SizedBox();
              }
              return Card(
                elevation: 0,
                color: Colors.transparent,
                margin: const EdgeInsets.all(10),
                child: BoxBannerMkt(
                  viewModel: BoxBannerMktViewModel(
                      headerTitle: "Góc Chill, Phiêu trải nghiệm", banners: viewModel.chillBanners),
                ),
              );
            }),
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
