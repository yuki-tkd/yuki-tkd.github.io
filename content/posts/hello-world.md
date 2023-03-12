---
title: "Netcode for GameObjectsで大容量データを送受信する"
date: 2023-03-12T07:24:17Z
tags: [Unity]
---


## 背景
Netcode for GameObjects(NGO) の [Custom messages](https://docs-multiplayer.unity3d.com/netcode/current/advanced-topics/message-system/custom-messages) で2KB程度のメッセージを送ろうとしたら、`Reading past the end of the buffer` というエラーで送信できなかった。

## 原因
NGOは `com.unity.transport` 上に構築した `UnityTransport` を利用してクライアント・サーバ間の通信を行っている。どちらもUnityTransportと呼ばれていて分かりづらいが、前者はUnity本体の機能で、後者はNGOの機能。

ベースとなる `com.unity.transport` がUDPで通信しているため、MTU(1500 Bytes程度が一般的)を超えるPayloadを1つのPacketで送受信できないのが問題。

## 対策
`Fragmentation` という **Payloadを複数のPacketに分割送信する機能** を利用する。

NGOのチュートリアルには書かれていないが、[CustomMessagingManager.SendNamedMessage()](https://docs-multiplayer.unity3d.com/netcode/current/api/Unity.Netcode.CustomMessagingManager/#sendnamedmessagestring-uint64-fastbufferwriter-networkdelivery) の引数に `NetworkDelivery` というQoSを指定する項目が存在する。

指定可能な `NetworkDelibery` は、[ここ](https://docs-multiplayer.unity3d.com/netcode/current/api/Unity.Netcode.NetworkDelivery/index.html) から選択可能。


- Realiable / Unreliable = メッセージの到着保証を行うかどうか
- Sequenced = メッセージの到着**順**保証を行うかどうか
- Fragmented = メッセージの分割送受信をサポートするかどうか

今回はメッセージを分割送信したいので、 `ReliableFragmentedSequenced` を選べば良い。


## 余談

### RPC
`Custom Message` ではなく `RPC` にもQoSを設定する項目はあるが、`v1.2.0` の時点では [Fragmentationに対応していない](https://docs-multiplayer.unity3d.com/netcode/current/advanced-topics/message-system/reliability/index.html) ようなので、RPC用途であったとしてもMTUを超えるデータ量がある場合は CustomMessageを利用することになりそう。

### 通信量制御
[こちらの記事](https://qiita.com/tsune2ne/items/00049e66ca3ee7fa96a5) に詳述されている通り、通信量が過剰になった際の対処は入っていない。大量にデータを送りすぎると NetworkManagerのQueueが肥大化してGCにKillされてしまうので注意。