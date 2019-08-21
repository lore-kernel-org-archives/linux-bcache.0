From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 2/9] blk-zoned: update blkdev_nr_zones() with
 helper
Date: Tue, 20 Aug 2019 23:14:16 -0700
Message-ID: <20190821061423.3408-3-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBibGtkZXZfbnJfem9uZXMoKSB3aXRoIG5ld2x5IGludHJv
ZHVjZWQgaGVscGVyCmZ1bmN0aW9uIHRvIHJlYWQgdGhlIG5yX3NlY3RzIGZyb20gYmxvY2sgZGV2
aWNlJ3MgaGRfcGFydHMgd2l0aCB0aGUKaGVscCBpZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KClJl
dmlld2VkLWJ5OiBNaW53b28gSW0gPG1pbndvby5pbS5kZXZAZ21haWwuY29tPgpTaWduZWQtb2Zm
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGNoYWl0YW55YS5rdWxrYXJuaUB3ZGMuY29tPgotLS0K
IGJsb2NrL2Jsay16b25lZC5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLXpvbmVkLmMgYi9ibG9jay9i
bGstem9uZWQuYwppbmRleCA0YmM1ZjI2MDI0OGEuLjNmNWU5YmYwMzQ4NiAxMDA2NDQKLS0tIGEv
YmxvY2svYmxrLXpvbmVkLmMKKysrIGIvYmxvY2svYmxrLXpvbmVkLmMKQEAgLTkzLDcgKzkzLDcg
QEAgdW5zaWduZWQgaW50IGJsa2Rldl9ucl96b25lcyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2
KQogCWlmICghYmxrX3F1ZXVlX2lzX3pvbmVkKHEpKQogCQlyZXR1cm4gMDsKIAotCXJldHVybiBf
X2Jsa2Rldl9ucl96b25lcyhxLCBiZGV2LT5iZF9wYXJ0LT5ucl9zZWN0cyk7CisJcmV0dXJuIF9f
YmxrZGV2X25yX3pvbmVzKHEsIGJkZXZfbnJfc2VjdHMoYmRldikpOwogfQogRVhQT1JUX1NZTUJP
TF9HUEwoYmxrZGV2X25yX3pvbmVzKTsKIAotLSAKMi4xNy4wCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4t
ZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9t
YWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
