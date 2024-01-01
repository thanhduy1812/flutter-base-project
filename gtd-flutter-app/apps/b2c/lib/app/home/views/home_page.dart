import 'package:new_gotadi/app/home/views/box_banner_mkt.dart';
import 'package:new_gotadi/app/home/views/box_search_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String route = '/home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static bool _isDark(final Color color) => ThemeData.estimateBrightnessForColor(color) == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            backgroundColor: _isDark(theme.colorScheme.surface) ? null : const Color.fromRGBO(19, 172, 82, 1),
            elevation: 0,
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _isDark(theme.colorScheme.surface)
                  ? SvgPicture.asset("assets/images/logo_b2c_dark.svg", width: 200)
                  : SvgPicture.asset("assets/images/logo_b2c.svg", width: 200),
            ),
            leadingWidth: 110,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Notifications',
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            // TopGalleries(),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: BoxSearchHeaderDelegate(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => const Card(
                  color: Colors.transparent,
                  margin: EdgeInsets.all(10),
                  child: BoxBannerMkt(),
                ),
                childCount: 2,
              ),
            ),
          ],
        ));
  }
}
