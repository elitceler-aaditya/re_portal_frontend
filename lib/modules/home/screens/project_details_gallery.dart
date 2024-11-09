import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/home/screens/project_gallery_view.dart';
import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shimmer/shimmer.dart';

class ProjectDetailsGallery extends StatefulWidget {
  final List<ProjectImageModel> projectImages;
  const ProjectDetailsGallery({super.key, required this.projectImages});

  @override
  State<ProjectDetailsGallery> createState() => _ProjectDetailsGalleryState();
}

class _ProjectDetailsGalleryState extends State<ProjectDetailsGallery> {
  ScrollController galleryController = ScrollController();
  int galleryIndex = 0;
  List<ProjectImageModel> projectImages = [];

  @override
  void initState() {
    super.initState();
    List<String> allImages = [];
    for (var gal in widget.projectImages) {
      allImages.addAll(gal.images);
    }
    projectImages = [
      ProjectImageModel(title: 'All', images: allImages),
      ...widget.projectImages,
    ];
  }

  @override
  void dispose() {
    galleryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Project Gallery",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomColors.black,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                projectImages.length,
                (index) => (projectImages[index].images.isEmpty)
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: galleryIndex == index
                                ? CustomColors.primary20
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(
                              color: CustomColors.primary20,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              galleryIndex = index;
                            });
                            galleryController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            projectImages[index].title,
                            style: TextStyle(
                              color: galleryIndex == index
                                  ? CustomColors.primary
                                  : CustomColors.black,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              controller: galleryController,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: projectImages[galleryIndex].images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProjectImageGallery(
                          projectImages: projectImages,
                          tabIndex: galleryIndex,
                          photoIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: CustomColors.black10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(
                        projectImages[galleryIndex].images[index].trim(),
                        key: GlobalKey(
                          debugLabel:
                              "${projectImages[galleryIndex].title}-$index",
                        ),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : Shimmer.fromColors(
                                    baseColor: CustomColors.black25,
                                    highlightColor: CustomColors.black50,
                                    child: Container(
                                      height: 200,
                                      width: 320,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
