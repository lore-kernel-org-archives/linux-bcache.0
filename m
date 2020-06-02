From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache
 device
Date: Tue, 2 Jun 2020 08:54:59 +0000
Message-ID: <05e3dda28565c85f5beb0055a43ca4f685572431.camel@wdc.com>
References: <20200522121837.109651-1-colyli@suse.de>
         <20200522121837.109651-3-colyli@suse.de>
         <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
         <825e0e6e-b783-c899-bc25-38a8f2e06385@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25184 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgFBIzF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jun 2020 04:55:05 -0400
In-Reply-To: <825e0e6e-b783-c899-bc25-38a8f2e06385@suse.de>
Content-Language: en-US
Content-ID: <566ADE088CAA274F9D3B112FB6501C07@namprd04.prod.outlook.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "colyli@suse.de" <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gVHVlLCAyMDIwLTA2LTAyIGF0IDAwOjA2ICswODAwLCBDb2x5IExpIHdyb3RlOg0KPiA+ID4g
KwkJICogY2FjaGUgZGV2aWNlLg0KPiA+ID4gKwkJICovDQo+ID4gPiArCQlpZiAoYmlvX29wKGJp
bykgPT0gUkVRX09QX1pPTkVfUkVTRVRfQUxMKQ0KPiA+ID4gKwkJCW5yX3pvbmVzID0gcy0+ZC0+
ZGlzay0+cXVldWUtPm5yX3pvbmVzOw0KPiA+IA0KPiA+IE5vdDogc2VuZGluZyBhIFJFUV9PUF9a
T05FX1JFU0VUIEJJTyB0byBhIGNvbnZlbnRpb25hbCB6b25lIHdpbGwgYmUgZmFpbGVkIGJ5DQo+
ID4gdGhlIGRpc2suLi4gVGhpcyBpcyBub3QgYWxsb3dlZCBieSB0aGUgWkJDL1pBQyBzcGVjcy4g
U28gaW52YWxpZGF0aW9uIHRoZSBjYWNoZQ0KPiA+IGZvciBjb252ZW50aW9uYWwgem9uZXMgaXMg
bm90IHJlYWxseSBuZWNlc3NhcnkuIEJ1dCBhcyBhbiBpbml0aWFsIHN1cHBvcnQsIEkNCj4gPiB0
aGluayB0aGlzIGlzIGZpbmUuIFRoaXMgY2FuIGJlIG9wdGltaXplZCBsYXRlci4NCj4gPiANCj4g
Q29waWVkLCB3aWxsIHRoaW5rIG9mIGhvdyB0byBvcHRpbWl6ZWQgbGF0ZXIuIFNvIGZhciBpbiBt
eSB0ZXN0aW5nLA0KPiByZXNldHRpbmcgY29udmVudGlvbmFsIHpvbmVzIG1heSByZWNlaXZlIGVy
cm9yIGFuZCB0aW1lb3V0IGZyb20NCj4gdW5kZXJseWluZyBkcml2ZXJzIGFuZCBiY2FjaGUgY29k
ZSBqdXN0IGZvcndhcmRzIHN1Y2ggZXJyb3IgdG8gdXBwZXINCj4gbGF5ZXIuIFdoYXQgSSBzZWUg
aXMgdGhlIHJlc2V0IGNvbW1hbmQgaGFuZ3MgZm9yIGEgcXVpdGUgbG9uZyB0aW1lIGFuZA0KPiBm
YWlsZWQuIEkgd2lsbCBmaW5kIGEgd2F5IHRvIG1ha2UgdGhlIHpvbmUgcmVzZXQgY29tbWFuZCBv
biBjb252ZW50aW9uYWwNCj4gem9uZSBmYWlsIGltbWVkaWF0ZWx5Lg0KDQpJdCBpcyAxMDAlIGd1
YXJhbnRlZWQgdGhhdCBhIHpvbmUgcmVzZXQgaXNzdWVkIHRvIGEgY29udmVudGlvbmFsIHpvbmUN
CndpbGwgZmFpbC4gVGhhdCBpcyBkZWZpbmVkIGluIFpCQy9aQUMgc3BlY2lmaWNhdGlvbnMuIFJl
c2V0dGluZyBhDQpzaW5nbGUgY29udmVudGlvbmFsIHpvbmUgaXMgYW4gZXJyb3IuIFdlIGtub3cg
dGhlIGNvbW1hbmQgd2lsbCBmYWlsIGFuZA0KdGhlIGZhaWx1cmUgaXMgaW5zdGFudGFuZW91cyBm
cm9tIHRoZSBkcml2ZS4gVGhlIHNjc2kgbGF5ZXIgc2hvdWxkIG5vdA0KcmV0cnkgdGhlc2UgZmFp
bGVkIHJlc2V0IHpvbmUgY29tbWFuZCwgd2UgaGF2ZSBzcGVjaWFsIGVycm9yIGhhbmRsaW5nDQpj
b2RlIHByZXZlbnRpbmcgcmV0cmllcyBzaW5jZSB3ZSBrbm93IHRoYXQgdGhlIGNvbW1hbmQgY2Fu
IG9ubHkgZmFpbA0KYWdhaW4uIFNvIEkgYW0gbm90IHN1cmUgd2h5IHlvdSBhcmUgc2VlaW5nIGhh
bmcvbG9uZyB0aW1lIGJlZm9yZSB0aGUNCmZhaWx1cmUgaXMgc2lnbmFsZWQuLi4gVGhpcyBtYXkg
bmVlZCBpbnZlc3RpZ2F0aW9uLg0KDQoNCi0tIA0KRGFtaWVuIExlIE1vYWwNCldlc3Rlcm4gRGln
aXRhbCBSZXNlYXJjaA0K
