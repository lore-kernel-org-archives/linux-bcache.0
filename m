From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Bcache power loss
Date: Wed, 31 Dec 2014 12:46:45 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1412311244220.1491@ware.dreamhost.com>
References: <E5785778-CF11-4DC2-9E38-4F795B8D9C53@profihost.ag>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1866506367-1782675612-1420058806=:1491"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:60910 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbaLaUqr (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 31 Dec 2014 15:46:47 -0500
In-Reply-To: <E5785778-CF11-4DC2-9E38-4F795B8D9C53@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1866506367-1782675612-1420058806=:1491
Content-Type: TEXT/PLAIN; charset=US-ASCII

> Has anybody ever tested bcache against power loss?

We have had to hard reset our machine many times during the process of 
troubleshooting various lockups that have been since resolved by some of 
the patches posted to this list (attached).

I did notice in the logs that it said something about replaying 
transactions when it came up after a hard reset, so that is promising. 
Still, we reformatted all of our bcache volumes after the lockups were 
resolved just to make sure that there were no unexpected side effects and 
have not had any issues since.

 
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1866506367-1782675612-1420058806=:1491
Content-Type: TEXT/x-diff; name=bcache-rcu-sched-bugfix.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-rcu-sched-bugfix.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL2J0cmVlLmMgYi9kcml2
ZXJzL21kL2JjYWNoZS9idHJlZS5jDQppbmRleCAwMGNkZTQwLi5kMTQ1NjBh
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvYnRyZWUuYw0KKysr
IGIvZHJpdmVycy9tZC9iY2FjaGUvYnRyZWUuYw0KQEAgLTIxNjIsOCArMjE2
MiwxMCBAQCBpbnQgYmNoX2J0cmVlX2luc2VydF9jaGVja19rZXkoc3RydWN0
IGJ0cmVlICpiLCBzdHJ1Y3QgYnRyZWVfb3AgKm9wLA0KIAkJcndfbG9jayh0
cnVlLCBiLCBiLT5sZXZlbCk7DQogDQogCQlpZiAoYi0+a2V5LnB0clswXSAh
PSBidHJlZV9wdHIgfHwNCi0JCSAgICBiLT5zZXEgIT0gc2VxICsgMSkNCisJ
CSAgICBiLT5zZXEgIT0gc2VxICsgMSkgew0KKwkJCW9wLT5sb2NrID0gYi0+
Yy0+cm9vdC0+bGV2ZWwgKyAxOw0KIAkJCWdvdG8gb3V0Ow0KKwkJfQ0KIAl9
DQogDQogCVNFVF9LRVlfUFRSUyhjaGVja19rZXksIDEpOw0KLS0gDQoxLjcu
MQ0K

--1866506367-1782675612-1420058806=:1491
Content-Type: TEXT/x-diff; name=bcache-cond_resched.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-cond_resched.patch

LS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvYnRyZWUuYwkyMDE0LTExLTAzIDE2
OjUxOjAxLjcyMDAwMDAwMCAtMDgwMA0KKysrIGIvZHJpdmVycy9tZC9iY2Fj
aGUvYnRyZWUuYwkyMDE0LTExLTAzIDE2OjUxOjI2LjQ1NjAwMDAwMCAtMDgw
MA0KQEAgLTE3NDEsNiArMTc0MSw3IEBADQogCWRvIHsNCiAJCXJldCA9IGJ0
cmVlX3Jvb3QoZ2Nfcm9vdCwgYywgJm9wLCAmd3JpdGVzLCAmc3RhdHMpOw0K
IAkJY2xvc3VyZV9zeW5jKCZ3cml0ZXMpOw0KKwkJY29uZF9yZXNjaGVkKCk7
DQogDQogCQlpZiAocmV0ICYmIHJldCAhPSAtRUFHQUlOKQ0KIAkJCXByX3dh
cm4oImdjIGZhaWxlZCEiKTsNCg==

--1866506367-1782675612-1420058806=:1491--
