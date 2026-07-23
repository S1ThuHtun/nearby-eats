import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../utils/app_exception.dart';
import '../utils/constants.dart';

class HotpepperService {
  Future<Map<String, dynamic>> searchRestaurants({
    required Position position,
    required int range,
    int start = 1,
    String keyword = '',
  }) async {
    final apiKey = dotenv.env['HOTPEPPER_API_KEY'] ?? '';

    // APIキーが未設定の場合は早期にエラーを投げる
    if (apiKey.isEmpty) {
      throw const AppException('APIキーが設定されていません。.envファイルを確認してください。');
    }

    // required query parametersでAPI request URLを作る
    final params = {
      'key': apiKey,
      'lat': position.latitude.toString(),
      'lng': position.longitude.toString(),
      'range': range.toString(),
      'count': Constants.resultsPerPage.toString(),
      'start': start.toString(),
      'format': 'json',
    };

    // キーワードが入力された場合のみパラメータに追加する
    if (keyword.isNotEmpty) params['keyword'] = keyword;

    final uri = Uri.parse(
      Constants.hotpepperBaseUrl,
    ).replace(queryParameters: params);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw AppException('APIリクエストが失敗しました。ステータス: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final results = data['results'];

    // HotPepper API は 2000（認証エラー）や 3000（パラメータ不正）でも
    // HTTP 200 を返し、results.error にエラー内容を格納する
    final errors = results['error'] as List?;
    if (errors != null && errors.isNotEmpty) {
      final message = errors.first['message'] as String? ?? '不明なエラーが発生しました。';
      throw AppException(message);
    }

    // 200 OKでも shop キーが存在しない場合 =>（該当なし）
    final shopList = (results['shop'] as List?) ?? [];
    final shops = shopList
        .map(
          (shopJson) => Restaurant.fromJson(shopJson as Map<String, dynamic>),
        )
        .toList();

    return {'shops': shops, 'total': results['results_available'] ?? 0};
  }
}
