From: =?utf-8?B?67CV67OR7LKgL+yEoOyehOyXsOq1rOybkC9TVyBQbGF0Zm9ybSjsl7ApQU9U?=
         =?utf-8?B?7YyAKGJ5dW5nY2h1bC5wYXJrQGxnZS5jb20p?=
        <byungchul.park@lge.com>
Subject: RE: [PATCH 04/12] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 26 Sep 2017 15:39:45 +0900
Message-ID: <F6531D8286A0B34FBC858F176F70796281EEAA@LGEVEXMBHQSVC1.LGE.NET>
References: <20170906062602.50497-1-colyli@suse.de>
 <20170906062602.50497-5-colyli@suse.de>
 <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com>
Content-Language: ko-KR
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Coly Li <colyli@suse.de>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Eric Wheeler <bcache@lists.ewheeler.net>, Byungchul Park <byungchul.park@lge.com>, Kent Overstreet <kent.overstreet@gmail.com>, "kernel-team@lge.com" <kernel-team@lge.com>
List-Id: linux-bcache@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWNoYWVsIEx5bGUgW21haWx0
bzptbHlsZUBseWxlLm9yZ10NCj4gU2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDI2LCAyMDE3IDE6
MzggUE0NCj4gVG86IENvbHkgTGkNCj4gQ2M6IGxpbnV4LWJjYWNoZUB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWJsb2NrQHZnZXIua2VybmVsLm9yZzsNCj4gYXhib2VAa2VybmVsLmRrOyBFcmljIFdo
ZWVsZXI7IEJ5dW5nY2h1bCBQYXJrOyBLZW50IE92ZXJzdHJlZXQNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCAwNC8xMl0gYmNhY2hlOiBEb24ndCByZWludmVudCB0aGUgd2hlZWwgYnV0IHVzZSBleGlz
dGluZw0KPiBsbGlzdCBBUEkNCj4gDQo+IEkgYmVsaWV2ZSB0aGlzIGludHJvZHVjZXMgYSBjcml0
aWNhbCBidWcuDQo+IA0KPiBjbC0+bGlzdCBpcyB1c2VkIHRvIGxpbmsgdG9nZXRoZXIgdGhlIGxs
aXN0cyBmb3IgYm90aCB0aGluZ3Mgd2FpdGluZywNCj4gYW5kIGZvciB0aGluZ3MgdGhhdCBhcmUg
YmVpbmcgd29rZW4uDQo+IA0KPiBJZiBhIGNsb3N1cmUgdGhhdCBpcyB3b2tlbiBkZWNpZGVzIHRv
IHdhaXQgYWdhaW4sIGl0IHdpbGwgY29ycnVwdCB0aGUNCj4gbGxpc3QgdGhhdCBfX2Nsb3N1cmVf
d2FrZV91cCBpcyB1c2luZy4NCj4gDQo+IFRoZSBwcmV2aW91cyBpdGVyYXRpb24gc3RydWN0dXJl
IGdldHMgdGhlIG5leHQgZWxlbWVudCBvZiB0aGUgbGlzdA0KPiBiZWZvcmUgd2FraW5nIGFuZCBp
cyB0aGVyZWZvcmUgc2FmZS4NCg0KRG8geW91IG1lYW4gd2UgaGF2ZSB0byB1c2UgbGxpc3RfZm9y
X2VhY2hfZW50cnlfc2FmZSgpIGluc3RlYWQgb2Ygbm9uLXNhZmUgdmVyc2lvbj8NCklzIGl0IG9r
IGlmIHdlIHVzZSBpdCBpbnN0ZWFkPw0KDQo+IE1pa2UNCg==
