# 基本構造

# Router

RouterはContextインスタンスを表示するDisplayObjectContainerである。

Routerは基本的に重要なステートを持たず、Contextのインスタンス化とイベントの伝播のみを行う。

## 最初のRouter

rootとなるDisplayObjectContainerにルートRouterを追加する。

インスタンス化はRouterが行うのでクラスをそのまま渡す。

第2引数はContextのnewメソッドの第2引数として渡される。nullable。

```haxe
addChild(Router.asRoot(MainContext, route));
```

## Contextのインスタンス化

RouterはContextの追加時、切替時にContextクラスを渡され、それをインスタンス化する。

```haxe
router.push(MainContext, routeData);
router.replace(MainContext, routeData);
```

RouterはContextのインスタンスを一つだけしか持てない。pushあるいはreplaceでContextを変更できる。古いContextのインスタンスは入念に破棄される。

インスタンス化後にRouterのプロパティとして保持されるので、Routerへの反映を待って動作させるにはaddEventListenerを利用する。

```
addEventListener(ContextCreatedEvent.CREATED, function(e:ContextCreatedEvent) {
  if (e.forMe(that) && route != null) {
    go(route);
  }
});
```

## イベントの伝播

Context#emitでイベントを送出すると以下の順番で伝播する。

1. そのcontext
1. そのcontextが属するrouter
1. そのcontextが属するrouterの親routerに属するcontext
1. そのcontextが属するrouterの親router
1. 繰り返し

Router#emitにおいてもまずそのrouterのcontextへと送出される。


# Context

viewとmodelを結びつける、controllerかつDisplayObjectのコンテナ。

## EnterFrame処理の一元管理

特にアニメーション処理をactメソッドで、計算処理をplanメソッドで行う。

actで動作するviewオブジェクトをとくにactorと呼ぶ。

planで行う処理を特にbookと呼ぶ。

処理順序は以下の通り。

1. 自分のplanメソッド
1. 下位Contextのplanメソッド
1. 自分のactメソッド
1. 下位Contextのactメソッド

全ての計算処理が行われてからviewへの反映が行われる。

### act

addAcrorでactorsリストに追加されたactorのactメソッドを毎フレーム呼ぶ。

actメソッドがtrueを返せば継続、falseを返せばactorのdeactivateメソッドを呼ぶ。

下位Contextから移譲されたactorsはその後に実行される。

### plan

addBookでbooksリストに追加された関数、およびメソッドを実行する。

引数にはContext自身が渡される。

下位Contextから移譲されたbooksはその後に実行される。下位Contextのbookには下位Context自身が渡される。

## 下位Context

子Routerを子に持つことにより、別のContextを表示する。

子Routerに自分が属するRouterを渡すことにより、下部からのイベントが伝播される。

子Routerに自分自身かrootContextを渡すことにより、Contextの毎フレーム処理を移譲される。

```haxe
god = Router.asChild(router, this);
menu = Router.asChild(router, this);
body = Router.asChild(router, this);
```

### 下位ContextのaddActorとaddBook

下位Contextは自分自身ではEnterFrameを行わず、自分自身をrootContextのsubActorsとsubBooksに挿入することにより処理を行う。

下位Context自身のactとplanを読んで実行するため、処理は自分がrootContextであった場合とかわりはない。

## シーンチェンジ

特に下位Contextからの処理依頼を扱うために、registerSceneとgoメソッドを持つ。

### マップの登録

シーンの名前と呼び出される関数、あるいはメソッドをセットで登録する。

```haxe
registerScene('/test/parts', function(scene:SceneChangeData) {
  menu.replace(TestMenuContext, null);
  body.replace(PartsTestContext, scene.prop);
});
```

### 発動

SceneChangeDataの第2引数には任意のオブジェクトインスタンスを持たすことができる。

```haxe
go(new SceneChangeData('/test/parts'));
```
