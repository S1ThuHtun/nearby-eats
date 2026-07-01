/// App-wide constants for API configuration and search options.
class Constants {
  // HotPepper Gourmet Search API base URL
  static const String hotpepperBaseUrl =
      'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/';

  // Number of results to fetch per page
  static const int resultsPerPage = 20;

  // Search radius options (in meters) shown to the user in the search screen
  // Values follow the HotPepper API's range parameter: 1=300m, 2=500m, 3=1000m, 4=2000m, 5=3000m
  static const List<Map<String, dynamic>> radiusOptions = [
    {'label': '300m', 'value': 1},
    {'label': '500m', 'value': 2},
    {'label': '1km', 'value': 3},
    {'label': '2km', 'value': 4},
    {'label': '3km', 'value': 5},
  ];
}
