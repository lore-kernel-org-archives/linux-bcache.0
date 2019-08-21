From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V5 0/9] block: use right accessor to read
 nr_sects
Date: Wed, 21 Aug 2019 08:20:24 -0700
Message-ID: <1aaf1d56-c1a2-957c-28b6-048f9965f412@acm.org>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
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

T24gOC8yMC8xOSAxMToxNCBQTSwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOgo+IEluIHRoZSBi
bGstem9uZWQsIGJjYWNoZSwgZjJmcywgdGFyZ2V0LXBzY3NpLCB4ZW4gYW5kIGJsa3RyYWNlCj4g
aW1wbGVtZW50YXRpb24gYmxvY2sgZGV2aWNlLT5oZF9wYXJ0LT5udW1iZXIgb2Ygc2VjdG9ycyBm
aWVsZCBpcwo+IGFjY2Vzc2VkIGRpcmVjdGx5IHdpdGhvdXQgYW55IGFwcHJvcHJpYXRlIGxvY2tp
bmcgb3IgYWNjZXNzb3IgZnVuY3Rpb24uCj4gVGhlcmUgaXMgYW4gZXhpc3RpbmcgYWNjZXNzb3Ig
ZnVuY3Rpb24gcHJlc2VudCBpbiB0aGUgaW4KPiBpbmNsdWRlL2xpbnV4L2dlbmhkLmggd2hpY2gg
c2hvdWxkIGJlIHVzZWQgdG8gcmVhZCB0aGUKPiBiZGV2LT5oZF9wYXJ0LT5ucl9zZWN0cy4KCkZv
ciB0aGUgZW50aXJlIHNlcmllczoKClJldmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5h
c3NjaGVAYWNtLm9yZz4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qu
b3JnCmh0dHBzOi8vbGlzdHMueGVucHJvamVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby94ZW4tZGV2
ZWw=
