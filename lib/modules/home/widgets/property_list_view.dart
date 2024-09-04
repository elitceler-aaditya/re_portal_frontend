import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/widgets/ribbon.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyListView extends ConsumerWidget {
  final List<AppartmentModel> sortedApartments;
  final bool compare;

  const PropertyListView({
    super.key,
    required this.sortedApartments,
    required this.compare,
  });

  formatBudget(double budget) {
    if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedApartments.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColors.white,
            boxShadow: const [
              BoxShadow(
                color: CustomColors.black10,
                offset: Offset(0, 3),
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    Hero(
                      tag: sortedApartments[index].apartmentID,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: CustomColors.black25,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(sortedApartments[index].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.secondary.withOpacity(0),
                            CustomColors.secondary.withOpacity(0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 0,
                      child: CustomPaint(
                        painter: RibbonPainter(CustomColors.primary),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: const Text(
                            'RERA Approved',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_outline,
                            color: CustomColors.white,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          sortedApartments[index].apartmentName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CustomColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "This beautiful property lies in the heart of Hyderabad with xx acres of free space. It is a perfect place for a peaceful life.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CustomColors.black50,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(
                                text: "Area: ",
                                style: TextStyle(
                                  color: CustomColors.black75,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${sortedApartments[index].flatSize.toStringAsFixed(0)} sq.ft",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black, // Default text color
                            ),
                            children: [
                              const TextSpan(
                                text: "Cost: ",
                                style: TextStyle(
                                  color: CustomColors.black75,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: formatBudget(
                                    sortedApartments[index].budget),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (compare)
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: IconButton.filled(
                                    style: IconButton.styleFrom(
                                      backgroundColor: ref
                                              .watch(comparePropertyProvider)
                                              .contains(sortedApartments[index])
                                          ? CustomColors.green10
                                          : CustomColors.primary20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (!ref
                                          .watch(comparePropertyProvider)
                                          .contains(sortedApartments[index])) {
                                        if (ref
                                                .read(comparePropertyProvider)
                                                .length >=
                                            4) {
                                          errorSnackBar(context,
                                              "You can compare up to 4 properties");
                                        } else {
                                          ref
                                              .read(comparePropertyProvider
                                                  .notifier)
                                              .addApartment(
                                                  sortedApartments[index]);
                                        }
                                      } else {
                                        ref
                                            .read(comparePropertyProvider
                                                .notifier)
                                            .removeApartment(
                                                sortedApartments[index]);
                                      }
                                    },
                                    icon: !ref
                                            .watch(comparePropertyProvider)
                                            .contains(sortedApartments[index])
                                        ? SvgPicture.asset(
                                            "assets/icons/compare.svg",
                                            color: CustomColors.primary,
                                            height: 20,
                                            width: 20)
                                        : const Icon(
                                            Icons.check,
                                            color: CustomColors.green,
                                          ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: IconButton.filled(
                                  style: IconButton.styleFrom(
                                    backgroundColor: CustomColors.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    final Uri phoneUri = Uri(
                                        scheme: 'tel',
                                        path: sortedApartments[index]
                                            .companyPhone);

                                    launchUrl(phoneUri);
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/icons/phone.svg",
                                      color: CustomColors.white,
                                      height: 20,
                                      width: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}