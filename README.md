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
sudo ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)" # brew削除
```

その後はうまくいきました。

### DDBJサーバーダウンによりDRRがダウンロードできない

代替出来るらしい。

```
fasterq-dump DRR092257
```

### githubからソースを直接ダウンロード

[teratail : githubからファイル単体をclone(DL)できる？](https://teratail.com/questions/14124)

```
curl -O https://github.com/bonohu/denovoTA/blob/master/for_trinity.pl
```

->

```
curl -O https://raw.githubusercontent.com/bonohu/denovoTA/master/for_trinity.pl
```

### trinity

Trinity v2.8.3だとsalmonが要求された。

```
conda create -n salmon salmon # v0.12.0
conda activate salmon
```

自分のMBPだけらしい。なぜ？

## byobu

一つのサーバーのshellに複数端末でアクセスするとして、（sshなど）共通のプロセスが見れる。ローカルの接続が切れても安心。

- [Bonoがbyobuで上手にbashのスクリプトを書いた](https://bonohu.wordpress.com/2018/01/03/bono-byobu-bash/)
- [byobu使ってみた](https://bonohu.wordpress.com/2015/08/06/byobu/)

### コマンド

[https://linuxfan.info/terminal-with-byobu](https://linuxfan.info/terminal-with-byobu)

- F2 ／ エスケープキー C : 新しいウィンドウを作る
- F3 ／ エスケープキー P ／ Alt + ← : 前のウィンドウに切り替える
- F4 ／ エスケープキー N ／ Alt + → : 次のウィンドウに切り替える
- F5 : プロファイルをリロードする
- F6 ／ エスケープキー D : デタッチする
- F7 : スクロールバック／検索モードに切り替える
- F8 : ウィンドウのタイトルを変更する
- F9 : Byobuの設定メニューを表示する
- Alt-Pageup : 上にスクロール
- Alt-Down : 下にスクロール
- Shift-F2 : ウィンドウを横に分割
- Ctrl-F2 : ウィンドウを縦に分割
- Shift-F3 : 次のスプリットに切り替える
- Shift-F4 : 前のスプリットに切り替える

しかしMBPで落ちまくるのでひとまず放置。落ちるタイミングはconfigを開こうとしたとき。


## QuickLookのプラグインがいっぱいある

[小野さん](https://github.com/hiromasaono)発信。便利。

[Mac の QuickLook で プラグインをまとめてインストールする](https://qiita.com/exabugs/items/9a392077c492ed97950d)

![img](img/preview_md.png)

## salmonがmacで動かない問題

```
conda create -n salmon salmon # v0.12.0
conda activate salmon

salmon index --threads 4 --transcripts gencode.vM19.transcripts.fa.gz --index salmon_index_mouse --type quasi -k 31 --gencode

salmon quant -i salmon_index_mouse \
      -l A \
      -r SRR1269711_trimmed.fastq.gz   \
      -p 4 \
      -o salmon_output_SRR1269711 \
      --gcBias
```

これは動いたが、[https://github.com/yyoshiaki/auto_counttable_maker/blob/master/MakeCountTable_Illumina_trimgalore_SRR.sh#L316-L341](https://github.com/yyoshiaki/auto_counttable_maker/blob/master/MakeCountTable_Illumina_trimgalore_SRR.sh#L316-L341)動かず。。。

`combinelab/salmon:0.12.0`にしてもだめ。

indexをつくる途中で止まっている。

## kallisto output -> idep

tximportでまとめる。
[https://github.com/yyoshiaki/auto_counttable_maker/blob/master/tximport_R.R](https://github.com/yyoshiaki/auto_counttable_maker/blob/master/tximport_R.R)

ensemblはいろんな生物種を扱う人にはいい。確かに。人とマウスならやっぱり[GENCODE](https://www.gencodegenes.org/)。

ensemblはbiomartでいろんなテーブルが作れる。transcriptのversion付のもの（ENST00000254657.3）がrow nameになるのでめんどくさい。やはり、ヒト、マウスならGENCODEかな。

## [GENDO](https://gendoo.dbcls.jp/)

MeSH vocabularyをOMIMを使って遺伝子と紐づけしたデータベース。

> Nakazato, T., Bono, H., Matsuda, H. & Takagi, T. Gendoo: Functional profiling of gene and disease features using MeSH vocabulary. Nucleic Acids Res. 37, W166–W169 (2009).

![img](http://motdb.dbcls.jp/?plugin=ref&page=AJACS7%2Fthecla&src=nar.fig1.png)
