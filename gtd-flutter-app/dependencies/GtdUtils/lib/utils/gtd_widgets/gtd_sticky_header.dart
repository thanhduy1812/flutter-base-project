// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class GtdStickyHeader extends StatelessWidget {
  final Widget header;
  final Widget body;
  const GtdStickyHeader({
    Key? key,
    required this.header,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StickyHeader(header: header, content: body);
  }
}
