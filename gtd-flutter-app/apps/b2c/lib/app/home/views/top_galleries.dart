import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';

class TopGalleries extends StatefulWidget{
  const TopGalleries({super.key});

  @override
  TopGalleriesState createState()=> TopGalleriesState();
}
class TopGalleriesState extends State<TopGalleries> {
  int currentH = 0;

  @override
  Widget build(BuildContext context) {
    List<int> list = [1];
    return Container(
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
              aspectRatio: 3/1
            ),
            items: list.map((item) => Container(
                child: Image.asset(
                  'assets/images/demo/banner-top-demo.jpg',
                  fit: BoxFit.cover,
                ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}