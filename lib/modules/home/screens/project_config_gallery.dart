import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/search/widgets/photo_scrolling_gallery.dart';
import 'package:re_portal_frontend/modules/shared/models/apartment_details_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:shimmer/shimmer.dart';

class ProjectConfigGallery extends StatefulWidget {
  final List<UnitPlanConfig> unitPlanConfigFilesFormatted;
  const ProjectConfigGallery(
      {super.key, required this.unitPlanConfigFilesFormatted});

  @override
  State<ProjectConfigGallery> createState() => _ProjectConfigGalleryState();
}

class _ProjectConfigGalleryState extends State<ProjectConfigGallery> {
  ScrollController galleryController = ScrollController();
  ScrollController configController = ScrollController();

  int galleryIndex = 0;
  int configIndex = 0;
  List<UnitPlanConfig> projectImages = [];

  @override
  void initState() {
    super.initState();
    List<String> allImages = [];
    for (var gal in widget.unitPlanConfigFilesFormatted) {
      allImages.addAll(gal.unitPlanConfigFiles);
    }
    projectImages = [
      UnitPlanConfig(bHKType: 'All', unitPlanConfigFiles: allImages),
      ...widget.unitPlanConfigFilesFormatted,
    ];
  }

  @override
  void dispose() {
    galleryController.dispose();
    configController.dispose();
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
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              "Configurations",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomColors.black,
              ),
            ),
          ),
          if (widget.unitPlanConfigFilesFormatted
              .map((e) => e.bHKType)
              .isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  projectImages.map((e) => e.bHKType).length,
                  (index) => projectImages.map((e) => e.bHKType).isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: configIndex == index
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
                                configIndex = index;
                              });
                              configController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              projectImages
                                  .map((e) => e.bHKType)
                                  .toList()[index],
                              style: TextStyle(
                                color: configIndex == index
                                    ? CustomColors.primary
                                    : CustomColors.black,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          if (projectImages.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                controller: configController,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount:
                    projectImages[configIndex].unitPlanConfigFiles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final List<String> allImgs = [];
                      List<double> breakpoints = [];
                      double cumulativeSum = 0;
                      for (var gal in projectImages) {
                        allImgs.addAll(gal.unitPlanConfigFiles);
                        cumulativeSum += gal.unitPlanConfigFiles.length;
                        breakpoints.add(cumulativeSum);
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PhotoScrollingGallery(
                            allImages: allImgs,
                            labels: projectImages
                                .map((gal) => gal.bHKType)
                                .toList(),
                            galleryIndex: 0,
                            breakPoints: breakpoints,
                            image: widget
                                .unitPlanConfigFilesFormatted[configIndex]
                                .unitPlanConfigFiles[index],
                            extraDetails: projectImages
                                .map((e) =>
                                    "${e.facing} facing  |  ${e.sizeInSqft} sq.ft")
                                .toList(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          projectImages[configIndex].unitPlanConfigFiles[index],
                          fit: BoxFit.cover,
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
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Text(
                              "Error loading image",
                              style: TextStyle(
                                color: CustomColors.red,
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
          if (projectImages[configIndex].facing.isNotEmpty ||
              projectImages[configIndex].sizeInSqft.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              child: Text(
                "  ${projectImages[configIndex].sizeInSqft}sq.ft | Facing ${projectImages[configIndex].facing}",
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
