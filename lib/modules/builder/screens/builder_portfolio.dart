import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:re_portal_frontend/modules/builder/models/builder_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:http/http.dart' as http;
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';

class BuilderPortfolio extends ConsumerStatefulWidget {
  final String projectId;
  const BuilderPortfolio({super.key, required this.projectId});

  @override
  ConsumerState<BuilderPortfolio> createState() => _BuilderPortfolioState();
}

class _BuilderPortfolioState extends ConsumerState<BuilderPortfolio> {
  BuilderModel builder = const BuilderModel();
  List projects = [];
  bool isLoading = true;

  void getBuilderDetails() {
    String token = ref.watch(userProvider).token;
    Uri url = Uri.parse(
        "${dotenv.env['BASE_URL']}/user/getBuilderDetails/${widget.projectId}");
    http.get(url, headers: {
      "Authorization": "Bearer $token",
    }).then((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        builder = BuilderModel.fromJson(
          jsonDecode(response.body)['builderDetails'],
        );
        projects = jsonDecode(response.body)['projectDetails'];
      }
      setState(() {
        isLoading = false;
      });
    }).onError((error, stackTrace) {
    });

    setState(() {
      isLoading = false;
    });
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
      body: isLoading
          ? const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  color: CustomColors.black,
                ),
              ),
            )
          : Column(
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
                              Text(
                                builder.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                builder.description,
                                maxLines: 3,
                                style: const TextStyle(
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
                                  Text(
                                    builder.reraID,
                                    style: const TextStyle(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        "Properties by ${builder.name}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          projects[index]['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.black,
                          ),
                        ),
                        subtitle: Text(
                          projects[index]['description'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.black,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
