import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/builder/models/builder_model.dart';
import 'package:re_portal_frontend/modules/home/widgets/property_list_view.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:http/http.dart' as http;
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class BuilderPortfolio extends ConsumerStatefulWidget {
  final String projectId;
  const BuilderPortfolio({super.key, required this.projectId});

  @override
  ConsumerState<BuilderPortfolio> createState() => _BuilderPortfolioState();
}

class _BuilderPortfolioState extends ConsumerState<BuilderPortfolio> {
  BuilderModel builder = const BuilderModel();
  bool isLoading = true;

  Future<void> getBuilderDetails() async {
    setState(() {
      isLoading = true;
    });

    // try {
    final url = Uri.parse(
        "${dotenv.env['BASE_URL']}/user/getBuilderDetails/${widget.projectId}");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${ref.read(userProvider).token}",
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      setState(() {
        builder = BuilderModel.fromJson(responseData);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load builder details: ${response.statusCode}');
    }
    // }
    // catch (e) {
    //   debugPrint("-----------------$e");
    //   debugPrint("Error in getBuilderDetails: $e");
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBuilderDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 40,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
              decoration: const BoxDecoration(
                color: CustomColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 84,
                    width: 84,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      "",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : Shimmer.fromColors(
                                baseColor: CustomColors.black25,
                                highlightColor: CustomColors.black50,
                                child: Container(
                                  height: 84,
                                  width: 84,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 84,
                          width: 84,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            builder.companyName[0],
                            style: const TextStyle(
                              color: CustomColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            builder.companyName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/id_card.svg",
                                height: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                builder.reraId,
                                style: const TextStyle(
                                  color: CustomColors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.apartment_outlined,
                                color: CustomColors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${builder.totalNoOfProjects} Projects",
                                style: const TextStyle(
                                  color: CustomColors.white,
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
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    "Properties by ${builder.companyName}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            isLoading
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Shimmer.fromColors(
                          baseColor: CustomColors.black25,
                          highlightColor: CustomColors.black50,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PropertyListView(
                      sortedApartments: builder.apartments,
                      compare: true,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
