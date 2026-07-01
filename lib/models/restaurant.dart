class Restaurant {
  final String id; // 各レストラン ID
  final String name; // 各レストラン名
  final String address; // 各レストラン住所
  final String access; // 最寄り駅・アクセス情報
  final String open; // 営業時間
  final String logoImage; // リストに表示する画像 image URL
  final String photo; // 詳細画面用の写真URL
  final String genre; // 料理ジャンル（和食、イタリア料理...）
  final String budget; // 平均予算の説明
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
    required this.budget,
    required this.urls,
  });

  /// Creates a Restaurant from a JSON map returned by the HotPepper API.
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      access: json['access'] ?? '',
      open: json['open'] ?? '',
      logoImage: json['logo_image'] ?? '',
      photo: json['photo']?['mobile']?['l'] ?? '',
      genre: json['genre']?['name'] ?? '',
      budget: json['budget']?['average'] ?? '',
      urls: json['urls']?['pc'] ?? '',
    );
  }
}
