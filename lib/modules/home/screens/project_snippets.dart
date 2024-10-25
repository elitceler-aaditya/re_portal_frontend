import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/project_snippet_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/riverpod/user_riverpod.dart';
import 'package:http/http.dart' as http;

class ProjectSnippets extends ConsumerStatefulWidget {
  final bool leftPadding;

  const ProjectSnippets({super.key, this.leftPadding = true});

  @override
  ConsumerState<ProjectSnippets> createState() => _ProjectSnippetsState();
}

class _ProjectSnippetsState extends ConsumerState<ProjectSnippets> {
  List<ApartmentModel> apartments = [];
  List<String> videoLinks = [];
  bool loading = true;

  Future<void> getSnippets() async {
    setState(() {
      loading = true;
    });

    String baseUrl = dotenv.get('BASE_URL');
    String url = "$baseUrl/user/getProjectSnippet";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${ref.watch(userProvider).token}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List responseBody = jsonDecode(response.body)['projectSnippet'];
        setState(() {
          apartments = responseBody
              .map((e) => ApartmentModel.fromJson(e as Map<String, dynamic>))
              .toList();
          videoLinks =
              responseBody.map((e) => e['videoLink'] as String).toList();
          loading = false;
        });
      } else {
        throw Exception('Failed to load snippets');
      }
    } catch (error) {
      debugPrint("error: $error");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSnippets();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, top: 4),
          child: Text(
            "Project Snippets",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 250,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                apartments.length,
                (index) => ProjectSnippetCard(
                  leftPadding: widget.leftPadding,
                  apartment: apartments[index],
                  videoLink: videoLinks[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
