import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class VerticalGridCarousel extends StatelessWidget {
  final List<Widget> items;

  const VerticalGridCarousel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 1,
        showIndicator: false,
        slideIndicator: null,
        autoPlay: true,
        pauseAutoPlayInFiniteScroll: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(seconds: 5),
        autoPlayCurve: Curves.linear,
        scrollDirection: Axis.vertical,
        enableInfiniteScroll: true,
        pauseAutoPlayOnTouch: false,
      ),
      items: [
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.7,
          children: items,
        ),
      ],
    );
  }
}
