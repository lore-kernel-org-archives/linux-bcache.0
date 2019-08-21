From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V5 1/9] block: add a helper function to read
 nr_setcs
Date: Wed, 21 Aug 2019 08:18:29 -0700
Message-ID: <3e0917fc-290e-d1e6-3ba9-936accda0a2b@acm.org>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
 <20190821061423.3408-2-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20190821061423.3408-2-chaitanya.kulkarni@wdc.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, linux-block@vger.kernel.org
Cc: damien.lemoal@wdc.com, linux-btrace@vger.kernel.org, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, yuchao0@huawei.com, colyli@suse.de, linux-bcache@vger.kernel.org, jaegeuk@kernel.org, xen-devel@lists.xenproject.org, kent.overstreet@gmail.com, roger.pau@citrix.com
List-Id: linux-bcache@vger.kernel.org

T24gOC8yMC8xOSAxMToxNCBQTSwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOgo+IFRoaXMgcGF0
Y2ggaW50cm9kdWNlcyBoZWxwZXIgZnVuY3Rpb24gdG8gcmVhZCB0aGUgbnVtYmVyIG9mIHNlY3Rv
cnMKPiBmcm9tIHN0cnVjdCBibG9ja19kZXZpY2UtPmJkX3BhcnQgbWVtYmVyLiBGb3IgbW9yZSBk
ZXRhaWxzIFBsZWFzZSByZWZlcgo+IHRvIHRoZSBjb21tZW50IGluIHRoZSBpbmNsdWRlL2xpbnV4
L2dlbmhkLmggZm9yIHBhcnRfbnJfc2VjdHNfcmVhZCgpLgo+IAo+IFJldmlld2VkLWJ5OiBNaW53
b28gSW0gPG1pbndvby5pbS5kZXZAZ21haWwuY29tPgo+IFJldmlld2VkLWJ5OiBNYXJ0aW4gSy4g
UGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkB4eHh4eHh4eHh4PgogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXl5eXl5eXl5eXgpUaGlzIGxvb2tzIHdl
aXJkLgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhl
bi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnCmh0dHBz
Oi8vbGlzdHMueGVucHJvamVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby94ZW4tZGV2ZWw=
