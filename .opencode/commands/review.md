---
description: 翻訳データ（hjson / TranslatedMods.csv）の変更をレビューします
agent: translation-reviewer
subtask: true
---
翻訳データの変更をレビューします。

> **レビュー専用**: ファイルの編集・作成、コミット、`gh pr review` の投稿は行わないでください。

Input: $ARGUMENTS

## レビュー対象の決定

| 入力 | 対象 | 実行コマンド |
|---|---|---|
| 引数なし | 未コミットの変更をすべて | `git diff`・`git diff --cached`・`git status --short` |
| コミットハッシュ | そのコミット | `git show <hash>` |
| ブランチ名 | 指定ブランチとの差分 | `git diff <branch>...HEAD` |
| PR 番号または URL | その PR | `gh pr view <arg>`・`gh pr diff <arg>` |

`git diff` は未ステージング、`git diff --cached` はステージング済み、`git status --short` は未追跡の新規ファイルを確認する。

---

レビュー手順・チェック項目・出力形式は translation-reviewer エージェントのワークフローに従う。
