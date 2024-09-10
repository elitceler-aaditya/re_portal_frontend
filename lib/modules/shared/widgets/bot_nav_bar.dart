import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/bot_nav_bar.dart';

class CustomBottomNavBar extends ConsumerStatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: CustomColors.white,
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                ref.read(navBarIndexProvider.notifier).setNavBarIndex(0);
              },
              child: Container(
                height: 80,
                color: CustomColors.white,
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: ref.watch(navBarIndexProvider) == 0
                    ? SvgPicture.asset(
                        'assets/icons/home_active.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/home.svg',
                      ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                ref.read(navBarIndexProvider.notifier).setNavBarIndex(1);
              },
              child: Container(
                height: 80,
                color: CustomColors.white,
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: ref.watch(navBarIndexProvider) == 1
                    ? SvgPicture.asset(
                        'assets/icons/compare_active.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/compare.svg',
                      ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                ref.read(navBarIndexProvider.notifier).setNavBarIndex(2);
              },
              child: Container(
                height: 80,
                color: CustomColors.white,
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: ref.watch(navBarIndexProvider) == 2
                    ? SvgPicture.asset(
                        'assets/icons/like_active.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/like.svg',
                      ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                ref.read(navBarIndexProvider.notifier).setNavBarIndex(3);
              },
              child: Container(
                height: 80,
                color: CustomColors.white,
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: ref.watch(navBarIndexProvider) == 3
                    ? SvgPicture.asset(
                        'assets/icons/person_active.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/person.svg',
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
