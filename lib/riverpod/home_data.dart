import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/appartment_model.dart';

class HomeDataNotifier extends StateNotifier<HomeData> {
  HomeDataNotifier() : super(HomeData());

  void setApartments(List<ApartmentModel> apartments) {
    state = state.copyWith(apartments: apartments);
  }

  void setPropertyType(String propertyType) {
    state = state.copyWith(propertyType: propertyType);
  }
}

class HomeData {
  final List<ApartmentModel> apartments;
  final String propertyType;

  HomeData({
    this.apartments = const [],
    this.propertyType = '',
  });

  HomeData copyWith({
    List<ApartmentModel>? apartments,
    String? propertyType,
  }) {
    return HomeData(
      apartments: apartments ?? this.apartments,
      propertyType: propertyType ?? this.propertyType,
    );
  }
}

final homeDataProvider =
    StateNotifierProvider<HomeDataNotifier, HomeData>((ref) {
  return HomeDataNotifier();
});
