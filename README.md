# 三島合宿日誌 <img src='img/IMG_0581.jpg'  width="30%" align="right">

三島合宿　2019/03/04-08

[坊農さん](https://twitter.com/bonohu)のご厚意で一週間三島の遺伝研で合宿させていただけることに。雪化粧の富士山と咲き始めた桜が一度に楽しめる贅沢な季節です。その中での学びをまとめます。

## Transcript assembly

transcriptomeへの理解を得ようとtranscript assemblyを試みる。

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

ほぼ丸二日かかって完成！

```
$ grep > Trinity.fasta  | wc -l
```

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

かの[togotv](http://togotv.dbcls.jp/)で[小野さん](https://github.com/hiromasaono)発信。便利。

[Mac の QuickLook で プラグインをまとめてインストールする](https://qiita.com/exabugs/items/9a392077c492ed97950d)

![img](img/preview_md.png)

## [Refex](http://refex.dbcls.jp/index.php?lang=ja)

[小野さん](https://github.com/hiromasaono)作。組織特異的な遺伝子発現量や、オントロジー、gene familyなどがまとまっている。CAGEがとても使いやすい。

![img]()

ESTなる実験手法が昔は使われていたらしいことも学ぶ。

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

ensemblはbiomartでいろんなテーブルが作れる。transcriptのversion付のもの（ENST00000254657.3）がrow nameになるのでめんどくさい。.以下をperlで落とすやり方も聞いたが、tximportで落とすならめんどくさい。やはり、ヒト、マウスならGENCODEかな。

ちなみに、salmon or sailfishなら、mikelove氏の[tximeta](https://bioconductor.org/packages/release/bioc/vignettes/tximeta/inst/doc/tximeta.html)（tximportの後継）で一発。kallistoは対応していない。

```
dir <- system.file("extdata/salmon_dm", package="tximportData")
# here gzipped, normally these are not
files <- file.path(dir, "SRR1197474_cdna", "quant.sf.gz")
# file.exists(files)

coldata <- data.frame(files, names="SRR1197474", condition="A", stringsAsFactors=FALSE)
# coldata

library(tximeta)
se <- tximeta(coldata)

gse <- summarizeToGene(se)
```

DESeq2への受け渡しもすぐ。

```
suppressPackageStartupMessages(library(DESeq2))
# here there is a single sample so we use ~1.
# expect a warning that there is only a single sample...
suppressWarnings({dds <- DESeqDataSet(gse, ~1)})
## using counts and average transcript lengths from tximeta
dds <- estimateSizeFactors(dds)
```

## R update on Mac

久々のローカル環境で、Rが3.4だったため、アップデートを試みる。

1. [Rが3.5.0へメジャーアップデートしたので簡単アップデート](https://makoto-shimizu.com/news/r-3-5-is-released/) : だめだった
2. [https://stackoverflow.com/questions/13656699/update-r-using-rstudio](https://stackoverflow.com/questions/13656699/update-r-using-rstudio)

[https://cran.r-project.org/](https://cran.r-project.org/)から落とす。恐れずにインストーラーで入れてみた。Rstudioを再起動したら入ってた。その後、`update.packages() `でパッケージのアップデート。

## [GENDOO](https://gendoo.dbcls.jp/)

MeSH vocabularyをOMIMを使って遺伝子と紐づけしたデータベース。gene setに対する応用はchi2 distの再生性を使えばOK?（メモ）

> Nakazato, T., Bono, H., Matsuda, H. & Takagi, T. Gendoo: Functional profiling of gene and disease features using MeSH vocabulary. Nucleic Acids Res. 37, W166–W169 (2009).

![img](http://motdb.dbcls.jp/?plugin=ref&page=AJACS7%2Fthecla&src=nar.fig1.png)

## [cDNA viewer](http://fantom3.gsc.riken.jp/public/annotate/main.cgi?masterid=random)

FANTOMの可視化。今のようなgenomeに対する可視化ではなく、cDNAに対する可視化を行っていた。randomにしていたのは開発テスト用。

![img](img/cDNAviewer.png)

ちなみにFANTOM話でもう一つ震えるような話を聞いた。

> 山中伸弥教授らは、人工多能性幹細胞(iPS細胞)の樹立研究において、FANTOMデータベースから、細胞の初期化因子候補として24種の転写因子を選定しました

[FANTOM](http://fantom.gsc.riken.jp/jp/)

[スライド](https://www.slideshare.net/sayamatcher/dbcls-sponsored-session-introduction)も

## [gggenome](http://gggenome.dbcls.jp/), [ggrna](http://ggrna.dbcls.jp/)

少し前から使ってたが、作者の[meso_cacase](https://twitter.com/meso_cacase)さんと出会う。恐るべしDBCLS。ちなみに個人的な好みはpandasでの呼び出し。[scikit-bio](http://scikit-bio.org/)と組み合わせて使った。

```
import pandas as pd

df = pd.read_csv('http://gggenome.dbcls.jp/mm10/2/+/TTCATTGACAACATTGCGT.txt', sep='\t', comment='#')
```

## ドーミーイン三島

屋上の露天風呂から富士山がみえる（らしい）。場所も三島から歩いて5分以内でいい感じ。どうやらここが正解と思っていいらしい。ただし、初日回線が100kb/sでgtfのダウンロードすらままならなかった。その後は比較的速く、隣人のネット状況に依存するように思う。優先との速度比較を行った。

- 無線 :
- 有線 :

しまった、コネクタを遺伝研に忘れた。これは明日。
