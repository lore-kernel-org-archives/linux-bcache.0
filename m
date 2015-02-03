From: Joshua Schmid <jschmid@suse.de>
Subject: Re: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Tue, 03 Feb 2015 12:26:29 +0100
Message-ID: <54D0B065.4010205@suse.de>
References: <54D0A4CF.4040204@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070709060701060000080700"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbbBCL0b (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 3 Feb 2015 06:26:31 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 77700AB46
	for <linux-bcache@vger.kernel.org>; Tue,  3 Feb 2015 11:26:29 +0000 (UTC)
In-Reply-To: <54D0A4CF.4040204@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------070709060701060000080700
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On 02/03/2015 11:37 AM, Joshua Schmid wrote:
> Hi,
> 
> 
> 
> I tested this patch for some time and it really helps to fix the
> gc issue we are running in. Since it might got lost, i will resend
> it.

patch attached*

> 
> 
> 
> Best Regards, Joshua
> 
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJU0LBlAAoJEPUnwXO0u5uWMVgP/iUGNroCzUSW0lGvV+awLyPX
+p7O5tERuzs7Uq+yKBoE8Zvad76WuS1vnrLqjZgfI+3P4dGJPpf1DlLHlFU7dHkF
/UBgqQFf6OT5MgXk+TXKLXitH+55Chl7WaVe3RMgXEMP3Q5R/rjvLM8Po5gLfRc8
uru7k0oFi+B7cnOmxXruD74baCXY+nwuXoE7PTyOzH+1Wf7SHsz8ygGNVbDhVWI4
A1zaTqoBMNXribBd3wN5uRV7XDHL5un+zF7sR8P9BiXHn1GKPwH7qLesHHTT2nvs
joN7+xMx8In0cR4uloSDqgmwT/6OdeFCujKErwIkVIl57YqEUimByxcA4lGzXvXZ
C5n760Ei/nw0X70qeA2Jkfg/Zk1HfwPcfkHVIi5KB4LelfVa1jbIEaSzdnclH2aD
GlakovGJOkrcPhBgH0xc+7h2eH1kv6Vw8Al1AbTNho92vzVCKmcmGMUyuBpkmxnD
zdxoXUKZLEuGWCt0ExYBU8tIw3twpatCA15sZ9kbgwkggqri7HHqjA8M/cMjPXKC
VNStPPnscMbMjxDvZiJyNrCchi2kInJWLKJWNofk5RZs7f2eQcT1bXKYWxXPGIxn
QZhKsrItZ/k0g2GrxWCRxH6fymHVKkokzt6R0FZcs/1Quf+CnwrhJ5ZPQivkdKLX
BUIG+BeOeYwkLm27/VoH
=XQtd
-----END PGP SIGNATURE-----

--------------070709060701060000080700
Content-Type: text/x-patch;
 name="0001-3.17-rc6-bcache_gc-BUG-soft-lockup-CPU-2-stuck-for-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-3.17-rc6-bcache_gc-BUG-soft-lockup-CPU-2-stuck-for-2.pa";
 filename*1="tch"

From ab8c276a4997f394e252688f855e1b35374aedee Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Sat, 1 Nov 2014 13:44:47 -0700
Subject: [PATCH] 3.17-rc6: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!

On Sun, Sep 28, 2014 at 05:25:37PM -0700, Eric Wheeler wrote:
> Hello Kent, Ross, all:
>
> We're getting bcache_gc backtraces and soft lockups; the system continues to
> be responsive and eventually recovers.  We are running 3.17-rc6. (This
> appears to be a continuation of the thread from 2014-09-15)
>
> Please see the following two backtraces.  The first shows up in
> btree_gc_count_keys(), the other is triggered somehow by rcu_sched.  We will
> test with -rc7 this week, though I didn't see any bcache commits in rc7.
>
> The server is quite busy:
>   dd in userspace from dm-thinp snapshots to another server
>   two DRBD verify's active backed by dm-thinp volumes
>   note that, dd fills up the buffers so this could be operating with few
>   pages free. (Though we have min-mem set to 256MB.)
>
> I see we are hitting functions like bch_ptr_bad() and bch_extent_bad().
> Could that indicate a cache corruption on our volume?

No - those are the normal "check the validity of medata" functions.

> I'm happy to test patches if you have any suggestions or tests that I should
> run it through.

I think it might just be a missing cond_resched()... there's a check during
garbage collection for need_resched() but it appears we might not actually be
calling schedule() then.

Try this patch:

Hi, i tested this patch and it fixes our hangups. I'm afraid it got lost so i am resending it.

commit a64afc92e17e709bdd1618edd04bc608f6a44c55
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Sat Nov 1 13:44:13 2014 -0700

    bcache: Add a cond_resched() call to gc

    Change-Id: Id4f18c533b80ddb40df94ed0bb5e2a236a4bc325

Tested-By: Joshua Schmid <jschmid@suse.com>
---
 drivers/md/bcache/btree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 00cde40..218f21a 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1741,6 +1741,7 @@ static void bch_btree_gc(struct cache_set *c)
 	do {
 		ret = btree_root(gc_root, c, &op, &writes, &stats);
 		closure_sync(&writes);
+		cond_resched();
 
 		if (ret && ret != -EAGAIN)
 			pr_warn("gc failed!");
-- 
2.1.2


--------------070709060701060000080700--
