import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/banner_resource/banner_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_authentication_repository/gtd_authentication_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_utility_repository/gtd_utility_repository.dart';
import 'package:new_gotadi/app/home/view_model/home_page_viewmodel.dart';

part 'home_banner_state.dart';
/*
56: sponsor
68: hotel hot
75: combo hot
74: promotion hot
88: top banner
90: interest big
107: chill hot
 */

class HomeBannerCubit extends Cubit<HomeBannerState> {
  final StreamController<int> _countMessageController = StreamController<int>();
  Stream<int> get countMessageStream => _countMessageController.stream;

  final StreamController<List<GtdBannerRs>> _topBannerController = StreamController<List<GtdBannerRs>>();
  Stream<List<GtdBannerRs>> get topBannerStream => _topBannerController.stream;

  final StreamController<List<GtdBannerRs>> _sponsorController = StreamController<List<GtdBannerRs>>();
  Stream<List<GtdBannerRs>> get sponsorStream => _sponsorController.stream;

  final StreamController<List<GtdBannerRs>> _hotelController = StreamController<List<GtdBannerRs>>();
  Stream<List<GtdBannerRs>> get hotelStream => _hotelController.stream;

  final StreamController<List<GtdBannerRs>> _comboController = StreamController<List<GtdBannerRs>>();
  Stream<List<GtdBannerRs>> get comboStream => _comboController.stream;

  final StreamController<List<GtdBannerRs>> _promotionController = StreamController();
  Stream<List<GtdBannerRs>> get promotionStream => _promotionController.stream;

  final StreamController<List<GtdBannerRs>> _interestController = StreamController();
  Stream<List<GtdBannerRs>> get interestStream => _interestController.stream;

  final StreamController<List<GtdBannerRs>> _chillController = StreamController();
  Stream<List<GtdBannerRs>> get chillStream => _chillController.stream;
  HomePageViewModel? homeViewModel;
  bool _isDisposed = false;
  HomeBannerCubit() : super(HomeBannerInitial());

  void loadHomeViewModel(HomePageViewModel viewModel) {
    homeViewModel = viewModel;
  }

  void loadExisTopBanners(List<GtdBannerRs> banners) {
    _topBannerController.sink.add(banners);
  }

  Future<void> countUnreadMessage() async {
    await GtdAuthenticationRepository.shared.getAccountInfo().then((value) {
      value.when((success) async {
        final userRefCode = success.userRefCode ?? "";
        await GtdUtilityRepository.shared.getCountUnreadNotifications(userRefcode: userRefCode).then((value) {
          value.when(
              (success) => _countMessageController.sink.add(success), (error) => _countMessageController.sink.add(0));
        });
      }, (error) {
        _countMessageController.sink.add(0);
      });
    });
  }

  Future<void> loadHomeBanners({bool isFristLoad = false, bool isRefresh = false}) async {
    if (isFristLoad) {
      return;
    }
    if (!isRefresh) {
      emit(HomeBannerLoading());
    }
    //Top Banner
    loadBanner(bannerTaxonomy: 88, bannerDevice: 77).then((value) {
      _topBannerController.sink.add(value);
      _sponsorController.sink.add(value);
      homeViewModel?.topBanners = value;
    });

    //Sponsor Banner
    // loadBanner(bannerTaxonomy: 88, bannerDevice: 77).then((value) => _sponsorController.sink.add(value));

    //Hotel Hot
    loadBanner(bannerTaxonomy: 68, bannerDevice: 77).then((value) => _hotelController.sink.add(value));

    //Combo Hot
    loadBanner(bannerTaxonomy: 75, bannerDevice: 77).then((value) => _comboController.sink.add(value));

    //Combo Hot
    loadBanner(bannerTaxonomy: 107, bannerDevice: 77).then((value) => _chillController.sink.add(value));
  }

  Future<void> loadPromotionBanners({bool isFristLoad = false, bool isRefresh = false}) async {
    debugPrint("loadPromotionBanners");
    if (isFristLoad) {
      return;
    }
    if (!isRefresh) {
      emit(HomeBannerLoading());
    }
    //Hotel Hot
    loadBanner(bannerTaxonomy: 68, bannerDevice: 77).then((value) => _hotelController.sink.add(value));

    //Combo Hot
    loadBanner(bannerTaxonomy: 75, bannerDevice: 77).then((value) => _comboController.sink.add(value));

    //Chill Hot
    loadBanner(bannerTaxonomy: 107, bannerDevice: 77).then((value) => _chillController.sink.add(value));
  }

  Future<List<GtdBannerRs>> loadBanner({required int bannerTaxonomy, required int bannerDevice}) async {
    final result =
        await GtdUtilityRepository.shared.getCmsBanners(bannerTaxonomy: bannerTaxonomy, bannerDevice: bannerDevice);
    if (!_isDisposed) {
      emit(HomeBannerInitial());
    }

    return result.when((success) {
      return success;
    }, (error) => []);
  }

  @override
  Future<void> close() {
    _sponsorController.close();
    _hotelController.close();
    _comboController.close();
    _promotionController.close();
    _topBannerController.close();
    _interestController.close();
    _chillController.close();
    _isDisposed = true;
    return super.close();
  }
}
