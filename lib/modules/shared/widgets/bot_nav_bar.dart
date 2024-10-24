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
      height: 60,
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
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
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
                height: 70,
                color: CustomColors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: ref.watch(navBarIndexProvider) == 0
                    ? SvgPicture.asset(
                        'assets/icons/home.svg',
                        color: CustomColors.primary,
                      )
                    : SvgPicture.asset(
                        'assets/icons/home.svg',
                        color: CustomColors.primary50,
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
                height: 70,
                color: CustomColors.white,
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: ref.watch(navBarIndexProvider) == 1
                    ? SvgPicture.asset(
                        'assets/icons/compare.svg',
                        color: CustomColors.primary,
                      )
                    : SvgPicture.asset(
                        'assets/icons/compare.svg',
                        color: CustomColors.primary50,
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
                height: 70,
                color: CustomColors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: ref.watch(navBarIndexProvider) == 2
                    ? SvgPicture.asset(
                        'assets/icons/like.svg',
                        color: CustomColors.primary,
                      )
                    : SvgPicture.asset(
                        'assets/icons/like.svg',
                        color: CustomColors.primary50,
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
                height: 70,
                color: CustomColors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: ref.watch(navBarIndexProvider) == 3
                    ? SvgPicture.asset(
                        'assets/icons/person.svg',
                        color: CustomColors.primary,
                      )
                    : SvgPicture.asset(
                        'assets/icons/person.svg',
                        color: CustomColors.primary50,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
