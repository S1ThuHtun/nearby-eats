# Nearby Eats

現在地付近のレストランを検索する Flutter アプリ。ホットペッパー グルメサーチAPI を使用。

## Prerequisites

- Flutter 3.44.4+
- ホットペッパー グルメサーチAPI キー（[取得はこちら](https://webservice.recruit.co.jp/)）

## Setup

1. リポジトリをクローン

```bash
git clone <repository-url>
cd nearby_eats
```

2. 依存パッケージをインストール

```bash
flutter pub get
```

3. プロジェクトルートに `.env` ファイルを作成し、API キーを設定

```
HOTPEPPER_API_KEY=your_api_key_here
```

4. アプリを起動

```bash
flutter run
```

## Features

- 現在地の GPS 取得
- 検索半径の選択（300m 〜 3km）
- キーワード検索
- 無限スクロールによるページング
- 検索結果 0 件時の範囲拡大ダイアログ
- 店舗詳細画面・HotPepper ページへのリンク

## 簡易仕様書

[docs/spec.md](docs/spec.md)
