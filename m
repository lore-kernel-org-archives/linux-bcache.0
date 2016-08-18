From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Thank you for bcache, Kent!
Date: Thu, 18 Aug 2016 11:32:06 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608181117570.26733@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:54088 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752898AbcHRTKS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 18 Aug 2016 15:10:18 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.ewheeler.net (Postfix) with ESMTP id 2DD4AA0C51
	for <linux-bcache@vger.kernel.org>; Thu, 18 Aug 2016 11:32:13 -0700 (PDT)
Received: from mail.ewheeler.net ([127.0.0.1])
	by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id wbN2vui-x8Cy for <linux-bcache@vger.kernel.org>;
	Thu, 18 Aug 2016 11:32:12 -0700 (PDT)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ewheeler.net (Postfix) with ESMTPSA id 5F0BDA0C50
	for <linux-bcache@vger.kernel.org>; Thu, 18 Aug 2016 11:32:12 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello all,

I wanted to give a big public thank you and plug for Kent Overstreet. As 
you may know, he is the author of bcache and bcachefs. We just had an 
issue with a deadlock at volume registration time and he was able not only 
to solve the problem, but provide a patch so that everyone may benefit.

Bcachefs, the next generation bcache implementation, is completely 
community funded. If you are able to make a contribution to his 
development project, then please do!

At the moment, his project is still below the first goal and it would be 
great to see this become sustainable. After all, the reason that you are 
on this mailing list is because of bcache:
	https://www.patreon.com/bcachefs

As you can see from his development branch, he has been busy adding 
features:
	https://evilpiepirate.org/git/linux-bcache.git/log/?h=bcache-dev

--
Eric Wheeler

p.s.,

This is the patch in case anyone wants to use it right way. I will be 
putting up a git pull request soon:

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4dd2bb7167..db0669a4f2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1836,7 +1836,7 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
 
 	if (!init_fifo(&ca->free[RESERVE_BTREE], 8, GFP_KERNEL) ||
-	    !init_fifo(&ca->free[RESERVE_PRIO], prio_buckets(ca), GFP_KERNEL) ||
+	    !init_fifo_exact(&ca->free[RESERVE_PRIO], prio_buckets(ca), GFP_KERNEL) ||
 	    !init_fifo(&ca->free[RESERVE_MOVINGGC], free, GFP_KERNEL) ||
 	    !init_fifo(&ca->free[RESERVE_NONE], free, GFP_KERNEL) ||
 	    !init_fifo(&ca->free_inc,	free << 2, GFP_KERNEL) ||
