Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D5F3783AC
	for <linux-bcache@vger.kernel.org>; Mon,  6 Jul 2026 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783350925; cv=none; b=qJI1fT98z4Si9Z/6q/IyMa1u/NPJmJfVq1jSGQa+fro0wv5LdDj0H6VZ/kbC5zFrRaMvAtcfUpvdeHQkf4mW/H7BJCQBvlaGwcU2I2CHxcH8UPzDz7YauwTS7TkcPmbyG/zy/ZQTv4CB7INoRnjtRusWTsi4cI1ritNMELHFDos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783350925; c=relaxed/simple;
	bh=0CePQi35YyBDELw6haP4Dv271LNgB6tiLEZ8eea75gI=;
	h=From:References:To:Cc:Message-Id:In-Reply-To:Subject:Date:
	 Mime-Version:Content-Type; b=iqdkBlvBBCq65+bF9fv2jMTaqi3wLfspQ8otvEtoIdCXqAQS5XNHKzfrjSpkSK5FwdKPz+R7PMTWvTHhCN2Qe++UER4XPArAHR0NkNmNSmuVuRcoOwRyjK3+xzN5R7y1EiXKr8HqsiXuafVw97fvAEXMngDL1L8mglx2vCgYsXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Ts+NqL1S; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Ts+NqL1S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783350917;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=KAGV2m5Nowp1mx84hhZp/geV/7fHP0MMSRsnYNlkrNg=;
 b=Ts+NqL1S02fRws2nQa2uRbKtz3qf0Dc1gqGIJ+xQJR0ppFQt1WG9LiESrT+Q+T9kNCWVmj
 fwtWzlcCt4e2yD5CUSnclJVbTryxXteb30uMFzj1PzQpdWsAZmVeWXk2sHxds2RDqP9hDE
 LB27zaFTw7PD5mz7QGCDX6qbMEHT59ZiE5RVc83PrqbNW9jtDac1C0JpAIg/QjuwkGJYX6
 fW6si9arS30yKXFpT1fSAwP6NWom/wBMWJuXNhwHwJV1d23oSCkMqM1UKmuI8LfOJCHJNm
 0n03mO3b6SCAY86n5UbvRtzGGaInDhxse3CcKlWeXnHjSgXAsqPh2OSMrULjYw==
From: "Coly Li" <colyli@fygo.io>
References: <20260706-feat-bcache-v3-1-8824683656ca@gmail.com>
Received: from smtpclient.apple ([120.245.64.89]) by smtp.larksuite.com with ESMTPS; Mon, 06 Jul 2026 15:15:16 +0000
To: "Qiliang Yuan" <realwujing@gmail.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Qiliang Yuan" <yuanql9@chinatelecom.cn>
Message-Id: <D3C107FC-C1B6-4A65-B5E1-EE562FE84A5C@fygo.io>
In-Reply-To: <20260706-feat-bcache-v3-1-8824683656ca@gmail.com>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] bcache: avoid holding bch_register_lock across cache_set recovery
Date: Mon, 6 Jul 2026 23:15:03 +0800
X-Lms-Return-Path: <lba+26a4bc684+0efd09+vger.kernel.org+colyli@fygo.io>
X-Original-From: Coly Li <colyli@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: Apple Mail (2.3864.600.51.1.1)
Content-Type: text/plain; charset=UTF-8

Hi Qliang,

Thanks for the continuous effort.

> 2026=E5=B9=B47=E6=9C=886=E6=97=A5 22:08=EF=BC=8CQiliang Yuan <realwujing@=
gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Large-scale bcache device registration and concurrent sysfs access can
> hang unrelated tasks for a long time, e.g.:
>=20
> [  243.082130] INFO: task bcache_cache_se:3496 blocked for more than 121 =
seconds.
> [  243.130817] Call trace:
> [  243.134161]  __switch_to+0x7c/0xbc
> [  243.138461]  __schedule+0x338/0x6f0
> [  243.142847]  schedule+0x50/0xe0
> [  243.146884]  schedule_preempt_disabled+0x18/0x24
> [  243.152400]  __mutex_lock.constprop.0+0x1d4/0x5ec
> [  243.158002]  __mutex_lock_slowpath+0x1c/0x30
> [  243.163170]  mutex_lock+0x50/0x60
> [  243.167397]  bch_cache_set_store+0x40/0x80 [bcache]
>=20
> register_cache() holds bch_register_lock for the entire duration of
> register_cache_set(), which calls run_cache_set() to do journal replay,
> btree check and allocator start for a newly registered cache device.
> Every sysfs show/store on any cache_set or cached_dev in the system
> takes the same global bch_register_lock, so an unrelated device's
> sysfs access blocks for as long as the new device's recovery takes.

