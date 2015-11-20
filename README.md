# BlockBreaker

# 作業メモ

## ToDo

1. score表示
1. contextの移動

## Pending

### 毎フレーム処理の管理を配列から連結リストに変える。

今のところ挿入と削除のコストが問題になる処理はないので保留。

# Context

複数のContextが存在し、RootContextが一つだけ存在する。

各ContextはRootへの参照を持つ。

ContextによるEnterFrameはRootが一元管理する。

beOnStage(actor)によるactor登録はRootへの参照があればRootに移譲され、なければそれがRootなので官吏を行う。

BaseContextを継承したContextはDisplayObject格納用に`view`を持つので、自分の表示はそこで行う。

Context#emitにより上部routerにイベントを伝播させることができる。

## EnterFrame処理

1. 計算処理
2. アニメーション処理

の順で行う。

## EnterFrame計算処理

Context#write(fn:Context -> Void)により処理を登録する。

Context#erase(fn:Context -> Void)で処理を除去できる。

## EnterFrameアニメーション処理

`act`メソッドを実装したクラスのインスタンスを配列に登録し、先頭から`act`を呼ぶ。

`false`がかえってきた時点で配列から排除し、`deactivate`メソッドを呼ぶ。

1. `beOnStage(actor)` で `actor.activate(context, view)` が呼ばれる。
1. `act`
1. `deactivate`
