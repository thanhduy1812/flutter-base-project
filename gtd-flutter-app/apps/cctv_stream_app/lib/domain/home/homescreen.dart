import 'package:card_swiper/card_swiper.dart';
import 'package:cctv_stream_app/core/animations/fade_animation.dart';
import 'package:cctv_stream_app/core/common_color/common_color.dart';
import 'package:cctv_stream_app/core/common_style/master_painter.dart';
import 'package:cctv_stream_app/domain/home/film_slider_view.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../short_video/video_player_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> filmNames = ["Tâm lý", "Tình cảm", "Phạm tội", "Kinh dị", "Kinh hãi", "Kinh khủng"];

  List<Widget> filmWidgets = [
    // const MoutainScreen(),
    // const Beach_Screen(),
    // const HotelScreen(),
    // const Restaurant_Screen(),
    const FilmSliderView(),
    const Center(child: Text("a")),
    const Center(child: Text("a")),
    const Center(child: Text("a")),
    const Center(child: Text("a")),
    const Center(child: Text("a")),
  ];
  int selectedCategory = 0;

  //Navigation
  final PageController _pageController = PageController();
  int selectedPage = 0;
  bool _isBottomBarVisible = true;

  void _onPageChanged(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondrycolor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: CustomPaint(
          painter: MasterPainter(),
          child: Padding(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: selectedPage == 1 ? 0 : 50,
                ),
                selectedPage == 1
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FadeAnimation(
                              duration: Duration(seconds: 1),
                              begin: 0.1,
                              end: 0.9,
                              child: Text(
                                "CCTV",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 50),
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: FadeAnimation(
                                  duration: const Duration(seconds: 1),
                                  begin: 0.1,
                                  end: 0.9,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black, width: 2.0),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      hintText: 'Tìm kiếm film theo từ khoá',
                                      // You can customize the placeholder text style if needed
                                      hintStyle: const TextStyle(color: Colors.grey),
                                    ),
                                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                SizedBox(
                  height: selectedPage == 1 ? 0 : 10,
                ),
                Expanded(
                    child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _homeBodyView(context),
                    ColoredBox(
                      color: Colors.black,
                      child: Swiper(
                        itemCount: 8,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                _isBottomBarVisible = !_isBottomBarVisible;
                              });
                            },
                            child: VideoPlayerScreen(indexVideo: index)),
                        scrollDirection: Axis.vertical,
                        // pagination: const SwiperPagination(alignment: Alignment.centerRight),
                        control: const SwiperControl(color: Colors.transparent, size: 11),
                      ),
                    ),
                    const Center(child: Text("aa")),
                    const Center(child: Text("aa"))
                  ],
                )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(microseconds: 300),
          transform: Matrix4.translationValues(0, _isBottomBarVisible ? 0 : 110, 0),
          // height: _isBottomBarVisible ? 110 : 0,
          child: Visibility(
            visible: _isBottomBarVisible,
            child: SizedBox(
              height: 110,
              child: CustomNavigationBar(
                iconSize: 22.0,
                bubbleCurve: Curves.linear,
                selectedColor: Colors.white,
                strokeColor: Colors.white,
                unSelectedColor: const Color(0xffacacac),
                backgroundColor: primarycolor,
                borderRadius: const Radius.circular(50),
                // blurEffect: true,
                isFloating: true,
                scaleFactor: 0.1,
                items: [
                  CustomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.home),
                      title: const Text("Discover", style: TextStyle(color: Colors.white, fontSize: 12))),
                  CustomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.play_circle),
                      title: const Text("Shorts", style: TextStyle(color: Colors.white, fontSize: 12))),
                  CustomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.square_line_vertical_square),
                      title: const Text("Trending", style: TextStyle(color: Colors.white, fontSize: 12))),
                  CustomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.person),
                      title: const Text("Profile", style: TextStyle(color: Colors.white, fontSize: 12))),
                ],
                onTap: _onItemTapped,
                currentIndex: selectedPage,
              ),
            ),
          ),
        ));
  }

  Widget _homeBodyView(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: filmNames.length,
              itemBuilder: (context, index) {
                var data = filmNames[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(microseconds: 950),
                      child: Column(
                        children: [
                          Text(data,
                              style: GoogleFonts.lato(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: index == selectedCategory ? yellowcolor : Colors.white,
                              )),
                          selectedCategory == index
                              ? TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 600),
                                  tween: Tween<double>(begin: 0, end: 50),
                                  builder: (context, value, child) {
                                    return Container(
                                      height: 2,
                                      width: value,
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(30), color: yellowcolor),
                                    );
                                  },
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 420,
                // width: 420,
                child: PageView(
                  children: [
                    SizedBox(
                      // height: MediaQuery.sizeOf(context).height * 0.6,
                      width: 420,
                      child: filmWidgets[selectedCategory],
                    )
                  ],
                ),
              )),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Werewolf&Love",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 190,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) =>
                                SizedBox(child: SmallImageCard(model: "assets/images/image_${index + 1}.jpg")),
                            separatorBuilder: (context, index) => const SizedBox(
                              width: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
