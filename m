From: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH 2/3] bcache: Avoid hung task happen.
Date: Thu, 9 Jan 2014 11:00:00 +0800
Message-ID: <201401091059579428371@gmail.com>
References: <201401081939218365334@gmail.com>,
	<20140108213402.GG7291@kmo-pixel>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:61980 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaAIDAH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Jan 2014 22:00:07 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so2566528pdj.30
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jan 2014 19:00:05 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kmo <kmo@daterainc.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

Pk9uIFdlZCwgSmFuIDA4LCAyMDE0IGF0IDA3OjM5OjI2UE0gKzA4MDAsIG1hamlhbnBlbmcgd3Jv
dGU6DQo+PiBCZWNhdXNlIGFmdGVyIGt0aHJlYWRfY3JlYXRlLCB0aGUgc3RhdGUgb2Yga3RocmVh
ZCBpcyBUQVNLX1VOSU5URVJSVVBUSUJMRS4NCj4+IElmIHdlIGRvbid0IHdha2UgdXAgZGMtPndy
aXRlYmFja190aHJlYWQsIHRoZSB0aHJlYWQgd2lsbCBiZSBodW5nLXRhc2suDQo+PiBGb3IgdGhv
c2UgcmVhc29ucywgd2UgZG9uJ3Qgd2FrZSB1cCB3cml0ZWJhY2tfdGhyZWFkOg0KPj4gQTpvbmx5
IGNyZWF0ZSBiYWNrZWQgZGV2aWNlDQo+PiBCOmNyZWF0ZSBiYWNrZWQgZGV2aWNlIGFuZCBjYWNo
ZSBkZXZpY2UsIGJ1dCBkb24ndCB3cml0ZSBhdCBvbmNlDQo+PiBDOndyaXRlIHdpdGhvdXQgd3Jp
dGViYWNrIHBvbGl5DQo+PiANCj4+IFNvIGxpa2UgdGhlIHdheSBvZiBjcmVhdGUgZ2NfdGhyZWFk
LCBhZnRlciBjcmVhdGluZyB3cml0ZWJhY2tfdGhyZWFkLCBpDQo+PiBzZXQgdGhlIHN0YXRlIGlz
IFRBU0tfSU5URVJSVVBUSUJMRS4NCj4NCj5JJ3ZlIHNlZW4gdGhpcyBpc3N1ZSwgYnV0IHRoaXMg
aXNuJ3QgZXZlbiB3aGVyZSB0aGUgc2xlZXAgaGFwcGVucywNCj50aGVyZSdzIG5vIHdheSB0aGlz
IGNvdWxkIGJlIGZpeGluZyBpdC4uDQpZZXMuQnV0IG5vdywgdGhlIGRlZmF1bHQgY2FjaGUgbW9k
ZSBpcyB3cml0ZXRocm91Z2guU28ga2VybmVsIGFsc28gcHJpbnRrIGh1bmctdGFzayBtZXNzYWdl
cy4NCklmIHlvdSBkb24ndCBsaWtlIHRoaXMgd2F5LCB5b3UgY2FuIHVzZSBrdGhyZWFkX3J1biBp
bnN0ZWFkIGt0aHJlYWRfY3JlYXRlLg0KQmVjYXVzZSB5b3UgdGVzdCBkYy0+aGFzX2RpcnR5IGlu
IGJjaF93cml0ZWJhY2tfdGhyZWFkLHNvIHVzaW5nIGt0aHJlYWRfcnVuIGlzIHNhZmUuDQoNClRo
YW5rcyENCkppYW5wZW5nIE1hDQoNCg0K
