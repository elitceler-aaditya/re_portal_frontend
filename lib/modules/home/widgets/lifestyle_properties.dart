import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/lifestyle_projects_card.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class LifestyleProperties extends ConsumerWidget {
  const LifestyleProperties({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lifestyleProperties =
        ref.watch(homePropertiesProvider).lifestyleProjects;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
          child: Text(
            "Lifestyle Properties",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: FlutterCarousel.builder(
            itemCount: lifestyleProperties.length,
            itemBuilder: (context, index, realIndex) {
              return LifestyleProjectCard(
                  lifestyleProperty: lifestyleProperties[index]);
            },
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              initialPage: 0,
              reverse: false,
              scrollDirection: Axis.horizontal,
              showIndicator: true,
              floatingIndicator: false,
              slideIndicator: const CircularSlideIndicator(
                slideIndicatorOptions: SlideIndicatorOptions(
                  indicatorRadius: 4,
                  currentIndicatorColor: CustomColors.black,
                  indicatorBackgroundColor: CustomColors.black50,
                  itemSpacing: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
