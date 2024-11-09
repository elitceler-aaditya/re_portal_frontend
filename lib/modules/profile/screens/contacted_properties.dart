import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:re_portal_frontend/modules/profile/models/contacted_properties_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'dart:convert';

import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactedProperties extends ConsumerStatefulWidget {
  const ContactedProperties({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactedPropertiesState();
}

class _ContactedPropertiesState extends ConsumerState<ContactedProperties> {
  final List<ContactedPropertyModel> contactedProperties = [];

  Future<void> fetchContactedProperties() async {
    debugPrint('Fetching contacted properties');

    try {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['BASE_URL']!}/user/getUserLeadHistory/${ref.watch(userProvider).userId}'),
        headers: {
          'Authorization': 'Bearer ${ref.watch(userProvider).token}',
        },
      );
      debugPrint('----Contacted properties fetched: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          contactedProperties.clear();
          contactedProperties.addAll((data['data'] as List)
              .map((item) => ContactedPropertyModel.fromJson(item))
              .toList());
        });
      }
    } catch (e) {
      debugPrint('Error fetching contacted properties: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchContactedProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Contacted Properties'),
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
      ),
      body: ListView.builder(
        itemCount: contactedProperties.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              launchUrlString(
                  'tel:${contactedProperties[index].phone.replaceAll(RegExp(r'[^0-9]'), '')}');
            },
            leading: const CircleAvatar(
              radius: 20,
              backgroundColor: CustomColors.primary,
              child: Icon(
                Icons.call,
                size: 20,
                color: CustomColors.white,
              ),
            ),
            title: Text(
              contactedProperties[index].project.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "By ${contactedProperties[index].builder.CompanyName}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.black50,
                  ),
                ),
                Text(
                  contactedProperties[index].phone,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.black50,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('dd MMM yyyy\nhh:mm a').format(
                    DateTime.parse(contactedProperties[index].createdAt),
                  ),
                  textAlign: TextAlign.end,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: CustomColors.primary,
                    ),
                    Text(
                      contactedProperties[index].project.projectLocation,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CustomColors.black50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
