# NCS for AviUtl (カスタムオブジェクト)

![GitHub License](https://img.shields.io/github/license/potistudio/NCS4AU)
![GitHub Last commit](https://img.shields.io/github/last-commit/potistudio/NCS4AU)
![GitHub Downloads](https://img.shields.io/github/downloads/potistudio/NCS4AU/total)
![GitHub Release](https://img.shields.io/github/v/release/potistudio/NCS4AU)

![Thumbnail](THUMBNAIL.png)

数々の有名楽曲をリリースしている、イギリスのEDMレーベル『[NCS (NoCopyrightSounds)](https://www.youtube.com/nocopyrightsounds)』。  
彼らのYouTube動画に使用されているオーディオビジュアライザーを、AviUtlで再現できるスクリプトです。

通常、このビジュアライザーは、Maxon社が開発しているプラグイン『Trapcode Form』を使用して作成されます。  
しかしこれは、年間数万円とするサブスクリプションを契約しなければ使うことができない、高価なプラグインです。  
もちろん、Trapcode Formにはその価格に相当する膨大な機能が搭載されています。  

このスクリプトはそれら機能のうち、**オーディオビジュアライゼーション**に焦点を当て、  
無料で使いやすく、AviUtlの表現可能性を広げられるよう開発されました。

また、このスクリプトはMITライセンスで公開され、自由に改変・二次配布・商用利用が可能となっており、GitHub上で誰でも開発に参加することができます。

> [!NOTE]
> 彼らがあまりにも有名であるため、ここでは「NCS風」と表現させていただきます。

> [!IMPORTANT]  
> 実行には`rikky_module`が必要です。

## ダウンロード

ダウンロードはそれぞれ下記URLから行えます。

- [NCS for AviUtl - Releases](https://github.com/potistudio/NCS4AU/releases/latest)
- [rikky_module配布ページ | アマゾンっぽい](https://hazumurhythm.com/wev/amazon/?script=rikkymodulea2Z)

## インストール

通常のスクリプト導入方法と同様です。

<details>
<summary>通常のスクリプト導入方法</summary>
ダウンロードした.zipファイルを展開し、中身の`NCS4AU.obj`をAviUtlの`scripts`フォルダに配置してください。
</details>

## 設定項目

- ### 球サイズ
  
    球のサイズ(直径)を設定します。

- ### 周期

  ノイズの周期を設定します。
  > [!NOTE]
  > 現状、ノイズ周期はメッシュ分割数に依存して変動します。  
  > 具体的には、分割数に反比例してノイズ周期は小さくなります。  
  > (分割数２倍 → 周期1/2倍)

- ### 高さ
  
  ノイズによるディスプレイスメントの強さを設定します。  
  これは、後述のノイズ感度とは別に、無音時の基本となる変形の強さを表します。

- ### Z
  
  3DノイズにおけるZ軸の位置を設定します。  
  本スクリプトでは、3Dノイズを2Dに投影しているため、実質的にEvolutionと同様の挙動をします。

- ### 色

  エフェクトの色を設定します。

- ### 音声同期

  音声と同期させるかどうかを設定します。  
  同期では、球サイズとノイズディスプレイスメント強度の感度を設定できます。

- ### 球変換

  メッシュを球に変換します。

- ### ノイズ

  メッシュにノイズによるディスプレイスメントを適用するかを設定します。

- ### サイズ

  メッシュの描画に使用する点のサイズを設定します。  
  大きくするほど動作が重くなります。

- ### 分割数

  メッシュの分割数を設定します。  
  値が大きいほど円の描画数が増加するため、動作が重くなります。

- ### 強さ

  球変換の強さを設定します。  
  0で無変換、1で完全な球となります。（1を超えることもできます）

- ### サイズ感度

  音声同期した際の球サイズの反応の強さを設定します。  
  これは閾値ではなく倍率を表します。

- ### ノイズ感度

  音声同期した際のノイズの反応の強さを設定します。  
  これは閾値ではなく倍率を表します。

- ### ノイズ変異

  ノイズの速度を設定します。  
  `{x, y, z}`のように表します。

## 確認済み動作環境

|OS|AviUtl|拡張編集|rikky_module|
|--|--|--|--|
|Windows 10 Home (22H2)|1.10|0.92|1.1|

## 機能要望・不具合報告

[GitHub Issues](https://github.com/potistudio/NCS4AU/issues)にて報告をお願いします。  
PRも歓迎しています。 ( ´ ▽ ` )ﾉ

## LICENSE

### [MIT License](LICENSE)

- 自由に改変・再配布・商用/非商用利用が可能です。
- 開発者はいかなる責任も負いません。
