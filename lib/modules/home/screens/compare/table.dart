import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/models/compare_property_data.dart';
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
    'Project Name',
    'Builder Name',
    'Project Type',
    'Location',
    'Approvals',
    'Project Size',
    'No of Units',
    'No of Floors',
    'No of Towers',
    'Open space',
    'Configurations',
    'Flat Sizes',
    'Possession',
    'Club House',
    'Base Price',
    'Construction',
    '',
    '',
  ];

  Widget _buildOption(Widget icon, String text, VoidCallback onTap,
      {int delay = 0}) {
    return Animate(
      effects: [
        FadeEffect(
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
        SlideEffect(
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          begin: const Offset(0, 1),
        ),
      ],
      child: InkWell(
        onTap: () {
          _removeOverlay();
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 12),
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.all(14),
                child: icon),
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
    final Size size = renderBox.size;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate the menu dimensions
    const double menuWidth = 220.0;
    const double menuHeight = 150.0;

    // Calculate the best position for the menu
    double left = position.dx - menuWidth + size.width;
    double top = position.dy + size.height;

    // Adjust horizontal position if it goes off-screen
    if (left < 0) {
      left = 0;
    } else if (left + menuWidth > screenSize.width) {
      left = screenSize.width - menuWidth;
    }

    // Adjust vertical position if it goes off-screen
    if (top + menuHeight > screenSize.height) {
      top = position.dy - menuHeight - 65;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          Positioned(
            left: left,
            top: top,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: menuWidth,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildOption(
                      SvgPicture.asset("assets/icons/phone.svg",
                          color: CustomColors.blue),
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
                        child: SvgPicture.asset(
                          "assets/icons/whatsapp.svg",
                          color: CustomColors.green,
                        ),
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
                      delay: 100,
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
                      delay: 200,
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
      _enquiryDetails.text =
          'Hi. I am interested in your property. Please share more details on this project.';
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "----------- ${widget.comparedProperties.map((e) => e.projectId).join(", ")}");
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
                          height: 77,
                          width: double.infinity,
                          color: CustomColors.white,
                        ),
                        ...List.generate(
                          attributes.length,
                          (index) => Container(
                            height: 38,
                            width: double.infinity,
                            color: index % 2 == 0
                                ? CustomColors.white
                                : CustomColors.black.withOpacity(0.05),
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
                    dataRowMinHeight: 38,
                    dataRowMaxHeight: 38,
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
      (ComparePropertyData d) => Text(d.builderName),
      (ComparePropertyData d) => Text(d.projectType),
      (ComparePropertyData d) => Text(d.projectLocation),
      (ComparePropertyData d) => Text(d.RERAApproval),
      (ComparePropertyData d) => Text(d.projectSize),
      (ComparePropertyData d) => Text(d.noOfTowers),
      (ComparePropertyData d) => Text(d.noOfFloors),
      (ComparePropertyData d) => Text(d.noOfTowers),
      (ComparePropertyData d) => Text(d.totalOpenSpace),
      (ComparePropertyData d) => Text(d.configTitle),
      (ComparePropertyData d) => Text(d.flatSizes.toString()),
      (ComparePropertyData d) => Text(d.projectPossession.isEmpty
          ? ''
          : d.projectPossession.substring(0, 10)),
      (ComparePropertyData d) => Text(d.Clubhousesize),
      (ComparePropertyData d) => Text(d.budgetText),
      (ComparePropertyData d) => Text(d.constructionType),
      (ComparePropertyData d) => SizedBox(
            height: 30,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                side: const BorderSide(color: CustomColors.primary),
                backgroundColor: CustomColors.primary10,
              ),
              onPressed: () {
                if (ref.read(userProvider).token.isEmpty) {
                  errorSnackBar(context, 'Please login first');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(
                        goBack: true,
                      ),
                    ),
                  );
                } else {
                  final RenderBox renderBox =
                      _globalKeys[_comparedPropertyData.indexOf(d)]
                          .currentContext!
                          .findRenderObject() as RenderBox;
                  _showOverlay(
                    context,
                    renderBox,
                    widget.comparedProperties
                        .firstWhere((e) => e.name == d.name),
                  );
                }
              },
              child: const Text(
                'Contact',
                style: TextStyle(color: CustomColors.primary, fontSize: 12),
              ),
            ),
          ),
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
                    size: 18,
                  )
                : const Icon(
                    Icons.favorite_outline,
                    color: CustomColors.primary,
                    size: 18,
                  ),
            label: const Text(
              'Favourite',
              style: TextStyle(fontSize: 12),
            ),
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
              size: 18,
            ),
            label: const Text(
              'Remove',
              style: TextStyle(fontSize: 12),
            ),
          ),
    ];

    return List.generate(propertyFields.length, (index) {
      return DataRow(
        color: WidgetStateProperty.all(
          index % 2 == 0
              ? CustomColors.black.withOpacity(0.05)
              : CustomColors.white,
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
