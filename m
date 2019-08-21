From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [COMPILE TESTED PATCH V5 9/9] xen/blkback: use helper
 in vbd_sz()
Date: Tue, 20 Aug 2019 23:14:23 -0700
Message-ID: <20190821061423.3408-10-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: linux-block@vger.kernel.org
Cc: damien.lemoal@wdc.com, linux-btrace@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, yuchao0@huawei.com, colyli@suse.de, linux-bcache@vger.kernel.org, jaegeuk@kernel.org, xen-devel@lists.xenproject.org, kent.overstreet@gmail.com, roger.pau@citrix.com
List-Id: linux-bcache@vger.kernel.org

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSB2YmRfc3ooKSBtYWNybyB3aXRoIG5ld2x5IGludHJvZHVj
ZWQgaGVscGVyCmZ1bmN0aW9uIHRvIHJlYWQgdGhlIG5yX3NlY3RzIGZyb20gYmxvY2sgZGV2aWNl
J3MgaGRfcGFydHMgd2l0aCB0aGUKaGVscCBvZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KCkFja2Vk
LWJ5OiBSb2dlciBQYXUgTW9ubsOpIDxyb2dlci5wYXVAeHh4eHh4eHh4eD4KU2lnbmVkLW9mZi1i
eTogQ2hhaXRhbnlhIEt1bGthcm5pIDxjaGFpdGFueWEua3Vsa2FybmlAd2RjLmNvbT4KLS0tCiBk
cml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2NvbW1vbi5oIHwgMiArLQogMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9j
ay94ZW4tYmxrYmFjay9jb21tb24uaCBiL2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2svY29tbW9u
LmgKaW5kZXggMWQzMDAyZDc3M2Y3Li5mOTZjYjhkMWNiOTkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
YmxvY2sveGVuLWJsa2JhY2svY29tbW9uLmgKKysrIGIvZHJpdmVycy9ibG9jay94ZW4tYmxrYmFj
ay9jb21tb24uaApAQCAtMzU5LDcgKzM1OSw3IEBAIHN0cnVjdCBwZW5kaW5nX3JlcSB7CiAKIAog
I2RlZmluZSB2YmRfc3ooX3YpCSgoX3YpLT5iZGV2LT5iZF9wYXJ0ID8gXAotCQkJIChfdiktPmJk
ZXYtPmJkX3BhcnQtPm5yX3NlY3RzIDogXAorCQkJICBiZGV2X25yX3NlY3RzKChfdiktPmJkZXYp
IDogXAogCQkJICBnZXRfY2FwYWNpdHkoKF92KS0+YmRldi0+YmRfZGlzaykpCiAKICNkZWZpbmUg
eGVuX2Jsa2lmX2dldChfYikgKGF0b21pY19pbmMoJihfYiktPnJlZmNudCkpCi0tIAoyLjE3LjAK
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2
ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZwpodHRwczovL2xp
c3RzLnhlbnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8veGVuLWRldmVs
