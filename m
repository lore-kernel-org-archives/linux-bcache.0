From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 4/9] blk-zoned: update blkdev_reset_zones()
 with helper
Date: Tue, 20 Aug 2019 23:14:18 -0700
Message-ID: <20190821061423.3408-5-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBibGtkZXZfcmVzZXRfem9uZXMoKSB3aXRoIG5ld2x5IGlu
dHJvZHVjZWQKaGVscGVyIGZ1bmN0aW9uIHRvIHJlYWQgdGhlIG5yX3NlY3RzIGZyb20gYmxvY2sg
ZGV2aWNlJ3MgaGRfcGFydHMgd2l0aAp0aGUgaGVscCBvZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4K
ClJldmlld2VkLWJ5OiBNaW53b28gSW0gPG1pbndvby5pbS5kZXZAZ21haWwuY29tPgpTaWduZWQt
b2ZmLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGNoYWl0YW55YS5rdWxrYXJuaUB3ZGMuY29tPgot
LS0KIGJsb2NrL2Jsay16b25lZC5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay16b25lZC5jIGIv
YmxvY2svYmxrLXpvbmVkLmMKaW5kZXggN2UwYzBiNTRkMTk0Li41M2Y5ZGYzNzZjZmIgMTAwNjQ0
Ci0tLSBhL2Jsb2NrL2Jsay16b25lZC5jCisrKyBiL2Jsb2NrL2Jsay16b25lZC5jCkBAIC0yNjcs
NyArMjY3LDcgQEAgaW50IGJsa2Rldl9yZXNldF96b25lcyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpi
ZGV2LAogCWlmIChiZGV2X3JlYWRfb25seShiZGV2KSkKIAkJcmV0dXJuIC1FUEVSTTsKIAotCWlm
ICghbnJfc2VjdG9ycyB8fCBlbmRfc2VjdG9yID4gYmRldi0+YmRfcGFydC0+bnJfc2VjdHMpCisJ
aWYgKCFucl9zZWN0b3JzIHx8IGVuZF9zZWN0b3IgPiBiZGV2X25yX3NlY3RzKGJkZXYpKQogCQkv
KiBPdXQgb2YgcmFuZ2UgKi8KIAkJcmV0dXJuIC1FSU5WQUw7CiAKQEAgLTI4MCw3ICsyODAsNyBA
QCBpbnQgYmxrZGV2X3Jlc2V0X3pvbmVzKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCiAJCXJl
dHVybiAtRUlOVkFMOwogCiAJaWYgKChucl9zZWN0b3JzICYgKHpvbmVfc2VjdG9ycyAtIDEpKSAm
JgotCSAgICBlbmRfc2VjdG9yICE9IGJkZXYtPmJkX3BhcnQtPm5yX3NlY3RzKQorCSAgICBlbmRf
c2VjdG9yICE9IGJkZXZfbnJfc2VjdHMoYmRldikpCiAJCXJldHVybiAtRUlOVkFMOwogCiAJYmxr
X3N0YXJ0X3BsdWcoJnBsdWcpOwotLSAKMi4xNy4wCgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxA
bGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFu
L2xpc3RpbmZvL3hlbi1kZXZlbA==
