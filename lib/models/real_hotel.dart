// File: lib/models/real_hotel.dart

class Property {
  final String type;
  final String name;
  final String link;
  final String propertyToken;
  final String serpapiPropertyDetailsLink;
  final GpsCoordinates gpsCoordinates;
  final String checkInTime;
  final String checkOutTime;
  final Rate ratePerNight;
  final Rate totalRate;
  final List<Price> prices;
  final List<NearbyPlace> nearbyPlaces;
  final List<ImageItem> images;

  // ───────── new amenities field ─────────
  final List<String> amenities;

  Property({
    required this.type,
    required this.name,
    required this.link,
    required this.propertyToken,
    required this.serpapiPropertyDetailsLink,
    required this.gpsCoordinates,
    required this.checkInTime,
    required this.checkOutTime,
    required this.ratePerNight,
    required this.totalRate,
    required this.prices,
    required this.nearbyPlaces,
    required this.images,
    required this.amenities,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    // Safely parse amenities or fall back to an empty list
    final rawAmenities = json['amenities'];
    final parsedAmenities = (rawAmenities is List)
        ? rawAmenities.map((e) => e.toString()).toList()
        : <String>[];

    return Property(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      link: json['link'] ?? '',
      propertyToken: json['property_token'] ?? '',
      serpapiPropertyDetailsLink:
          json['serpapi_property_details_link'] ?? '',
      gpsCoordinates: (json['gps_coordinates'] is Map<String, dynamic>)
          ? GpsCoordinates.fromJson(
              json['gps_coordinates'] as Map<String, dynamic>)
          : const GpsCoordinates(latitude: 0, longitude: 0),
      checkInTime: json['check_in_time'] ?? '',
      checkOutTime: json['check_out_time'] ?? '',
      ratePerNight: (json['rate_per_night'] is Map<String, dynamic>)
          ? Rate.fromJson(json['rate_per_night'] as Map<String, dynamic>)
          : const Rate(
              lowest: '-',
              extractedLowest: 0,
              beforeTaxesFees: '-',
              extractedBeforeTaxesFees: 0,
            ),
      totalRate: (json['total_rate'] is Map<String, dynamic>)
          ? Rate.fromJson(json['total_rate'] as Map<String, dynamic>)
          : const Rate(
              lowest: '-',
              extractedLowest: 0,
              beforeTaxesFees: '-',
              extractedBeforeTaxesFees: 0,
            ),
      prices: (json['prices'] as List<dynamic>?)
              ?.map((x) => Price.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      nearbyPlaces: (json['nearby_places'] as List<dynamic>?)
              ?.map((x) => NearbyPlace.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((x) => ImageItem.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],

      amenities: parsedAmenities,
    );
  }
}

class GpsCoordinates {
  final double latitude;
  final double longitude;
  const GpsCoordinates({
    required this.latitude,
    required this.longitude,
  });
  factory GpsCoordinates.fromJson(Map<String, dynamic> json) {
    return GpsCoordinates(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Rate {
  final String lowest;
  final int extractedLowest;
  final String beforeTaxesFees;
  final int extractedBeforeTaxesFees;
  const Rate({
    required this.lowest,
    required this.extractedLowest,
    required this.beforeTaxesFees,
    required this.extractedBeforeTaxesFees,
  });
  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      lowest: json['lowest'] ?? '',
      extractedLowest: (json['extracted_lowest'] as num?)?.toInt() ?? 0,
      beforeTaxesFees: json['before_taxes_fees'] ?? '',
      extractedBeforeTaxesFees:
          (json['extracted_before_taxes_fees'] as num?)?.toInt() ?? 0,
    );
  }
}

class Price {
  final String source;
  final String logo;
  final int numGuests;
  final RatePerNight ratePerNight;
  Price({
    required this.source,
    required this.logo,
    required this.numGuests,
    required this.ratePerNight,
  });
  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      source: json['source'] ?? '',
      logo: json['logo'] ?? '',
      numGuests: (json['num_guests'] as num?)?.toInt() ?? 0,
      ratePerNight: RatePerNight.fromJson(
          json['rate_per_night'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class RatePerNight {
  final String lowest;
  final int extractedLowest;
  RatePerNight({
    required this.lowest,
    required this.extractedLowest,
  });
  factory RatePerNight.fromJson(Map<String, dynamic> json) {
    return RatePerNight(
      lowest: json['lowest'] ?? '',
      extractedLowest: (json['extracted_lowest'] as num?)?.toInt() ?? 0,
    );
  }
}

class NearbyPlace {
  final String name;
  final List<Transportation>? transportations;
  NearbyPlace({
    required this.name,
    this.transportations,
  });
  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    return NearbyPlace(
      name: json['name'] ?? '',
      transportations: (json['transportations'] as List<dynamic>?)
          ?.map((x) => Transportation.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Transportation {
  final String type;
  final String duration;
  Transportation({
    required this.type,
    required this.duration,
  });
  factory Transportation.fromJson(Map<String, dynamic> json) {
    return Transportation(
      type: json['type'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
}

class ImageItem {
  final String thumbnail;
  final String originalImage;
  ImageItem({
    required this.thumbnail,
    required this.originalImage,
  });
  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      thumbnail: json['thumbnail'] ?? '',
      originalImage: json['original_image'] ?? '',
    );
  }
}
