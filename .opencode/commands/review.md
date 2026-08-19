---
description: 翻訳データ（hjson / TranslatedMods.csv）の変更をレビューします
agent: translation-reviewer
subtask: false
---
翻訳データの変更をレビューします。

> **レビュー専用**: ファイルの編集・作成、コミット、`gh pr review` の投稿、変更の適用確認は行わない。レビュー結果を提示して終了すること。

Input: $ARGUMENTS

## レビュー対象の決定

| 入力 | 対象 | 変更ファイル一覧の取得 |
|---|---|---|
| 引数なし | 未コミットの変更をすべて | `git diff --name-only`・`git diff --cached --name-only`・`git status --short` |
| コミットハッシュ | そのコミット | `git show <hash> --name-only --format=` |
| ブランチ名 | 指定ブランチとの差分 | `git diff <branch>...HEAD --name-only` |
| PR 番号または URL | その PR | `gh pr view <arg>`（コンテキスト）・`gh pr diff <arg> --name-only`（ファイル一覧） |

---

## 実行手順（集約）

**メインエージェント（自身）はファイルの全文読み・`tml-workshop` の実行をしない。** 以下でModをグループ化し、レビューはサブエージェントに委譲する。

1. 変更ファイル一覧を上表のコマンドで取得する
2. ファイルを**Modディレクトリ単位**（リポジトリ直下のディレクトリ）でグループ化する
   - `TranslatedMods.csv` は手順5で扱う
   - `Terraria/` は手順6で扱う
3. 各Modについて、**translation-reviewer サブエージェント**にレビューを依頼する
   - 依頼内容: Mod名（ディレクトリ名）、変更ファイル一覧、**レビュー対象種別（PR番号 / コミットハッシュ / ブランチ名 / 未コミット変更）**、レビュー指示（「レビュー手順・チェック項目・出力形式はエージェントのワークフローに従う。このModの変更分をレビューして指摘を返せ」）
   - 新規Mod・既存Modの区別なく依頼する
4. サブエージェントの結果を**Modごとに集約して提示**し、終了する
   - 終了後は追加の作業提案・修正計画を出さない
5. `TranslatedMods.csv` が変更された場合: **自身が Read / Grep でCSVチェック**する（列の妥当性・`display_name`昇順・`internal_name`=ディレクトリ名一致・新規/更新Modの行更新有無）。**PRレビューでは `gh api` でPRのCSV patchを取得し、PR適用後の状態で確認する**
6. `Terraria/` が変更された場合: サブエージェントにレビューを依頼する（バニラ翻訳のため **原文照合はスキップ**）

レビュー手順・チェック項目・出力形式は translation-reviewer エージェントのワークフローに従う。
