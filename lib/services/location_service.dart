import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    // GPSの許可確認
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('位置情報サービスが無効です。設定から有効にしてください。');
    }

    // 位置情報許可ステータス確認
    LocationPermission permission = await Geolocator.checkPermission();

    // 不許可の場合、許可を求める
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('位置情報の許可が拒否されました。');
      }
    }

    // 許可が永久に拒否された場合、設定から許可を案内
    if (permission == LocationPermission.deniedForever) {
      throw Exception('位置情報の許可が永久に拒否されています。設定から許可してください。');
    }

    // 位置情報取得に許可された場合　＝＞　現在地の位置情報を取得
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } on TimeoutException {
      throw Exception('位置情報の取得がタイムアウトしました。もう一度お試しください。');
    }
  }
}
