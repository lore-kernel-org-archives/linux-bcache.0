From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: bcache performance: is all IO serialized by check_should_bypass()?
Date: Sun, 29 Nov 2015 16:08:33 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1511291539440.29800@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [71.19.153.34] ([71.19.153.34]:58648 "EHLO mail.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751430AbbK3AOm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 29 Nov 2015 19:14:42 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.ewheeler.net (Postfix) with ESMTP id 1381FA0F4D
	for <linux-bcache@vger.kernel.org>; Sun, 29 Nov 2015 16:08:47 -0800 (PST)
Received: from mail.ewheeler.net ([127.0.0.1])
	by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 7OX2r7VUM1hO for <linux-bcache@vger.kernel.org>;
	Sun, 29 Nov 2015 16:08:42 -0800 (PST)
Received: from 23-95-35-21-host.colocrossing.com (unknown [23.95.35.21])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ewheeler.net (Postfix) with ESMTPSA id C4807A0F4C
	for <linux-bcache@vger.kernel.org>; Sun, 29 Nov 2015 16:08:42 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello all,

Looking at cached_dev_make_request() (the queue->make_request_fn 
callback), it sounds like every bio is passed through 
check_should_bypass(), which appears to spinlock dc->io_lock for every 
bio during sequential task analysis.

If so, then this prevents multiprocessor IO parallelism by requiring that 
the lock be held for every IO and could cause cache line bouncing of the 
lock between sockets.

I'm soliciting feedback about converting hlist_for_each_entry to 
hlist_for_each_entry_rcu and related functions:

http://lwn.net/Articles/264090/
https://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/x490.html

Has anyone already tried this?  

Is the serialization caused by check_should_bypass() necessary in some 
less than obvious way such that it might cause other synchronization 
issues?

Are there any data integrity concerns here that I am missing?

Any other thoughts or ideas on the subject would be greatly appreciated!

-Eric

--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
