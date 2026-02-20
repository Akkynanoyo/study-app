# 新規参加者向けガイド

このドキュメントは、`study-app` に参加した開発者が最初に押さえるべきポイントを短時間で把握できるようにまとめたものです。

## 1. コードベースの全体構造

アプリは **Flutter + Firebase** 構成です。

- エントリポイント: `lib/main.dart`
  - Firebase 初期化
  - ルートウィジェット (`ScheduleApp`) 起動
  - 初期画面として `AuthScreen` を表示
- 認証画面: `lib/screens/auth_screen.dart`
  - メール/パスワード認証 (ログイン・新規登録)
  - 成功時に `ScheduleScreen` へ遷移
- 予定管理画面: `lib/screens/schedule_screen.dart`
  - 予定の入力 (タイトル、説明、日付、時刻)
  - 予定一覧のリアルタイム表示
  - 予定削除
  - ログアウト
- データモデル: `lib/models/schedule.dart`
  - Firestore との変換 (`toMap`, `fromMap`)
- Firestore アクセス層: `lib/services/firestore_service.dart`
  - 予定の追加・取得・削除・更新

## 2. データと責務の流れ

1. ユーザーが認証画面でログイン/サインアップ
2. 認証成功後、予定管理画面へ遷移
3. 予定追加時、`Schedule` モデルを作成して `FirestoreService.addSchedule` を呼ぶ
4. 一覧は `FirestoreService.getSchedules()` の Stream を `StreamBuilder` で購読して更新
5. 削除操作で `FirestoreService.deleteSchedule` を呼ぶ

UI (`screens`)、モデル (`models`)、データアクセス (`services`) が分離されているため、機能追加時はこの層分けを維持すると変更の影響範囲を抑えられます。

## 3. 先に知っておくべき重要事項

### Firebase 前提のプロジェクト

- ローカルで動かすには Firebase 設定が必須
  - `lib/firebase_options.dart`
  - Android の `google-services.json`
  - iOS の `GoogleService-Info.plist`
- 認証方式は Email/Password
- Firestore の `schedules` コレクションを使用

### 認証状態の扱い

- `ScheduleScreen` では `FirebaseAuth.instance.currentUser!.uid` を前提としている
- ログイン済みであることを前提にした実装があるため、画面遷移やリフレッシュ時の認証状態管理を強化する余地がある

### エラーハンドリング

- `FirestoreService` の例外処理は `print` ベースで簡易
- 運用を考えると、UI 通知やロギング基盤（Crashlytics など）への接続が望ましい

### 現時点の機能範囲

- 予定の CRUD は主に **Create/Read/Delete** が画面から利用される
- `updateSchedule` はサービス層にあるが、画面上の編集 UI は未実装

## 4. 新規参加者におすすめの学習順序

1. `lib/main.dart` を読んでアプリ起動フローを把握
2. `lib/screens/auth_screen.dart` で認証フローを理解
3. `lib/screens/schedule_screen.dart` で UI と状態管理を確認
4. `lib/models/schedule.dart` と `lib/services/firestore_service.dart` でデータ入出力を理解
5. `README.md` と `docs/FIREBASE_SETUP.md` でセットアップ手順を確認

## 5. 最初の改善タスク候補（オンボーディング向け）

- 入力バリデーション強化（メール形式、パスワード強度、必須項目）
- 認証状態監視 (`authStateChanges`) による自動ルーティング
- 予定編集 UI の追加（既存の `updateSchedule` 活用）
- 日付/時刻表示のフォーマット統一
- 例外処理の統一（UI エラー表示 + ログ）

## 6. 開発の基本コマンド

```bash
flutter pub get
flutter run
flutter test
flutter analyze
```

Firebase 設定が不十分だと実行時に初期化エラーになるため、まず設定ファイル・コンソール設定を確認してください。
