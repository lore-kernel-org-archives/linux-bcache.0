From: Coly Li <i@coly.li>
Subject: Re: Comm: bcache_allocato BUG: unable to handle kernel NULL pointer
 dereference at 00000000000006bc
Date: Sun, 15 Oct 2017 00:22:53 +0800
Message-ID: <f0bd886e-b083-a07a-89c2-a8ade257aeef@coly.li>
References: <CAGmahrSoEjp5Qh4P9OLk-x7W73F3FNbwc7x2wpChHq_Y_SSj=g@mail.gmail.com>
 <c1470bb5-413c-2cc9-0560-b90a3b577c99@coly.li>
 <CAGmahrQ=UhHOpwcRXgWqgyb6aWFt3FGn0vip630JSCq8cMH0CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------093AA01A08D926F0DF60FBA6"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:45290 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753666AbdJNQW5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 14 Oct 2017 12:22:57 -0400
In-Reply-To: <CAGmahrQ=UhHOpwcRXgWqgyb6aWFt3FGn0vip630JSCq8cMH0CA@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sverd Johnsen <sverd.johnsen@googlemail.com>
Cc: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------093AA01A08D926F0DF60FBA6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2017/10/14 下午8:04, Sverd Johnsen wrote:
> Yes. bcache-tools ships some udev rules associated helper utils that
> are used here.
> 

Hi Sverd,

Is it possible for you to test the attached patch ? This is an effort to
avoid NULL dereference issue, let's try whether it works.

Thanks in advance.

Coly Li


> On 14 October 2017 at 13:42, Coly Li <i@coly.li> wrote:
>> On 2017/10/14 下午7:14, Sverd Johnsen wrote:
>>> This is on 4.13.5. Happens sometime at boot, I just reboot and it
>>> works fine. No other problems.
>>>
>>>   40.391116] BUG: unable to handle kernel NULL pointer dereference at
>>> 00000000000006bc
>>>    40.391663] IP: _raw_spin_lock_irqsave+0x12/0x30
>>>    40.392152] PGD 0
>>>    40.392153] P4D 0
>>>    40.392658]
>>>    40.393070] bcache: bch_journal_replay() journal replay done, 21
>>> keys in 10 entries, seq 34810
>>>    40.393427] bcache: register_cache() registered cache device sdc4
>>>    40.394669] Oops: 0002 [#1] PREEMPT SMP
>>>    40.395174] Modules linked in: tun(+) vhost tap kvm md_mod bcache
[snip]
>>
>> Hi Sverd,
>>
>> A fast glance on the code, c->data_bucket_lock from bch_alloc_sectors()
>> is very suspicious. c->data_bucket_lock is initialized in
>> bch_open_buckets_alloc(), which is called after calling kobject_init()
>> when allocate a cache set in bch_cache_set_alloc().
>>
>> Cache/cache device register is via sysfs entry, therefor it is possible
>> that before spin lock c->data_bucket_lock is initialized, a cache/cached
>> device registration request sent into /sys/fs/bcache/register, then
>> trigger a NULL deference on the spin lock.
>>
>> Normally it won't happen if the command is typed by human being. Do you
>> use some script to run the bcache automatically ? Then I can do further
>> check to confirm whether my guess is correct.

--------------093AA01A08D926F0DF60FBA6
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="initiate_kobj_late.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="initiate_kobj_late.patch"

