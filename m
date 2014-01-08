From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 3/3] bcache: Fix the bug about cal nr_stripes of backed device
Date: Wed, 8 Jan 2014 19:39:28 +0800
Message-ID: <201401081939244995495@gmail.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45705 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAHLjc (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Jan 2014 06:39:32 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so1476846pbb.37
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jan 2014 03:39:31 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kmo <kmo@daterainc.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

SW4gZnVuYyBiY2FjaGVfZGV2aWNlX2luaXQoKSxpdCB1c2UgdGhpcyBleHByZXNzaW9uIHRvIGNh
bCBucl9zdHJpcGVzOg0KImQtPm5yX3N0cmlwZXMgPSBESVZfUk9VTkRfVVBfVUxMKHNlY3RvcnMs
IGQtPnN0cmlwZV9zaXplKSIuDQpCdXQgdGhlIHVuaXQgb2YgZC0+c3RyaXBlX3NpemUgaXMgYnl0
ZSx0aGUgdW5pdCBvcyBzZWN0b3JzIGlzIHNlY3Rvci4NClNvIHdlIHNob3VsZCByZXBsYWNlIHNl
Y3RvcnMgd2l0aCAic2Vjb3RycyA8PCA5Ii4NCg0KU2lnbmVkLW9mZi1ieTogSmlhbnBlbmcgTWEg
PG1hamlhbnBlbmdAZ21haWwuY29tPg0KLS0tDQogZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYyB8
ICAgIDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgYi9kcml2ZXJzL21kL2Jj
YWNoZS9zdXBlci5jDQppbmRleCAyMWY3N2MxLi42Mzk0ZGQ2IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9tZC9iY2FjaGUvc3VwZXIuYw0KKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYw0KQEAg
LTc2OSw3ICs3NjksNyBAQCBzdGF0aWMgaW50IGJjYWNoZV9kZXZpY2VfaW5pdChzdHJ1Y3QgYmNh
Y2hlX2RldmljZSAqZCwgdW5zaWduZWQgYmxvY2tfc2l6ZSwNCiAJaWYgKCFkLT5zdHJpcGVfc2l6
ZSkNCiAJCWQtPnN0cmlwZV9zaXplID0gbWluX3QodW5zaWduZWQsIDEgPDwgMzEsIHEtPmxpbWl0
cy5pb19vcHQpOw0KIA0KLQlkLT5ucl9zdHJpcGVzID0gRElWX1JPVU5EX1VQX1VMTChzZWN0b3Jz
LCBkLT5zdHJpcGVfc2l6ZSk7DQorCWQtPm5yX3N0cmlwZXMgPSBESVZfUk9VTkRfVVBfVUxMKHNl
Y3RvcnMgPDwgOSwgZC0+c3RyaXBlX3NpemUpOw0KIA0KIAlpZiAoIWQtPm5yX3N0cmlwZXMgfHwN
CiAJICAgIGQtPm5yX3N0cmlwZXMgPiBJTlRfTUFYIHx8DQotLSANCjEuNy4xMC40DQo=
