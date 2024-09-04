import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_grid_view.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_list_view.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class PropertyList extends ConsumerStatefulWidget {
  final List<AppartmentModel> apartments;
  final bool compare;
  final bool displayAds;
  const PropertyList(
      {super.key,
      required this.apartments,
      this.compare = false,
      this.displayAds = false});

  @override
  ConsumerState<PropertyList> createState() => _PropertState();
}

class _PropertState extends ConsumerState<PropertyList> {
  bool isListview = true;
  List<AppartmentModel> sortedApartments = [];

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                title: Text(
                  'SORT BY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.black,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Popularity'),
                onTap: () {
                  setState(() {
                    sortedApartments = widget.apartments;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price - low to high'),
                onTap: () {
                  setState(() {
                    sortedApartments = List.from(widget.apartments)
                      ..sort((a, b) => a.budget.compareTo(b.budget));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price - high to low'),
                onTap: () {
                  setState(() {
                    sortedApartments = List.from(widget.apartments)
                      ..sort((b, a) => a.budget.compareTo(b.budget));
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    sortedApartments.addAll(widget.apartments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Main body
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      onPressed: () {
                        _showSortBottomSheet(context);
                      },
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
              isListview
                  ? PropertyListView(
                      sortedApartments: sortedApartments,
                      compare: widget.compare,
                      displayAds: widget.displayAds,
                    )
                  : PropertyGridView(
                      sortedApartments: sortedApartments,
                      compare: widget.compare,
                    )
            ],
          ),
        ),
      ],
    );
  }
}
