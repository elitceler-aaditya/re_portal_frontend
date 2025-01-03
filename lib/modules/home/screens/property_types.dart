import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_portal_frontend/modules/home/screens/main_screen.dart';
import 'package:re_portal_frontend/modules/home/widgets/properties_tiles.dart';
import 'package:re_portal_frontend/modules/shared/models/property_type.dart';
import 'package:re_portal_frontend/modules/shared/models/user.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/transitions.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyTypesScreen extends ConsumerStatefulWidget {
  const PropertyTypesScreen({super.key});

  @override
  ConsumerState<PropertyTypesScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<PropertyTypesScreen> {
  getTempStorage() async {
    //get token.json file
    await getTemporaryDirectory().then((tempDir) async {
      SharedPreferences.getInstance().then((sharedref) {
        String token = sharedref.getString('token') ?? '';
        if (token.isNotEmpty) {
          final userData = JwtToken.payload(token);
          ref
              .read(userProvider.notifier)
              .setUser(User.fromJson({...userData, 'token': token}));
        }
      });
    });
  }

  @override
  void initState() {
    getTempStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFCCBAE),
                Color(0xFFF87988),
              ],
            ),
          ),
        ),
        title: RichText(
          textAlign: TextAlign.start,
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Re',
                style: TextStyle(
                  color: CustomColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'Portal',
                style: TextStyle(
                  color: CustomColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PropertiesTiles(
            //   title: 'Commercial',
            //   description: 'Discover top commercial properties nearby',
            //   image: 'assets/images/tile_bg1.jpg',
            //   onTap: () {
            //     ref
            //         .read(homePropertiesProvider.notifier)
            //         .setPropertyType(PropertyTypes.commercial);
            //     rightSlideTransition(
            //       context,
            //       const MainScreen(),
            //     );
            //   },
            // ),
            const Text(
              "Select Property Type",
              style: TextStyle(
                color: CustomColors.black50,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            PropertiesTiles(
              title: 'Villas',
              description: 'Luxurious villas and upscale properties',
              image: 'assets/images/tile_bg2.jpg',
              onTap: () {
                ref
                    .read(homePropertiesProvider.notifier)
                    .setPropertyType(PropertyTypes.villas);
                rightSlideTransition(
                  context,
                  const MainScreen(),
                );
              },
            ),
            PropertiesTiles(
              title: 'Apartments',
              description: 'Luxury living in stunning apartments.',
              image: 'assets/images/tile_bg3.jpg',
              onTap: () {
                ref
                    .read(homePropertiesProvider.notifier)
                    .setPropertyType(PropertyTypes.appartments);
                rightSlideTransition(
                  context,
                  const MainScreen(),
                );
              },
            ),
            PropertiesTiles(
              title: 'Plots',
              description: 'Your dream sanctuary on prime plots.',
              image: 'assets/images/tile_bg4.jpg',
              onTap: () {
                ref
                    .read(homePropertiesProvider.notifier)
                    .setPropertyType(PropertyTypes.plots);
                rightSlideTransition(
                  context,
                  const MainScreen(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
