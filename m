From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 1/9] block: add a helper function to read
 nr_setcs
Date: Tue, 20 Aug 2019 23:14:15 -0700
Message-ID: <20190821061423.3408-2-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGhlbHBlciBmdW5jdGlvbiB0byByZWFkIHRoZSBudW1iZXIg
b2Ygc2VjdG9ycwpmcm9tIHN0cnVjdCBibG9ja19kZXZpY2UtPmJkX3BhcnQgbWVtYmVyLiBGb3Ig
bW9yZSBkZXRhaWxzIFBsZWFzZSByZWZlcgp0byB0aGUgY29tbWVudCBpbiB0aGUgaW5jbHVkZS9s
aW51eC9nZW5oZC5oIGZvciBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KClJldmlld2VkLWJ5OiBNaW53
b28gSW0gPG1pbndvby5pbS5kZXZAZ21haWwuY29tPgpSZXZpZXdlZC1ieTogTWFydGluIEsuIFBl
dGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5AeHh4eHh4eHh4eD4KU2lnbmVkLW9mZi1ieTogQ2hhaXRh
bnlhIEt1bGthcm5pIDxjaGFpdGFueWEua3Vsa2FybmlAd2RjLmNvbT4KLS0tCiBpbmNsdWRlL2xp
bnV4L2Jsa2Rldi5oIHwgNSArKysrKwogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQoK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYmxrZGV2LmggYi9pbmNsdWRlL2xpbnV4L2Jsa2Rl
di5oCmluZGV4IDQ3OThiYjI1ZjFlZS4uYWE1ODAxYzhmZjczIDEwMDY0NAotLS0gYS9pbmNsdWRl
L2xpbnV4L2Jsa2Rldi5oCisrKyBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKQEAgLTE0NjgsNiAr
MTQ2OCwxMSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgcHV0X2Rldl9zZWN0b3IoU2VjdG9yIHApCiAJ
cHV0X3BhZ2UocC52KTsKIH0KIAorc3RhdGljIGlubGluZSBzZWN0b3JfdCBiZGV2X25yX3NlY3Rz
KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYpCit7CisJcmV0dXJuIHBhcnRfbnJfc2VjdHNfcmVh
ZChiZGV2LT5iZF9wYXJ0KTsKK30KKwogaW50IGtibG9ja2Rfc2NoZWR1bGVfd29yayhzdHJ1Y3Qg
d29ya19zdHJ1Y3QgKndvcmspOwogaW50IGtibG9ja2Rfc2NoZWR1bGVfd29ya19vbihpbnQgY3B1
LCBzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwogaW50IGtibG9ja2RfbW9kX2RlbGF5ZWRfd29y
a19vbihpbnQgY3B1LCBzdHJ1Y3QgZGVsYXllZF93b3JrICpkd29yaywgdW5zaWduZWQgbG9uZyBk
ZWxheSk7Ci0tIAoyLjE3LjAKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW5wcm9q
ZWN0Lm9yZwpodHRwczovL2xpc3RzLnhlbnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8veGVu
LWRldmVs
