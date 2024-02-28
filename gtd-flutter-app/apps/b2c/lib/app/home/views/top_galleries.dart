import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/banner_resource/banner_resource.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:new_gotadi/app/home/cubit/home_banner_cubit.dart';
import 'package:new_gotadi/app/home/view_model/box_banner_mkt_view_model.dart';

class TopGalleries extends StatefulWidget {
  final List<String> imageUrls;
  const TopGalleries({super.key, this.imageUrls = const []});

  @override
  TopGalleriesState createState() => TopGalleriesState();
}

class TopGalleriesState extends State<TopGalleries> {
  int currentH = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBannerCubit, HomeBannerState>(
      builder: (context, state) {
        return StreamBuilder<List<GtdBannerRs>>(
            stream: BlocProvider.of<HomeBannerCubit>(context).topBannerStream,
            initialData: const [],
            builder: (context, snapshot) {
              List<String> list = (snapshot.data ?? []).map((e) => e.imageUrl).whereType<String>().toList();
              if (list.isEmpty) {
                return ColoredBox(
                  color: AppColors.mainColor,
                  child: const SizedBox(
                    height: 120,
                    width: double.infinity,
                  ),
                );
              }
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ExpandablePageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      currentH = index;
                    });
                  },
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return CarouselSlider(
                      options: CarouselOptions(
                          initialPage: 0,
                          viewportFraction: 1,
                          enlargeCenterPage: false,
                          aspectRatio: 3 / 1,
                          autoPlay: true),
                      items: list
                          .map(
                            (item) => SizedBox(
                              child: GtdImage.cachedImgUrlWithPlaceholder(url: item, fit: BoxFit.cover),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              );
            });
      },
    );
  }
}