W1BhdGNoXSBiY2FjaGU6IGluaXRpYXRlIGNhY2hlZCBkZXZpY2Uga29iamVjdHMgYXQgbGFz
dAoKQmNhY2hlIGNhY2hlZCBkZXZpY2Ugc3lzZnMgZW50cmllcyBhcmUgaW5pdGlhbGl6ZWQg
ZWFyaWxlciB0aGFuCm90aGVyIHJlbGF0ZWQga2VybmVsIGRhdGEgc3RydWN0dXJlLCB0aGVy
ZSBpcyBwb3NzaWJpbGl0eSB0aGF0CndoZW4gY2FjaGVkIGRldmljZSBzdGFydHMgdG8gcnVu
IGJ5IHdyaXR0aW5nIHRvIGl0cyBzeXNmcyBidXQgdGhlCml0cyBrZXJuZWwgcmVzb3VyY2Vz
IGlzIG5vdCBpbml0aWFsaXplZCB5ZXQsIGUuZy4gYWxsb2NhdG9yIHRocmVhZApvciBkYXRh
IGJ1Y2tldCBzcGluX2xvY2suIFRoaXMga2luZCBvZiByYWNlIHdpbGwgdHJpZ2dlciBrZXJu
ZWwKcGFuaWMgYnkgTlVMTCBkZXJlZmVyZW5jZS4KClRoaXMgcGF0Y2ggbW9kaWZpZXMgdGhl
IGxvY2F0aW9uIHdoZXJlIHJlbGF0ZWQga29iamVjdHMgYXJlIGNyZWF0ZWQsCnRvIG1ha2Ug
c3VyZSBiZWZvcmUgc3lzZnMgZW50cnkgYmVpbmcgYXZhaWJsZSB0byB1c2VyIHNwYWNlLCBh
bGwKbmVjZXNzYXJ5IGtlcm5lbCBzb3VyY2VzIG9mIHRoZSBjYWNoZWQgZGV2aWNlIGFyZSBp
bml0aWFsaXplZC4KClNpZ25lZC1vZmYtYnk6IENvbHkgTGkgPGNvbHlsaUBzdXNlLmRlPgot
LS0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgYi9kcml2ZXJzL21k
L2JjYWNoZS9zdXBlci5jCmluZGV4IGZjMGEzMWIxM2FjNC4uZTFjMDJkODY5ZTBkIDEwMDY0
NAotLS0gYS9kcml2ZXJzL21kL2JjYWNoZS9zdXBlci5jCisrKyBiL2RyaXZlcnMvbWQvYmNh
Y2hlL3N1cGVyLmMKQEAgLTExMDQsMTIgKzExMDQsMTAgQEAgc3RhdGljIGludCBjYWNoZWRf
ZGV2X2luaXQoc3RydWN0IGNhY2hlZF9kZXYgKmRjLCB1bnNpZ25lZCBibG9ja19zaXplKQog
CUlOSVRfTElTVF9IRUFEKCZkYy0+bGlzdCk7CiAJY2xvc3VyZV9pbml0KCZkYy0+ZGlzay5j
bCwgTlVMTCk7CiAJc2V0X2Nsb3N1cmVfZm4oJmRjLT5kaXNrLmNsLCBjYWNoZWRfZGV2X2Zs
dXNoLCBzeXN0ZW1fd3EpOwotCWtvYmplY3RfaW5pdCgmZGMtPmRpc2sua29iaiwgJmJjaF9j
YWNoZWRfZGV2X2t0eXBlKTsKIAlJTklUX1dPUksoJmRjLT5kZXRhY2gsIGNhY2hlZF9kZXZf
ZGV0YWNoX2ZpbmlzaCk7CiAJc2VtYV9pbml0KCZkYy0+c2Jfd3JpdGVfbXV0ZXgsIDEpOwog
CUlOSVRfTElTVF9IRUFEKCZkYy0+aW9fbHJ1KTsKIAlzcGluX2xvY2tfaW5pdCgmZGMtPmlv
X2xvY2spOwotCWJjaF9jYWNoZV9hY2NvdW50aW5nX2luaXQoJmRjLT5hY2NvdW50aW5nLCAm
ZGMtPmRpc2suY2wpOwogCiAJZGMtPnNlcXVlbnRpYWxfY3V0b2ZmCQk9IDQgPDwgMjA7CiAK
QEAgLTExMzgsNiArMTEzNiwxMCBAQCBzdGF0aWMgaW50IGNhY2hlZF9kZXZfaW5pdChzdHJ1
Y3QgY2FjaGVkX2RldiAqZGMsIHVuc2lnbmVkIGJsb2NrX3NpemUpCiAKIAliY2hfY2FjaGVk
X2Rldl9yZXF1ZXN0X2luaXQoZGMpOwogCWJjaF9jYWNoZWRfZGV2X3dyaXRlYmFja19pbml0
KGRjKTsKKwliY2hfY2FjaGVfYWNjb3VudGluZ19pbml0KCZkYy0+YWNjb3VudGluZywgJmRj
LT5kaXNrLmNsKTsKKworCWtvYmplY3RfaW5pdCgmZGMtPmRpc2sua29iaiwgJmJjaF9jYWNo
ZWRfZGV2X2t0eXBlKTsKKwogCXJldHVybiAwOwogfQogCkBAIC0xNDY3LDExICsxNDY5LDYg
QEAgc3RydWN0IGNhY2hlX3NldCAqYmNoX2NhY2hlX3NldF9hbGxvYyhzdHJ1Y3QgY2FjaGVf
c2IgKnNiKQogCWNsb3N1cmVfc2V0X3N0b3BwZWQoJmMtPmNsKTsKIAljbG9zdXJlX3B1dCgm
Yy0+Y2wpOwogCi0Ja29iamVjdF9pbml0KCZjLT5rb2JqLCAmYmNoX2NhY2hlX3NldF9rdHlw
ZSk7Ci0Ja29iamVjdF9pbml0KCZjLT5pbnRlcm5hbCwgJmJjaF9jYWNoZV9zZXRfaW50ZXJu
YWxfa3R5cGUpOwotCi0JYmNoX2NhY2hlX2FjY291bnRpbmdfaW5pdCgmYy0+YWNjb3VudGlu
ZywgJmMtPmNsKTsKLQogCW1lbWNweShjLT5zYi5zZXRfdXVpZCwgc2ItPnNldF91dWlkLCAx
Nik7CiAJYy0+c2IuYmxvY2tfc2l6ZQk9IHNiLT5ibG9ja19zaXplOwogCWMtPnNiLmJ1Y2tl
dF9zaXplCT0gc2ItPmJ1Y2tldF9zaXplOwpAQCAtMTUzNCw2ICsxNTMxLDEwIEBAIHN0cnVj
dCBjYWNoZV9zZXQgKmJjaF9jYWNoZV9zZXRfYWxsb2Moc3RydWN0IGNhY2hlX3NiICpzYikK
IAljLT5jb25nZXN0ZWRfd3JpdGVfdGhyZXNob2xkX3VzCT0gMjAwMDA7CiAJYy0+ZXJyb3Jf
bGltaXQJPSA4IDw8IElPX0VSUk9SX1NISUZUOwogCisJa29iamVjdF9pbml0KCZjLT5rb2Jq
LCAmYmNoX2NhY2hlX3NldF9rdHlwZSk7CisJa29iamVjdF9pbml0KCZjLT5pbnRlcm5hbCwg
JmJjaF9jYWNoZV9zZXRfaW50ZXJuYWxfa3R5cGUpOworCWJjaF9jYWNoZV9hY2NvdW50aW5n
X2luaXQoJmMtPmFjY291bnRpbmcsICZjLT5jbCk7CisKIAlyZXR1cm4gYzsKIGVycjoKIAli
Y2hfY2FjaGVfc2V0X3VucmVnaXN0ZXIoYyk7CkBAIC0xODE1LDcgKzE4MTYsNiBAQCBzdGF0
aWMgaW50IGNhY2hlX2FsbG9jKHN0cnVjdCBjYWNoZSAqY2EpCiAJc3RydWN0IGJ1Y2tldCAq
YjsKIAogCV9fbW9kdWxlX2dldChUSElTX01PRFVMRSk7Ci0Ja29iamVjdF9pbml0KCZjYS0+
a29iaiwgJmJjaF9jYWNoZV9rdHlwZSk7CiAKIAliaW9faW5pdCgmY2EtPmpvdXJuYWwuYmlv
LCBjYS0+am91cm5hbC5iaW8uYmlfaW5saW5lX3ZlY3MsIDgpOwogCkBAIC0xODM5LDYgKzE4
MzksOCBAQCBzdGF0aWMgaW50IGNhY2hlX2FsbG9jKHN0cnVjdCBjYWNoZSAqY2EpCiAJZm9y
X2VhY2hfYnVja2V0KGIsIGNhKQogCQlhdG9taWNfc2V0KCZiLT5waW4sIDApOwogCisJa29i
amVjdF9pbml0KCZjYS0+a29iaiwgJmJjaF9jYWNoZV9rdHlwZSk7CisKIAlyZXR1cm4gMDsK
IH0KIAo=
--------------093AA01A08D926F0DF60FBA6--
