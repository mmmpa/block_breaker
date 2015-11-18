# BlockBreaker

# 作業メモ

## ToDo

1. プレイフィールドの壁からの反射（およびミス）計算
1. ブロックからの弾の反射計算
1. ショックウェーブによる弾の反射計算
1. 弾の移動処理
1. ブロックの破壊処理
1. ゲーム開始処理

とりあえず今週中目標。

## Context

複数のContextが存在し、RootContextが一つだけ存在する。

各ContextはRootへの参照を持つ。

ContextによるEnterFrameはRootが一元管理する。

beOnStage(actor)によるactor登録はRootへの参照があればRootに移譲され、なければそれがRootなので官吏を行う。

BaseContextを継承したContextはDisplayObject格納用に`view`を持つので、自分の表示はそこで行う。

Context#emitにより上部routerにイベントを伝播させることができる。

### EnterFrame処理

`act`メソッドを実装したクラスのインスタンスを配列に登録し、先頭から`act`を呼ぶ。

`false`がかえってきた時点で配列から排除し、`deactivate`メソッドを呼ぶ。

1. `beOnStage(actor)` で `actor.activate(context, view)` が呼ばれる。
1. `act`
1. `deactivate`
