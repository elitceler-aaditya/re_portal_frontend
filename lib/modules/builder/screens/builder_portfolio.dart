import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';

class BuilderPortfolio extends StatefulWidget {
  const BuilderPortfolio({super.key});

  @override
  State<BuilderPortfolio> createState() => _BuilderPortfolioState();
}

class _BuilderPortfolioState extends State<BuilderPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 40,
      ),
      body: Column(
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
                const CircleAvatar(
                  radius: 50,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Balaji Constructions",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "A reliable and successful constructing company in Hyderabad’s real-estate industry. Leading firm in real-estate realm and stands ahead in national level",
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/id_card.svg"),
                            const SizedBox(width: 10),
                            const Text(
                              "P024400006675",
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  "Properties by Balaji Constructions",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
