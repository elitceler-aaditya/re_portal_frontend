import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class PropertyList extends StatefulWidget {
  final List<AppartmentModel> apartments;
  const PropertyList({super.key, required this.apartments});

  @override
  State<PropertyList> createState() => _PropertState();
}

class _PropertState extends State<PropertyList> {
  bool isListview = true;

  formatBudget(double budget) {
    if (budget < 10000000) {
      return "${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Main body
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 36,
                      width: 80,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: CustomColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: const BorderSide(
                            color: CustomColors.primary,
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.sort,
                          size: 20,
                        ),
                        label: const Text(
                          "Sort",
                          style: TextStyle(
                            color: CustomColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isListview = !isListview;
                        });
                      },
                      icon: isListview
                          ? const Icon(
                              Icons.grid_view_outlined,
                              size: 28,
                            )
                          : const Icon(
                              Icons.list,
                              size: 28,
                            ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isListview ? 1 : 2,
                  childAspectRatio: isListview ? 1.25 : 0.65,
                  crossAxisSpacing: isListview ? 16 : 10,
                  mainAxisSpacing: isListview ? 16 : 10,
                ),
                itemCount: widget.apartments.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: CustomColors.black10,
                          offset: Offset(0, 0),
                          blurRadius: 4,
                        ),
                      ],
                      color: CustomColors.white,
                      border: Border.all(
                        color: CustomColors.black25,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Stack(
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: CustomColors.black25,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        widget.apartments[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomColors.white.withOpacity(0),
                                      CustomColors.secondary,
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
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    widget.apartments[index].apartmentName,
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
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isListview)
                                  const Text(
                                    "This beautiful property lies in the heart of Hyderabad with xx acres of free space. It is a perfect place for a peaceful life.",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: CustomColors.black50,
                                    ),
                                  ),
                                Flex(
                                  direction: isListview
                                      ? Axis.horizontal
                                      : Axis.vertical,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .black, // Default text color
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: "Area: ",
                                                style: TextStyle(
                                                  color: CustomColors.black75,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: widget
                                                    .apartments[index].flatSize
                                                    .toStringAsFixed(0),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: " sq.ft",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors
                                                  .black, // Default text color
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: "Cost: ",
                                                style: TextStyle(
                                                  color: CustomColors.black75,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: formatBudget(widget
                                                    .apartments[index].budget),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: IconButton.filled(
                                          style: IconButton.styleFrom(
                                            backgroundColor:
                                                CustomColors.secondary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                              "assets/icons/call.svg",
                                              height: 20,
                                              width: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
