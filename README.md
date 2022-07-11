# GithubViewer
## 環境設定
### Homebrewのインストール
```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

下記Warningが表示された場合は、手動でNext stepsに記載されているコマンドを実行
```
Warning: /opt/homebrew/bin is not in your PATH.
  Instructions on how to configure your shell for Homebrew
  can be found in the 'Next steps' section below.
```

### rbenvのセットアップ
```
$ brew install rbenv ruby-build
$ rbenv init
  # Load rbenv automatically by appending
  # the following to ~/.zshrc:

  eval "$(rbenv init - zsh)"
$ echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc # パスを通す
$ source .zshrc
$ rbenv install 3.1.2 # 2022/06/30 時点の安定版
$ rbenv versions 
* system
  3.1.2 # 3.1.2がインストールされていることを確認
$ cd ./Feed # プロジェクトのルートディレクトリに移動 パスは適宜読み替える
$ rbenv local 3.1.2 # feedディレクトリ内のRuby Versionが3.1.2に指定
$ ruby -v # ruby 3.1.2のパスが通っていることを確認する
```

### bundlerのインストール
```
$ gem install bundler
$ rbenv rehash
$ bundler -v
  Bundler version 2.3.17
$ bundle install
```

### Cocoapods
```
$ bundle exec pod install # プロジェクトのルートディレクトリ配下で実行
```

## 環境変数の設定
### 暗号化ファイルの復号化
事前に共有しています、パスワードを用いて秘匿化しているファイルを復号化します。

```
$ openssl enc -aes-256-cbc -d -in .encrypted-env -out .env # プロジェクトのルートディレクトリ配下で実行
enter aes-256-cbc decryption password:【指定したパスワード】
```

### Enviroment.swiftの生成
GithubViewer.xcworkspaceからプロジェクトを開き、``BuildTools``スキームを選択して一度ビルドします。
ビルドに成功すると``GithubViewer/Resource/Enviroment.swift``が生成されます。

※環境変数の設定を行わずにビルドは行えないので注意してください。
