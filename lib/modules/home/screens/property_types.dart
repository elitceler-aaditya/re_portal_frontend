
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
        final userData = JwtToken.payload(token);

        ref
            .read(userProvider.notifier)
            .setUser(User.fromJson({...userData, 'token': token}));
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
      backgroundColor: CustomColors.primary10,
      appBar: AppBar(
        backgroundColor: CustomColors.primary10,
        centerTitle: true,
        title: GestureDetector(
          onTap: () async {
            //get refresh token
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // await prefs.setString('refreshToken', "what tf?");
            String refreshToken = prefs.getString('refreshToken') ?? '';
            debugPrint('----------------$refreshToken');
          },
          child: RichText(
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            PropertiesTiles(
              title: 'Commercial',
              description: 'Discover top commercial properties nearby',
              image: 'assets/images/tile_bg1.png',
              onTap: () {
                ref
                    .read(homeDataProvider.notifier)
                    .setPropertyType(PropertyTypes.commercial);
                rightSlideTransition(
                  context,
                  const MainScreen(),
                );
              },
            ),
            PropertiesTiles(
              title: 'Villas',
              description: 'Luxurious villas and upscale properties',
              image: 'assets/images/tile_bg2.png',
              onTap: () {
                ref
                    .read(homeDataProvider.notifier)
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
              image: 'assets/images/tile_bg3.png',
              onTap: () {
                ref
                    .read(homeDataProvider.notifier)
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
              image: 'assets/images/tile_bg4.png',
              onTap: () {
                ref
                    .read(homeDataProvider.notifier)
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
