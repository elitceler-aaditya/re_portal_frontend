import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/models/compare_property_data.dart';
import 'package:re_portal_frontend/modules/home/screens/main_screen.dart';
import 'package:re_portal_frontend/modules/onboarding/screens/login_screen.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/snackbars.dart';
import 'package:re_portal_frontend/riverpod/compare_appartments.dart';
import 'package:re_portal_frontend/riverpod/saved_properties.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FixedColumnDataTable extends ConsumerStatefulWidget {
  final List<ApartmentModel> comparedProperties;
  final List<ComparePropertyData> comparedPropertyData;
  final bool isFixedColumnVisible;
  final Function() onHideFixedColumn;
  final ScrollController horizontalController;

  const FixedColumnDataTable(
      {super.key,
      required this.comparedProperties,
      required this.comparedPropertyData,
      this.isFixedColumnVisible = true,
      required this.horizontalController,
      required this.onHideFixedColumn});

  @override
  ConsumerState<FixedColumnDataTable> createState() =>
      _FixedColumnDataTableState();
}

class _FixedColumnDataTableState extends ConsumerState<FixedColumnDataTable> {
  List<ComparePropertyData> _comparedPropertyData = [];
  bool _isOverlayVisible = false;
  OverlayEntry? _overlayEntry;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _enquiryDetails = TextEditingController();

  List attributes = [
    'Name',
    'Type',
    'Flat size',
    'Approval',
    'Project size',
    'Configuration',
    'Floors',
    'Possession',
    'Base price',
    'Club size',
    'Open area',
    'Cost',
    'Favourite',
    '',
    '',
  ];

