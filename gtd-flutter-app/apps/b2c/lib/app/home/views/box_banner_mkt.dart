import 'package:flutter/material.dart';

class BoxBannerMkt extends StatelessWidget {
  const BoxBannerMkt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            title: Text('Khách sạn Hot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
            trailing: Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 10,),
          Image.asset(
            'assets/images/demo/card-demo-promotion-large.png',
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(
              "Tài trợ bởi Gotadi",
              style: TextStyle(
                  color: Color.fromRGBO(133, 133, 133, 1),
                  fontSize: 12
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: Row(
                children: List.generate(4, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset(
                      'assets/images/demo/banner-mkt-small.png',
                    ),
                  );
                }),
              ),
            )
          )
        ],
      ),
    );
  }
}