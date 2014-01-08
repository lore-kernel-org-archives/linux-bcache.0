From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 2/3] bcache: Avoid hung task happen.
Date: Wed, 8 Jan 2014 19:39:26 +0800
Message-ID: <201401081939218365334@gmail.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34923 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAHLja (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Jan 2014 06:39:30 -0500
Received: by mail-pb0-f54.google.com with SMTP id un15so1466582pbc.41
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jan 2014 03:39:30 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kmo <kmo@daterainc.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

QmVjYXVzZSBhZnRlciBrdGhyZWFkX2NyZWF0ZSwgdGhlIHN0YXRlIG9mIGt0aHJlYWQgaXMgVEFT
S19VTklOVEVSUlVQVElCTEUuDQpJZiB3ZSBkb24ndCB3YWtlIHVwIGRjLT53cml0ZWJhY2tfdGhy
ZWFkLCB0aGUgdGhyZWFkIHdpbGwgYmUgaHVuZy10YXNrLg0KRm9yIHRob3NlIHJlYXNvbnMsIHdl
IGRvbid0IHdha2UgdXAgd3JpdGViYWNrX3RocmVhZDoNCkE6b25seSBjcmVhdGUgYmFja2VkIGRl
dmljZQ0KQjpjcmVhdGUgYmFja2VkIGRldmljZSBhbmQgY2FjaGUgZGV2aWNlLCBidXQgZG9uJ3Qg
d3JpdGUgYXQgb25jZQ0KQzp3cml0ZSB3aXRob3V0IHdyaXRlYmFjayBwb2xpeQ0KDQpTbyBsaWtl
IHRoZSB3YXkgb2YgY3JlYXRlIGdjX3RocmVhZCwgYWZ0ZXIgY3JlYXRpbmcgd3JpdGViYWNrX3Ro
cmVhZCwgaQ0Kc2V0IHRoZSBzdGF0ZSBpcyBUQVNLX0lOVEVSUlVQVElCTEUuDQoNClNpZ25lZC1v
ZmYtYnk6IEppYW5wZW5nIE1hIDxtYWppYW5wZW5nQGdtYWlsLmNvbT4NCi0tLQ0KIGRyaXZlcnMv
bWQvYmNhY2hlL3dyaXRlYmFjay5jIHwgICAgMiArKw0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3dyaXRlYmFjay5jIGIv
ZHJpdmVycy9tZC9iY2FjaGUvd3JpdGViYWNrLmMNCmluZGV4IDZjNDRmZTAuLjdmYmMyMmEgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL21kL2JjYWNoZS93cml0ZWJhY2suYw0KKysrIGIvZHJpdmVycy9t
ZC9iY2FjaGUvd3JpdGViYWNrLmMNCkBAIC00OTksNiArNDk5LDggQEAgaW50IGJjaF9jYWNoZWRf
ZGV2X3dyaXRlYmFja19pbml0KHN0cnVjdCBjYWNoZWRfZGV2ICpkYykNCiAJaWYgKElTX0VSUihk
Yy0+d3JpdGViYWNrX3RocmVhZCkpDQogCQlyZXR1cm4gUFRSX0VSUihkYy0+d3JpdGViYWNrX3Ro
cmVhZCk7DQogDQorCXNldF90YXNrX3N0YXRlKGRjLT53cml0ZWJhY2tfdGhyZWFkLCBUQVNLX0lO
VEVSUlVQVElCTEUpOw0KKw0KIAlJTklUX0RFTEFZRURfV09SSygmZGMtPndyaXRlYmFja19yYXRl
X3VwZGF0ZSwgdXBkYXRlX3dyaXRlYmFja19yYXRlKTsNCiAJc2NoZWR1bGVfZGVsYXllZF93b3Jr
KCZkYy0+d3JpdGViYWNrX3JhdGVfdXBkYXRlLA0KIAkJCSAgICAgIGRjLT53cml0ZWJhY2tfcmF0
ZV91cGRhdGVfc2Vjb25kcyAqIEhaKTsNCi0tIA0KMS43LjEwLjQNCg==
