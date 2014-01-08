From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 1/3] bcache: For back device, stripe_size get the small value  between "1 << 31" and the io_opt of request_queue of back device.
Date: Wed, 8 Jan 2014 19:39:21 +0800
Message-ID: <201401081939186527303@gmail.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44161 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAHLj0 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Jan 2014 06:39:26 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so1451036pbb.8
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jan 2014 03:39:25 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kmo <kmo@daterainc.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

TGV0J3MgdGhlIHN0cmlwZV9zaXplIG9mIGJhY2sgZGV2aWNlIGlzIGlvX29wdCBvZiByZXF1ZXN0
X3F1ZXVlIG1ha2UNCmdvb2Qgc2Vuc2UuDQoNClNpZ25lZC1vZmYtYnk6IEppYW5wZW5nIE1hIDxt
YWppYW5wZW5nQGdtYWlsLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgfCAg
ICA2ICsrKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgYi9kcml2ZXJzL21k
L2JjYWNoZS9zdXBlci5jDQppbmRleCBjNTdiZmEwLi4yMWY3N2MxIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9tZC9iY2FjaGUvc3VwZXIuYw0KKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYw0K
QEAgLTc1OSwxMSArNzU5LDE1IEBAIHN0YXRpYyBpbnQgYmNhY2hlX2RldmljZV9pbml0KHN0cnVj
dCBiY2FjaGVfZGV2aWNlICpkLCB1bnNpZ25lZCBibG9ja19zaXplLA0KIAkJCSAgICAgIHNlY3Rv
cl90IHNlY3RvcnMpDQogew0KIAlzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcTsNCisJc3RydWN0IGNh
Y2hlZF9kZXYgKmRjOw0KIAlzaXplX3QgbjsNCiAJaW50IG1pbm9yOw0KIA0KKwlkYyA9IGNvbnRh
aW5lcl9vZihkLCBzdHJ1Y3QgY2FjaGVkX2RldiwgZGlzayk7DQorCXEgPSBiZGV2X2dldF9xdWV1
ZShkYy0+YmRldik7DQorDQogCWlmICghZC0+c3RyaXBlX3NpemUpDQotCQlkLT5zdHJpcGVfc2l6
ZSA9IDEgPDwgMzE7DQorCQlkLT5zdHJpcGVfc2l6ZSA9IG1pbl90KHVuc2lnbmVkLCAxIDw8IDMx
LCBxLT5saW1pdHMuaW9fb3B0KTsNCiANCiAJZC0+bnJfc3RyaXBlcyA9IERJVl9ST1VORF9VUF9V
TEwoc2VjdG9ycywgZC0+c3RyaXBlX3NpemUpOw0KIA0KLS0gDQoxLjcuMTAuNA0K
