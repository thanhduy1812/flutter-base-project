import 'package:card_swiper/card_swiper.dart';
import 'package:cctv_stream_app/core/animations/fade_animation.dart';
import 'package:cctv_stream_app/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilmSliderView extends StatefulWidget {
  const FilmSliderView({super.key});

  @override
  State<FilmSliderView> createState() => _FilmSliderViewState();
}

class _FilmSliderViewState extends State<FilmSliderView> {
  // late PlaceModel current_place;
  late List<String> films;
  late String currentFilm;
  int seletedindex = 0;

  @override
  void initState() {
    films = Iterable<int>.generate(4).map((e) => "assets/images/main_img_${e + 1}.jpg").toList();
    currentFilm = films[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.sizeOf(context);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.45 + 50,
          // width: 500,
          child: FadeAnimation(
            begin: 0.01,
            end: 1,
            duration: const Duration(seconds: 1),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Swiper(
                  itemWidth: screenSize.width / 1.1,
                  itemHeight: screenSize.width / 1,
                  itemCount: films.length,
                  scrollDirection: Axis.horizontal,
                  autoplay: true,
                  viewportFraction: 0.75,
                  scale: 0.8,
                  onIndexChanged: (value) {
                    setState(() {
                      currentFilm = films[seletedindex];
                    });
                  },
                  onTap: (index) {
                    context.push(Routes.checkoutscreen.path, extra: films[index]);
                  },
                  itemBuilder: (context, index) {
                    seletedindex = index;
                    var data = films[index];
                    return ImageCard(
                      model: data,
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  final String model;
  const ImageCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.shade500, // Set the color of the border
          width: 1, // Set the width of the border
        ),
        borderRadius: BorderRadius.circular(8.0), // Set the border radius
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              width: 200,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                model,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
