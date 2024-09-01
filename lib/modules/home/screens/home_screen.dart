import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/home/screens/appartment_filter.dart';
import 'package:re_portal_frontend/modules/home/screens/property_list.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/models/property_type.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String token = "";
  List<AppartmentModel> _apartments = [];

  checkValidSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token') ?? '';
  }

  getProperties() async {
    String token = ref.watch(userProvider).token;
    debugPrint("--------------token: $token");
    if (ref.watch(homeDataProvider).propertyType == PropertyTypes.appartments) {
      await getApartments(token: token);
    } else if (ref.watch(homeDataProvider).propertyType ==
        PropertyTypes.villas) {
      return "Villas";
    } else if (ref.watch(homeDataProvider).propertyType ==
        PropertyTypes.commercial) {
      return "Commercial";
    }
  }

  Future<void> getApartments({
    String token = "",
    Map<String, dynamic> params = const {},
  }) async {
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/project/filterApartments";
    debugPrint("--------------url: $url");
    Uri uri = Uri.parse(url).replace(queryParameters: params);

    http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
      },
    ).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
        List responseBody = jsonDecode(response.body)['apartments'];
        debugPrint("--------------responseBody: $responseBody");
        setState(() {
          _apartments = responseBody
              .map<AppartmentModel>((e) => AppartmentModel.fromJson(e))
              .toList();
        });
      }
    });
  }

  filterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      isScrollControlled: true,
      backgroundColor: CustomColors.white,
      scrollControlDisabledMaxHeightRatio: 1,
      builder: (context) {
        return const AppartmentFilter();
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkValidSession();
      getProperties();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(token);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        titleSpacing: 0,
        iconTheme: const IconThemeData(
          color: CustomColors.white,
        ),
        title: Text(
          ref.watch(homeDataProvider).propertyType,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: CustomColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //top search bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.primary,
                    Color(0xFFCE4F32),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  //search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText:
                                  'Search for ${ref.watch(homeDataProvider).propertyType.toLowerCase()}',
                              hintStyle: const TextStyle(
                                color: CustomColors.black50,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        if (_searchController.text.trim().isEmpty)
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset("assets/icons/location.svg"),
                          ),
                        if (_searchController.text.trim().isEmpty)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: CustomColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              filterBottomSheet();
                            },
                            icon: SvgPicture.asset("assets/icons/filter.svg"),
                            label: const Text(
                              "Filters",
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            //Best deals
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Best Deals",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FlutterCarousel.builder(
                    itemCount: 3,
                    itemBuilder: (context, index, realIndex) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            barrierDismissible: true,
                            pageBuilder: (BuildContext context, _, __) {
                              return Hero(
                                tag: "best_deal_$index",
                                child: Scaffold(
                                  backgroundColor: Colors.black54,
                                  body: Center(
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            SizedBox(
                                              height: 180,
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(10)),
                                                child: Image.asset(
                                                  "assets/images/best_deal.png",
                                                  fit: BoxFit.cover,
                                                  height: 200,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Balaji Heights",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "This beautiful property lies in the heart of Hyderabad with xx acres of free space",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Hero(
                        tag: "best_deal_$index",
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomColors.black25,
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/best_deal.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    options: CarouselOptions(
                      height: 180,
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 1000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      initialPage: 0,
                      reverse: false,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                ],
              ),
            ),
            PropertyList(apartments: _apartments),
          ],
        ),
      ),
    );
  }
}
