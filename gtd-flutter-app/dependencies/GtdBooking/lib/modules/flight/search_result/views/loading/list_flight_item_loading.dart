
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListFlightItemLoading<T> extends StatelessWidget {
  final int? itemNumber;
  final bool? isScroll;

  const ListFlightItemLoading({
    super.key,
    this.itemNumber = 1,
    this.isScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: (isScroll!)? const AlwaysScrollableScrollPhysics()
       : const NeverScrollableScrollPhysics(),
      itemCount: itemNumber,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
              ]
          ),
          child: flightItemLoadingWidget(),
        );
      }
    );
  }

  static Shimmer flightItemLoadingWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade50,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 32,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(4)
                            )
                          ),
                        ),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 65,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4)
                                    )
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 130,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4)
                                    )
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade100),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 20,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                width: 115,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4)
                                    )
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 16,
                                width: 80,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4)
                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Wrap(
                          runSpacing: 26,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 9,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 80,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
