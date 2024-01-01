import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:shimmer/shimmer.dart';

class MyBookingListLoading<T> extends StatelessWidget {
  final int? itemNumber;
  final bool? isScroll;

  const MyBookingListLoading({
    super.key,
    this.itemNumber = 1,
    this.isScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: (isScroll!) ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
        itemCount: itemNumber,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    spreadRadius: .2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ]),
            child: myBookingItemLoadingWidget(),
          );
        });
  }

  static Shimmer myBookingItemLoadingWidget() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade50,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GtdImage.svgFromSupplier(assetName: 'assets/icons/point-connect.svg'),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Container(
                      width: 130,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GtdButton(
                    onPressed: (val) {},
                    text: 'Chờ thanh toán',
                    height: 30,
                    colorText: Colors.grey.shade900,
                    borderRadius: 100,
                    color: Colors.grey.shade100,
                    fontSize: 12,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              )
            ],
          ),
        ));
  }
}