  Widget _buildOption(Widget icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        _removeOverlay();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(text),
          ],
        ),
      ),
    );
  }

  List<GlobalKey> _globalKeys = [];

  void _toggleOverlay(
      BuildContext context, GlobalKey key, ApartmentModel apartment) {
    if (_isOverlayVisible) {
      _removeOverlay();
    } else {
      _showOverlay(context, key.currentContext!.findRenderObject() as RenderBox,
          apartment);
    }
  }

  void _showOverlay(
      BuildContext context, RenderBox renderBox, ApartmentModel apartment) {
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size screenSize = MediaQuery.of(context).size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            left: _calculateLeftPosition(position.dx, screenSize.width),
            top: _calculateTopPosition(position.dy, screenSize.height),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 220,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOption(
                      SvgPicture.asset("assets/icons/phone.svg"),
                      'Call now',
                      () {
                        if (ref.read(userProvider).token.isNotEmpty) {
                          launchUrlString("tel:${apartment.companyPhone}")
                              .then((value) => _removeOverlay());
                        } else {
                          enquiryFormPopup().then((_) {
                            _removeOverlay();
                          });
                        }
                      },
                    ),
                    _buildOption(
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset("assets/icons/whatsapp.svg"),
                      ),
                      'Chat on Whatsapp',
                      () {
                        if (ref.read(userProvider).token.isNotEmpty) {
                          launchUrlString(
                            'https://wa.me/+91${apartment.companyPhone}?text=${Uri.encodeComponent("Hello, I'm interested in your property")}',
                          ).then((value) => _removeOverlay());
                        } else {
                          enquiryFormPopup().then((_) {
                            _removeOverlay();
                          });
                        }
                      },
                    ),
                    _buildOption(
                      SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            SvgPicture.asset("assets/icons/phone_incoming.svg"),
                      ),
                      'Request call back',
                      () {
                        enquiryFormPopup();
                        _removeOverlay();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOverlayVisible = true;
    });
  }

  double _calculateLeftPosition(double dx, double screenWidth) {
    const overlayWidth = 220.0;
    if (dx + overlayWidth > screenWidth) {
      return screenWidth - overlayWidth - 10;
    } else if (dx < 10) {
      return 10;
    }
    return dx;
  }

  double _calculateTopPosition(double dy, double screenHeight) {
    const overlayHeight = 150.0;
    if (dy + overlayHeight > screenHeight) {
      return screenHeight + overlayHeight - 10;
    } else if (dy < 10) {
      return 10;
    }
    return dy;
  }

  Future<void> enquiryFormPopup() async {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Wrap(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 30),
                            const Text(
                              'Enquiry Form',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  label: Text("Name"),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  focusColor: CustomColors.black,
                                  labelStyle: TextStyle(
                                    color: CustomColors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _mobileController,
                                decoration: const InputDecoration(
                                  label: Text('Mobile'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  focusColor: CustomColors.black,
                                  labelStyle: TextStyle(
                                    color: CustomColors.black,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  label: Text('Email'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  focusColor: CustomColors.black,
                                  labelStyle: TextStyle(
                                    color: CustomColors.black,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _enquiryDetails,
                                textAlign: TextAlign.start,
                                decoration: const InputDecoration(
                                  label: Text('Enquire about your doubts'),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  focusColor: CustomColors.black,
                                  labelStyle: TextStyle(
                                    color: CustomColors.black,
                                  ),
                                ),
                                minLines: 1,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // sendEnquiry(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayVisible = false;
  }

  formatBudget(int budget) {
    if (budget < 10000000) {
      return "₹${(budget / 100000).toStringAsFixed(2)} L";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)} Cr";
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _comparedPropertyData = widget.comparedPropertyData;
    _globalKeys = List.generate(
        widget.comparedPropertyData.length, (index) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = ref.read(userProvider).name;
      _mobileController.text = ref.read(userProvider).phoneNumber;
      _emailController.text = ref.read(userProvider).email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Column
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: widget.isFixedColumnVisible ? 130 : 0,
              curve: Curves.easeInOut,
              child: !widget.isFixedColumnVisible
                  ? const SizedBox()
                  : Column(
                      children: [
                        Container(
                          height: 79,
                          width: double.infinity,
                          color: CustomColors.white,
                        ),
                        ...List.generate(
                          attributes.length,
                          (index) => Container(
                            height: 36,
                            width: double.infinity,
                            color: index % 2 == 0
                                ? CustomColors.white
                                : CustomColors.primary10,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                attributes[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            // Scrollable Columns
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: widget.horizontalController,
                child: SingleChildScrollView(
                  child: DataTable(
                    dividerThickness: 0,
                    headingRowHeight: 115,
                    columnSpacing: 16,
                    dataRowMinHeight: 36,
                    dataRowMaxHeight: 36,
                    columns: _buildScrollableColumns(),
                    rows: _buildScrollableRows(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<DataColumn> _buildScrollableColumns() {
    return _comparedPropertyData
        .map((prop) => DataColumn(
              label: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: 120,
                    margin: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.comparedProperties
                            .where((e) => e.name == prop.name)
                            .first
                            .coverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      prop.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  List<DataRow> _buildScrollableRows() {
    final propertyFields = [
      (ComparePropertyData d) => Text(d.projectType),
      (ComparePropertyData d) => Text("${d.flatSizes} sq.ft"),
      (ComparePropertyData d) =>
          Text(d.rERAApproval ? 'RERA approved' : 'Not approved'),
      (ComparePropertyData d) => Text("${d.projectSize} sq.ft"),
      (ComparePropertyData d) =>
          Text(d.unitPlanConfigs.map((e) => e.BHKType).join(', ')),
      (ComparePropertyData d) => Text("${d.noOfFloors} floors"),
      (ComparePropertyData d) => Text(d.projectPossession.isEmpty
          ? ''
          : d.projectPossession.substring(0, 10)),
      (ComparePropertyData d) => Text("₹${d.pricePerSquareFeetRate}/sq.ft"),
      (ComparePropertyData d) => Text("${d.clubhousesize} sq.ft"),
      (ComparePropertyData d) => Text(d.totalOpenSpace),
      (ComparePropertyData d) => Text(formatBudget(d.budget)),
      (ComparePropertyData d) => TextButton.icon(
            key: _globalKeys[_comparedPropertyData.indexOf(d)],
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              ApartmentModel apartment = widget.comparedProperties
                  .where((e) => e.name == d.name)
                  .first;

              ref.read(savedPropertiesProvider).contains(apartment)
                  ? {
                      errorSnackBar(
                          context, 'Property removed from favourites'),
                      ref
                          .read(savedPropertiesProvider.notifier)
                          .removeApartment(apartment)
                    }
                  : {
                      successSnackBar(context, 'Property added to favourites'),
                      ref
                          .read(savedPropertiesProvider.notifier)
                          .addApartment(apartment)
                    };
              setState(() {});
            },
            icon: ref.read(savedPropertiesProvider).contains(widget
                    .comparedProperties
                    .where((e) => e.name == d.name)
                    .first)
                ? const Icon(
                    Icons.favorite,
                    color: CustomColors.primary,
                    size: 20,
                  )
                : const Icon(
                    Icons.favorite_outline,
                    color: CustomColors.primary,
                    size: 20,
                  ),
            label: const Text('Favourite'),
          ),
      (ComparePropertyData d) => TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              if (ref.read(userProvider).token.isEmpty) {
                errorSnackBar(context, 'Please login first');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(
                      redirectTo: MainScreen(),
                    ),
                  ),
                );
              } else {
                _toggleOverlay(
                  context,
                  _globalKeys[_comparedPropertyData.indexOf(d)],
                  widget.comparedProperties
                      .where((e) => e.name == d.name)
                      .first,
                );
              }
            },
            icon: const Icon(
              Icons.phone,
              color: CustomColors.primary,
              size: 16,
            ),
            label: const Text('Contact'),
          ),
      (ComparePropertyData d) => TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              final apartment =
                  widget.comparedProperties.firstWhere((e) => e.name == d.name);
              ref
                  .read(comparePropertyProvider.notifier)
                  .removeApartment(apartment);
              setState(() {
                _comparedPropertyData.removeWhere((e) => e.name == d.name);
              });
            },
            icon: const Icon(
              Icons.close,
              color: CustomColors.primary,
              size: 20,
            ),
            label: const Text('Remove'),
          ),
    ];

    return List.generate(propertyFields.length, (index) {
      return DataRow(
        color: WidgetStateProperty.all(
          index % 2 == 0 ? CustomColors.primary10 : CustomColors.white,
        ),
        cells: List.generate(_comparedPropertyData.length, (dataIndex) {
          return DataCell(
            propertyFields[index](
              _comparedPropertyData[dataIndex],
            ),
          );
        }),
      );
    });
  }
}
