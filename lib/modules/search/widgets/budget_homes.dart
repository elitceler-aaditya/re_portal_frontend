import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/home/widgets/lifestyle_projects_card.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/riverpod/home_data.dart';

class BudgetHomes extends ConsumerStatefulWidget {
  const BudgetHomes({super.key});

  @override
  ConsumerState<BudgetHomes> createState() => _BudgetHomesState();
}

class _BudgetHomesState extends ConsumerState<BudgetHomes> {
  Map<String, List<ApartmentModel>> budgetHomes = {};
  int selectedBudget = 0;
  PageController pageController = PageController();

  List<Map<String, dynamic>> budgetCategories = [
    {
      'title': '60L to 1Cr',
      'minBudget': 6000000,
      'maxBudget': 10000000,
    },
    {
      'title': '1Cr to 1.5Cr',
      'minBudget': 10000001,
      'maxBudget': 15000000,
    },
    {
      'title': '1.5Cr to 2Cr',
      'minBudget': 15000001,
      'maxBudget': 20000000,
    },
    {
      'title': '3Cr+',
      'minBudget': 30000001,
      'maxBudget': 9999999999,
    }
  ];

  void configBudgetCategories() {
    setState(() {
      budgetCategories = budgetCategories.where((category) {
        List<ApartmentModel> homes = ref
            .read(homePropertiesProvider.notifier)
            .getBudgetHomes(category['maxBudget'], category['minBudget']);
        return homes.isNotEmpty;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      configBudgetCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return budgetCategories.isEmpty
        ? const SizedBox.shrink()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Budget Homes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        budgetCategories.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: selectedBudget == index
                                  ? CustomColors.primary
                                  : Colors.transparent,
                              side:
                                  const BorderSide(color: CustomColors.black50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedBudget = index;
                                pageController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            child: Text(
                              budgetCategories[index]['title'],
                              style: TextStyle(
                                color: selectedBudget == index
                                    ? CustomColors.white
                                    : CustomColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: ref
                        .watch(homePropertiesProvider.notifier)
                        .getBudgetHomes(
                            budgetCategories[selectedBudget]['maxBudget'],
                            budgetCategories[selectedBudget]['minBudget'])
                        .isEmpty
                    ? Center(
                        child: Text(
                            "No apartments found in ${budgetCategories[selectedBudget]['title']}"),
                      )
                    : ListView.builder(
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: ref
                            .watch(homePropertiesProvider.notifier)
                            .getBudgetHomes(
                                budgetCategories[selectedBudget]['maxBudget'],
                                budgetCategories[selectedBudget]['minBudget'])
                            .length,
                        itemBuilder: (context, index) {
                          return LifestyleProjectCard(
                            lifestyleProperty: ref
                                .watch(homePropertiesProvider.notifier)
                                .getBudgetHomes(
                                    budgetCategories[selectedBudget]
                                        ['maxBudget'],
                                    budgetCategories[selectedBudget]
                                        ['minBudget'])[index],
                            showPrice: true,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),
            ],
          );
  }
}
