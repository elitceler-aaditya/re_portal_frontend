import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/similar_properties_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class AdsSection extends ConsumerStatefulWidget {
  const AdsSection({super.key});

  @override
  ConsumerState<AdsSection> createState() => _AdsSectionState();
}

class _AdsSectionState extends ConsumerState<AdsSection> {
  void getAds() async {
    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/user/getSimilarProperty";
    Uri uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> responseBody = responseData['adsProject'];
        List<ApartmentModel> similarProperties =
            responseBody.map((item) => ApartmentModel.fromJson(item)).toList();

        ref
            .read(similarPropertiesProvider.notifier)
            .setSimilarProperties(similarProperties);
      } else {
        throw Exception('Failed to get similar properties');
      }
    } catch (error, stackTrace) {
      debugPrint("-------error: $error");
      debugPrint("-------stackTrace: $stackTrace");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.watch(similarPropertiesProvider).isEmpty) {
        getAds();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Similar Properties",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CustomColors.black,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: ref.watch(similarPropertiesProvider).length,
              itemBuilder: (context, index) {
                return _adsCard(
                  context,
                  ref.watch(similarPropertiesProvider)[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _adsCard(context, ApartmentModel apartment) {
  String formatBudget(int budget) {
    if (budget < 100000) {
      return "₹${(budget / 1000).toStringAsFixed(00)}K";
    } else if (budget < 10000000) {
      return "₹${(budget / 100000).toStringAsFixed(1)}L";
    } else {
      return "₹${(budget / 10000000).toStringAsFixed(2)}Cr";
    }
  }

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PropertyDetails(
          apartment: apartment,
          heroTag: "ad-${apartment.apartmentID}",
        ),
      ));
    },
    child: Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          SizedBox(
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.network(
                apartment.coverImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Shimmer.fromColors(
                            baseColor: CustomColors.black25,
                            highlightColor: CustomColors.black50,
                            child: Container(
                              height: 180,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
              ),
            ),
          ),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  CustomColors.black.withOpacity(0),
                  CustomColors.black.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment.name,
                    style: const TextStyle(
                      color: CustomColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${apartment.flatSize} sq ft • ${formatBudget(apartment.budget)} • ${apartment.projectLocation}",
                    style: const TextStyle(
                      color: CustomColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
