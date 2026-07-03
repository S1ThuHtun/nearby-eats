/// アプリ全体で使用する API 設定や検索オプションの定数をまとめたものです。
class Constants {
  // HotPepper グルメ検索 API のベース URL
  static const String hotpepperBaseUrl =
      'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/';

  // 1 ページあたりで取得する検索結果数です。
  static const int resultsPerPage = 20;

  /// 検索画面でユーザーに提示する検索半径オプション（メートル単位）です。
  ///
  /// 値は HotPepper API の range パラメーター仕様に従います： 1 = 300m, 2 = 500m, 3 = 1000m, 4 = 2000m, 5 = 3000m

  static const List<Map<String, dynamic>> radiusOptions = [
    {'label': '300m', 'value': 1},
    {'label': '500m', 'value': 2},
    {'label': '1km', 'value': 3},
    {'label': '2km', 'value': 4},
    {'label': '3km', 'value': 5},
  ];
}
