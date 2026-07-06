// HotPepper グルメ API から取得した単一のレストランを表すデータモデル。
// 各インスタンスは、名前・住所・写真などの店舗情報を保持し、
// Restaurant.fromJson によって API の JSON レスポンスからパースされます。
// 結果一覧(Results Screen)画面および詳細画面でレストラン情報を表示するために使用されます。

class Restaurant {
  final String id; // 各レストラン ID
  final String name; // 各レストラン名
  final String address; // 各レストラン住所
  final String access; // 最寄り駅・アクセス情報
  final String open; // 営業時間
  final String logoImage; // リストに表示する画像 image URL
  final String photo; // 詳細画面用の写真URL
  final String genre; // 料理ジャンル（和食、イタリア料理...）
  final String averageBudget; // 平均予算の説明
  final String budgetName; // 予算カテゴリ名
  final String urls; // レストランのHotPepper掲載ページのURL

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.access,
    required this.open,
    required this.logoImage,
    required this.photo,
    required this.genre,
    required this.averageBudget,
    required this.budgetName,
    required this.urls,
  });

  /// HotPepper API の JSON マップから Restaurant インスタンスを生成します。
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // ネストされたオブジェクトを先に typed cast して null-safe にアクセスする
    final genre = json['genre'] as Map<String, dynamic>?;
    final photo = json['photo'] as Map<String, dynamic>?;
    final mobile = photo?['mobile'] as Map<String, dynamic>?;
    final budget = json['budget'] as Map<String, dynamic>?;
    final urls = json['urls'] as Map<String, dynamic>?;

    return Restaurant(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      access: json['access'] as String? ?? '',
      open: json['open'] as String? ?? '',
      logoImage: json['logo_image'] as String? ?? '',
      photo: mobile?['l'] as String? ?? '',
      genre: genre?['name'] as String? ?? '',
      averageBudget: budget?['average'] as String? ?? '',
      budgetName: budget?['name'] as String? ?? '',
      urls: urls?['pc'] as String? ?? '',
    );
  }
}