I feel you should explain the problem you try to solve. Is it that some
sysfs interfaces that you thought should not be blocked but blocked indeed?

If yes, then it is better to list which bcache interfaces you think they sh=
ould
not not be blocked during the bcache device initialization.

>=20
> Converting bch_register_lock to a rw_semaphore does not fix this:
> register_cache() still holds the lock (as a writer) for the whole
> register_cache_set() call, and sysfs store paths still need exclusive
> access, so a store on an unrelated device still blocks for the same
> duration. Downgrading the lock to a reader during recovery was tried,
> but the cache_set's kobjects and its bch_cache_sets list entry are
> already published before recovery starts, so a concurrent unregister
> could hit the cache_set while it is only partially initialized.
>=20

Thanks for giving up such effort.


> Fix this at the root instead of changing the lock type: keep
> bch_register_lock a mutex, and only hold it for the actual bookkeeping
> that needs it, not for the multi-second recovery. Split registering a
> brand new cache_set into two phases. Recovery (journal replay, btree
> check, allocator start) runs on a cache_set that is linked into
> bch_cache_sets and marked CACHE_SET_REGISTERING, but not yet added to
> sysfs, without holding bch_register_lock at all: nothing else can
> reach it through a kobject that does not exist yet, and the
> REGISTERING flag keeps bch_cached_dev_attach() from attaching a
> backing device to it before it is ready. Publishing (adding the
> kobjects, attaching pending backing/flash devices) runs under
> bch_register_lock afterwards, and is no more expensive than what
> register_bdev_worker() already does under the same lock today.
>=20
> Registering the new cache_set into bch_cache_sets and marking it
> CACHE_SET_REGISTERING happens in the same critical section as
> bch_cache_set_alloc(), which already sets c->cache, so the existing
> duplicate-uuid check keeps working unchanged: a second registration
> for the same uuid still sees c->cache set and is rejected, instead of
> racing to recover the same uuid twice. __uuid_write()'s
> lockdep_assert_held() is relaxed to also accept a cache_set that is
> still CACHE_SET_REGISTERING, since it is called from the unlocked
> recovery path on the fresh-cache branch. The per-cache sysfs show/store
> handlers refuse to touch cache_set state while CACHE_SET_REGISTERING
> is set, since that state is still being written by recovery.
>=20
> Attaching an additional cache device to an already-published cache_set
> (the pre-existing "found" case in register_cache_set(), when a cache
> device is re-attached to a cache_set that lost its device earlier) is
> left untouched: that cache_set is already reachable through sysfs, so
> it keeps running recovery and publishing as one operation under
> bch_register_lock, exactly as before.


If your motivation is to get ride of the timeout trace message, it should b=
e much simpler patch.

If the issue to solve is to avoid blocking on some specific sysfs files for=
 some purpose e.g.
for the system monitoring processes to get some information from the bcache=
 subsystem, then
it is better to list the interfaces you are accessing (read or write), in w=
hich conditions the processes
are blocked and what is the expected behavior.

Then it will help me to understand (not guess) the problem you trend to sol=
ve firstly.



