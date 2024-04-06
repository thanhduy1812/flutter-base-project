import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/banner_resource/banner_resource.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_shimmer.dart';
import 'package:new_gotadi/app/home/cubit/home_banner_cubit.dart';
import 'package:new_gotadi/app/home/view_model/box_banner_mkt_view_model.dart';
import 'package:new_gotadi/app/home/views/box_banner_mkt.dart';
import 'package:new_gotadi/app/promotions/view_model/promotion_page_view_model.dart';

class PromotionPage extends BaseStatelessPage<PromotionPageViewModel> {
  static const String route = '/promotionPage';
  const PromotionPage({super.key, required super.viewModel});
  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    return null;
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: BlocProvider(
          create: (context) => HomeBannerCubit()..loadPromotionBanners(isFristLoad: viewModel.isFristLoad),
          child: BlocBuilder<HomeBannerCubit, HomeBannerState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  viewModel.isFristLoad = false;
                  BlocProvider.of<HomeBannerCubit>(context)
                      .loadPromotionBanners(isFristLoad: viewModel.isFristLoad, isRefresh: true);
                },
                child: CustomScrollView(
                  slivers: [
                    ...((state is HomeBannerLoading) ? [_loadingItems()] : _listBannerBody(context)),
                  ],
                ),
              );
            },
          ),
        ),
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
            itemCount: 7),
      ),
    );
  }

  List<Widget> _listBannerBody(BuildContext context) {
    return [
      //Hotel Banner
      SliverToBoxAdapter(
        child: StreamBuilder<List<GtdBannerRs>>(
            stream: BlocProvider.of<HomeBannerCubit>(context).hotelStream,
            initialData: viewModel.hotelBanners,
            builder: (context, snapshot) {
              viewModel.hotelBanners = snapshot.data ?? [];
              viewModel.isFristLoad = true;
              if (snapshot.data?.isEmpty == true) {
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
            initialData: viewModel.comboBanners,
            builder: (context, snapshot) {
              viewModel.comboBanners = snapshot.data ?? [];
              viewModel.isFristLoad = true;
              if (snapshot.data?.isEmpty == true) {
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
              if (snapshot.data?.isEmpty == true) {
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
}
