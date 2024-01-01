import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

class FlightHeaderInfo extends StatelessWidget {
  final String title;
  final String subTitle;
  const FlightHeaderInfo({super.key, this.title = "", this.subTitle = ""});

  @override
  Widget build(BuildContext context) {
    return Material(
      // elevation: 0,
      color: Colors.white,
      child: Ink(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 3),
          child: GestureDetector(
            onTap: null,
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GtdImage.svgFromSupplier(
                    assetName: "assets/icons/flight/plane.svg", color: Colors.black, height: 25),
                // child: GtdGradientSvg(
                //   image: GtdImage.svgFromSupplier(assetName: "assets/icons/flight/plane.svg", color: Colors.black),
                //   width: 25,
                //   height: 25,
                //   gradient: GtdColors.appGradient(context),
                // ),
              ),
              title:
                  Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade900)),
              subtitle: Text(
                subTitle,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey.shade500),
              ),
              // trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
            ),
          ),
        ),
      ),
    );
  }
}
