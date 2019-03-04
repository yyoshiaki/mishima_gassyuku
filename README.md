# 三島合宿日誌 <img src='img/IMG_0581.jpg'  width="30%" align="right">

三島合宿　2019/03/04-09



## Transcript assembly

### trinity install to mac

```
This formula was found in a tap:
homebrew/linuxbrew-core/v
To install it, run:
  brew install homebrew/linuxbrew-core/v
```

と怒られたのでbrew再インストール。

```
sudo ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)" # 再インストール
```

その後はうまくいきました。

### DDBJサーバーダウンによりDRSがダウンロードできない

代替出来るらしい。

```
fasterq-dump DRR092257
```


## byobu

一つのサーバーのshellに複数端末でアクセスするとして、（sshなど）共通のプロセスが見れる。ローカルの接続が切れても安心。

- [Bonoがbyobuで上手にbashのスクリプトを書いた](https://bonohu.wordpress.com/2018/01/03/bono-byobu-bash/)
- [byobu使ってみた](https://bonohu.wordpress.com/2015/08/06/byobu/)

### コマンド

- F12 + c : 新しいWindow
- F12 + p : previous Window
- F12 + n : next Window
