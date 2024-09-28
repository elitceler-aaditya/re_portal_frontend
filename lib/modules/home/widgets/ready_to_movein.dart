import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/property_details.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class ReadyToMovein extends StatelessWidget {
  final List<ApartmentModel> apartments;
  const ReadyToMovein({
    super.key,
    required this.apartments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Ready to move in",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: apartments.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetails(
                        apartment: apartments[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width * 0.8,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Hero(
                              tag: apartments[index].apartmentID,
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: Image.network(
                                  apartments[index].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                                child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0XFF6525FF).withOpacity(0.6),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(16),
                                  topLeft: Radius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "Ready to move in",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.white,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        color: CustomColors.primary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  apartments[index].apartmentName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.white,
                                  ),
                                ),
                                Text(
                                  "@${apartments[index].locality}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            SizedBox( 
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PropertyDetails(
                                        apartment: apartments[index],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.primary,
                                  side: const BorderSide(
                                    color: CustomColors.white,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                                child: const Text(
                                  'View more',
                                  style: TextStyle(
                                    color: CustomColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
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
          ),
        ),
      ],
    );
  }
}
