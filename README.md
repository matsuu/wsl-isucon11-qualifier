# matsuu/wsl-isucon11-qualifier

## これはなに

ISUCON11予選の環境をWSL2上に構築するスクリプトです。

## 構築

PowerShell上で以下を実行します。

```
# ダウンロード
git clone https://github.com/matsuu/wsl-isucon11-qualifier.git

# ディレクトリに移動
cd wsl-isucon11-qualifier

# 一時的にPowerShell実行を許可
Set-ExecutionPolicy RemoteSigned -Scope Process

# 構築スクリプト実行(引数はDistro名、インストールパス)
.\build.ps1 isucon11-qualify .\isucon11-qualify
```

## 実行

```
wsl.exe -d isucon11-qualify
```

### サイト表示確認

https://localhost/

### ベンチマーク実行

```
cd ~/bench
# 本番同様にnginx(https)へアクセスを向けたい場合
./bench -all-addresses 127.0.0.1 -target 127.0.0.1:443 -tls -jia-service-url http://127.0.0.1:4999
# isucondition(3000)へ直接アクセスを向けたい場合
./bench -all-addresses 127.0.0.1 -target 127.0.0.1:3000 -jia-service-url http://127.0.0.1:4999
```

## 関連

* [ISUCON11予選問題](https://github.com/isucon/isucon11-qualify)
* [matsuu/wsl-isucon9-qualifier](https://github.com/matsuu/wsl-isucon9-qualifier)
* [matsuu/wsl-isucon10-qualifier](https://github.com/matsuu/wsl-isucon10-qualifier)

## TODO

* エラー制御
  * 二重実行の防止
* `/etc/resolv.conf` 周りの調整
* PowerShellなんもわからん
