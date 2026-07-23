/// アプリ内で発生するエラーをユーザー向けメッセージとして扱うための例外クラスです。
///
/// 標準の `Exception` をそのまま `toString()` すると `"Exception: ..."` という
/// 開発者向けの接頭辞が付いてしまい、UI にそのまま表示すると不格好になります。
/// `toString()` をオーバーライドし、メッセージのみを返すようにしています。
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
