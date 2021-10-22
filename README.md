# DrinkMemo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### 接続環境を変える方法

## ホットリロード（シミュレーターで起動）

# 検証環境(staging)

通常の状態で F5
flutter run --dart-define=FLAVOR=stg

# 本番環境(production)

launch.json を prod だけにする
flutter run --dart-define=FLAVOR=prod

## ipa でビルド

# 検証環境(staging)

flutter build ios --dart-define=FLAVOR=stg

# 本番環境(production)

flutter build ios --dart-define=FLAVOR=prod

### アプリのアイコンを変更するときに必要な作業

asset/appIcons のファイルを変更する
flutter pub run flutter_launcher_icons:main
