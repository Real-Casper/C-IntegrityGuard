# C-IntegrityGuard
![C-IntegrityGuard](./doc/banner.png)

[![Latest Release](https://img.shields.io/github/v/release/Real-Casper/C-IntegrityGuard?label=Release&logo=github)](https://github.com/Real-Casper/C-IntegrityGuard/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/Real-Casper/C-IntegrityGuard/build-test.yml?label=Build%20Test%20Module)](https://github.com/Real-Casper/C-IntegrityGuard/actions/workflows/build-test.yml)
[![Downloads](https://img.shields.io/github/downloads/Real-Casper/C-IntegrityGuard/total)](https://github.com/Real-Casper/C-IntegrityGuard/releases)

## 目的
C-IntegrityGuard は、デバイスのフィンガープリントとシステムプロパティを調整し、Play Integrity の STRONG 判定を取得するための root モジュールです。キーボックスの自動更新とターゲットリストの管理により、検出を回避しやすくします。

## インストール方法
1. デバイスが Magisk, KernelSU, または APatch で root 化されていることを確認してください。
2. 必要なモジュールをインストールしてください：
   - Tricky Store
   - Play Integrity Fix [INJECT] または Play Integrity Fork
3. Releases セクションから最新のリリース ZIP をダウンロードします。
4. ルートマネージャーを使用して ZIP をフラッシュします。
5. 必要に応じて再起動してください。
6. ルートマネージャーを開き、C-IntegrityGuard を見つけて Action を選択します。

## 動作
Action ボタンを押すと、以下の処理が自動で実行されます：
- Google 関連プロセスを終了し、キャッシュされた整合性データをクリアします。
- Tricky Store 用のターゲットリストを生成し、既知の検出アプリから隠します。
- ブート状態、 verified boot、保証ビットなどのシステムプロパティを、本物でロックされたデバイスに合わせた値に調整します。
- 最新のキーボックスをダウンロードし、Tricky Store にインストールします。
- Play Integrity を呼び出してデバイスのフィンガープリントを更新します。
- 成功時にトーストメッセージを表示します。

## 確認方法
Action ボタンを押した後、SPIC または Play Integrity Checker アプリを使って integrity ステータスを確認してください。成功すれば MEETS_STRONG_INTEGRITY と表示されるはずです。

## 注意点
- このモジュールは個人データを収集、送信、または保存しません。
- キーボックスのソースは公開されており、必要に応じてアップデートされます。将来のリリースでは、必要に応じてアップデートされたキーボックスが含まれます。
- トラブルシューティングの際は、Tricky Store と PIF モジュールが正しくインストールされ、機能していることを確認してください。

## ライセンス
GPL-3.0 © 2024-2025 Real-Casper