>=20
> Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Jing Wu <realwujing@gmail.com>
> ---
> register_cache() holds the global bch_register_lock for the entire
> duration of registering a new cache_set, including journal replay,
> btree check and allocator start. Every sysfs show/store on any other
> cache_set or cached_dev in the system needs the same lock, so a single
> slow cache_set registration blocks unrelated sysfs access for as long
> as recovery takes (see the call trace in the commit message).
>=20
> v1/v2 tried to fix this by converting bch_register_lock from a mutex
> to a rw_semaphore so sysfs reads could proceed concurrently. Coly
> pointed out this does not actually help the reported hang (store paths
> still need exclusive access for the same duration), raised a KABI
> concern about changing the global's type, and found a real regression
> in v1's downgrade_write()/up_read()/down_write() dance around
> bch_btree_check().
>=20
> v3 drops the lock-type change entirely and fixes the actual problem:
> bch_register_lock stays a mutex, and registering a brand new cache_set
> is split so the expensive recovery runs without holding it at all, on
> a cache_set that is provisionally linked into bch_cache_sets (for
> duplicate-uuid detection) but not yet visible in sysfs or attachable.
> Publishing (kobjects, attaching pending devices) still runs under the
> mutex afterwards, at the same cost register_bdev_worker() already pays
> under the same lock today. Full design rationale is in the commit
> message.

The important message for me is what the problem is, and why you feel
it is an issue and what is the expected behavior.

Help me to be on the same page as you are :-)


> ---
> V2 -> V3:
> - Drop the bch_register_lock mutex -> rw_semaphore conversion entirely
>  (addresses Coly's KABI concern by not touching the lock's type at
>  all).
> - Root-cause fix instead: split registering a brand new cache_set into
>  an unlocked recovery phase (journal replay, btree check, allocator
>  start) and a locked publish phase (kobject_add, attach pending
>  devices), so bch_register_lock is only held for the cheap
>  bookkeeping, not the multi-second recovery that caused the reported
>  hang.
> - Add CACHE_SET_REGISTERING flag: the cache_set is linked into
>  bch_cache_sets immediately (so duplicate-uuid detection and
>  bcache_reboot() still see it) but kept out of sysfs and out of
>  bch_cached_dev_attach()'s reach until recovery finishes.
> - Relax __uuid_write()'s lockdep_assert_held() to also accept a
>  CACHE_SET_REGISTERING cache_set, since it is called from the
>  unlocked recovery path.
> - Gate the per-cache sysfs show/store handlers so they refuse to touch
>  cache_set state while CACHE_SET_REGISTERING is set.
> - Leave the "found:" case (attaching an additional cache device to an
>  already-published cache_set) fully serialized under
>  bch_register_lock, unchanged from v1/v2.
>=20
> V1 -> V2:
> - Remove downgrade_write()/up_read()/down_write() lock manipulation in
>  run_cache_set() to eliminate race window during partial initialization
>  that could lead to use-after-free if unregister is triggered between
>  up_read() and down_write(). Keep write lock held throughout instead.
>  (Coly)
> - Simplify all sysfs store wrappers to unconditionally use down_write()
>  instead of per-attribute read/write lock selection, which was fragile
>  and could miss newly added attributes.
> - Fix STORE_LOCKED macro to use down_write()/up_write() for store
>  operations (was incorrectly using down_read()/up_read()).
> - Expand bch_flash_dev store from STORE_LOCKED macro to explicit
>  wrapper with down_write() and bcache_is_reboot check.
> - Fix whitespace indentation in bcache_init() error path.
> - Note on KABI: bch_register_lock is a module-internal global variable
>  with no EXPORT_SYMBOL in the entire bcache driver. Changing its type
>  from struct mutex to struct rw_semaphore does not affect the kernel
>  ABI, as the symbol is never exported to other modules.
>=20
> v2: https://lore.kernel.org/r/20260706-feat-bcache-v2-1-70a4b6e246c0@gmai=
l.com
> v1: https://lore.kernel.org/r/20260318-wujing-bcache-v1-1-f0b9aaf3f81d@gm=
ail.com
> ---
> drivers/md/bcache/bcache.h |   9 +++
> drivers/md/bcache/super.c  | 145 +++++++++++++++++++++++++++++++++++++++-=
-----
> drivers/md/bcache/sysfs.c  |  16 +++++
> 3 files changed, 153 insertions(+), 17 deletions(-)

At the first glance, I feel this patch doesn=E2=80=99t have enough testing.=
 e.g. the race between bcache_reboot() and bcd_cache_set_recover().
So focus on explaining the problem firstly, help me to be on same page as y=
ou are.

Thanks.

Coly Li
