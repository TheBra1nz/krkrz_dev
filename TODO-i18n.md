# 多言語化 (デモの i18n / 公開ドキュメントの英語版)

デモ用の i18n 基礎ライブラリと、公開サイト (mkdocs) の英語版の方針と進捗。
索引は [TODO.md](TODO.md)。方針は 2026-10-19 に決定。

## 共通方針

- **当面の対象言語は `ja` (既定) と `en`**。将来 `chs` (簡体字中国語) を
  足せる余地を残す (今は作らない)。言語名をコード・スクリプトに直書きせず、
  「言語の丸め方と代替順」「言語ごとの設定」は表 1 か所に集める。
- 言語の丸め方と代替順はエンジンの `TVPGetMessageResourceSuffixesForTag`
  (`src/core/common/msg/MsgLanguage.cpp`) と同じ規則に揃える
  (例: zh-TW → cht → chs → en → ja、それ以外 → en → ja)。
- 用語は用語集 (`doc/i18n/glossary.md`、予定) で揃える。デモ文字列とドキュメントで共用。

## A. エンジン: 実効表示言語の公開

`System.systemLanguage` は OS の設定 (WINVER では地域 (書式) の設定) をそのまま
返すだけで、`-language=` を反映しない。エンジン内部の実効言語
(`-language=` → OS 言語) と、それを丸めた候補順を TJS から読めるようにする。

- [x] `System.uiLanguage` … 実効言語タグ (`TVPGetEffectiveMessageLanguageTag`)
- [x] `System.uiLanguageCandidates` … 丸めた候補の配列 (`["en", "ja"]` 等。末尾は常に `"ja"`)
- [x] `doc/manual/System.manual.tjs` へ追記 (2026-10-19)

目的: 判定を TJS 側で二重に持たない / エンジンのメッセージとデモの言語を必ず揃える。

## B. デモ用 i18n 基礎ライブラリ

`src/core/data/demolib/demo_i18n.tjs` (SSOT は core 側。demolib の他ファイルと同じ扱い)。
Elements 以外の描画 (drawText / setInfo / メニュー / samples.tjs の title・desc) を
多言語化する。Elements パネルは従来どおり `text_id` 等を使い、**文字列表は共用**する。

- 文字列表の形は Elements の `"strings"` と同じ `id → %[ja:…, en:…]`。
  同じ表をパネル辞書の `strings` + `lang` にもそのまま渡せる。
- 表は TJS 辞書リテラル (`strings.tjs`) を `Scripts.evalStorage` で読む
  (JSON プラグインに依存しない。web 版でもそのまま動く)。scene.tjs 内に直接書いてもよい。
- 言語は `System.uiLanguageCandidates` で決める (無い旧エンジンでは `systemLanguage` から自前で丸める)。
- 引けない場合は 候補順 → id そのもの。
- id は `<デモ名>.<キー>`、共通文字列は `common.*`。
- API (案): `I18n.t(id, args…)` / `I18n.add(table)` / `I18n.pick(%[ja:…, en:…])` /
  `I18n.language` / `I18n.setLanguage(lang)`。切替時は `ElementsDialog.language` も合わせ、
  パネルの `locale` も言語から決める (言語 → locale の表を持つ)。
- demolib 組込: `DemoScene.onLanguageChanged()` (既定 = 再描画)、DemoShell に言語切替キー。
- 検証: `-demotest` 時に引けなかった id を `@demotest:i18n-missing` で出す。

進捗:

- [x] A のエンジン変更 (2026-10-19)
- [x] `demo_i18n.tjs` 実装 + demolib 組込 (2026-10-19。F2 で切替・シーン入り直し、パネルボタンからの切替は次フレームへ遅延)
- [x] sysinfo シーンを英語対応 (最初の適用例。2026-10-19、ja / en とも表示確認・umbrella ギャラリー -demotest -language=en 全 21 シーン ok)
- [ ] 既存デモの順次移行 (新規デモは必須)
- [ ] 埋め込みデモ (doc の iframe) にページ言語を `-language=` として渡す (krkrz_web 側の引数経路を要確認)

## C. 公開ドキュメントの英語版

**対象は公開サイトの範囲だけ** (`mkdocs.yml` の `docs_dir: doc` で nav に載るもの:
`index.md` / `demos.md` / `guide/` / `tjs2/` / `reference/` / `specification/` / `topics/`)。
開発用資料 (`src/core/doc/`、README、CLAUDE.md、TODO 類、ROADMAP、docgen README) は日本語のみ。

- **mkdocs-static-i18n を接尾辞方式**で使う: `Foo.md` (日本語) の隣に `Foo.en.md`。
  出力は `/` (ja) と `/en/`。未訳ページは日本語版を出す (`fallback_to_default`)。
  nav 見出しは `nav_translations`。`languages:` は当面 ja / en のみ (chs は後で 1 項目追加)。
  フォルダ方式 (`doc/ja/` `doc/en/`) は既存リンク・`edit_uri`・生成パスを壊すので採らない。
- **手書きページ**: `.en.md` の front-matter に `source_hash` (訳した時点の日本語原文のハッシュ)。
- **reference (生成物)**: 生成 md を直接訳さない。メンバー単位の翻訳カタログを使う。
  - `tjsdoc.py --extract` → `doc/i18n/<lang>/reference/<Class>.json` (キー `Class.member`、原文ハッシュ付き)
  - `tjsdoc.py --lang <lang>` → `<Class>.<lang>.md`。訳の無い箇所は日本語のまま + 印
  - カタログは umbrella 側に置く (プラグイン submodule を触らない)
  - **形式は JSON** (PO は必要になったら変換ツールを足す)
- **鮮度チェック**: `tools/docgen/check_translations.py <lang>` が未訳・古い訳を一覧化。
  CI ではレポートのみ (ビルドは落とさない)。ツールは言語を引数で受け、`en` を直書きしない。
- 優先度を下げるページ (開発寄り): `topics/core/steamdeck.md` / `memory_observation.md` /
  `draw_stats.md` / `engine_setting.md` (日本語フォールバックのままでよい)。
- 下訳は機械 (Claude)、人がレビュー。コード例はそのまま (コメントは任意で訳す)、画像は共用。

段階:

- [ ] Phase 0: 土台 (プラグイン導入 + requirements + CI、切替 UI、nav 訳、check スクリプト、カタログ抽出)
- [ ] Phase 1: トップ / about / 起動 / デモ一覧
- [ ] Phase 2: reference の主要クラス
- [ ] Phase 3: guide / tjs2 / specification / topics
