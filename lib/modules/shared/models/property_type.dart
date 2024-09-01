abstract final class PropertyTypes {
  static const commercial = 'Commercial';
  static const villas = 'Villas';
  static const appartments = 'Apartments';
  static const plots = 'Plots';

  static String getEndpoint(String propertyType) {
    switch (propertyType) {
      case commercial:
        return 'filterCommercial';
      case villas:
        return 'filterVillas';
      case appartments:
        return 'filterApartments';
      case plots:
        return 'filterPlots';
    }
    return '';
  }
}
