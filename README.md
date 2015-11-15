# BlockBreaker

# 作業メモ

## EnterFrame処理

`act`メソッドを実装したクラスのインスタンスを配列に登録し、先頭から`act`を呼ぶ。

`false`がかえってきた時点で配列から排除し、`deactivate`メソッドを呼ぶ。

1. `activate`
1. `act`
1. `deactivate`
