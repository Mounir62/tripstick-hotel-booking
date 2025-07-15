// File: lib/services/serp_hotel_service.dart
//
// A service that fetches hotel data from SerpAPI’s Google Hotels endpoint.
//
// ▸ Example:
//   final hotels = await SerpHotelService().searchHotels(
//     query:        'Bali Resorts',
//     checkIn:      DateTime(2025, 5, 17),
//     checkOut:     DateTime(2025, 5, 18),
//     adults:       2,
//     currency:     'EGP',
//     geoCountry:   'eg',   // gl
//     languageCode: 'en',   // hl
//   );
//
// Requires:  http: ^1.3.0  (or ^1.x)

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/real_hotel.dart';      

class SerpHotelService {
  // SerpAPI base & key
  static const _baseUrl = 'serpapi.com';
  static const _apiKey  =
      'ea0a7a25fc28d73ef8e63d01188b4feab893f2fb076d65af6f656f4c99df4a0a';

  /// Search hotels via SerpAPI Google Hotels.
  ///
  /// [query] – e.g. `"Bali Resorts"` or `"London Hotels"`.
  ///
  /// Returns up to 30 `Property` objects (adjust via SerpAPI params if needed).
  Future<List<Property>> searchHotels({
    required String query,
    required DateTime checkIn,
    required DateTime checkOut,
    int adults       = 2,
    String currency  = 'USD',
    String geoCountry = 'us',   // gl
    String languageCode = 'en', // hl
  }) async {
    final uri = Uri.https(_baseUrl, '/search.json', {
      'q'       : query,
      'engine'  : 'google_hotels',
      'check_in_date'  : _fmtDate(checkIn),
      'check_out_date' : _fmtDate(checkOut),
      'adults'  : adults.toString(),
      'currency': currency,
      'gl'      : geoCountry,
      'hl'      : languageCode,
      'api_key' : _apiKey,
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception(
        'SerpAPI error ${res.statusCode}: ${res.reasonPhrase}',
      );
    }

    final Map<String, dynamic> body = json.decode(res.body);
    if (!body.containsKey('properties')) {
      throw Exception('SerpAPI response missing "properties"');
    }

    final List<dynamic> propsJson = body['properties'];
    return propsJson
        .map<Property>((e) => Property.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Helper: yyyy-mm-dd
  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
