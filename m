From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL] bcache: fix cache_set_flush() NULL pointer dereference on
 OOM
Date: Mon, 7 Mar 2016 23:36:21 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603072326410.11530@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:43547 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932518AbcCGXgY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 7 Mar 2016 18:36:24 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, kent.overstreet@gmail.com

Hi Jens,

Here is another OOM fix for bcache.  Please pull:

  git pull https://bitbucket.org/ewheelerinc/linux.git v4.5-rc7-bcache-fixes 

 # git diff --stat v4.5-rc7
 drivers/md/bcache/super.c | 3 +++
 1 file changed, 3 insertions(+)

-Eric

commit 87264e96886f785922d741750a8a1794e71af1e7
Author: Eric Wheeler <git@linux.ewheeler.net>
Date:   Mon Mar 7 15:17:50 2016 -0800

    bcache: fix cache_set_flush() NULL pointer dereference on OOM
    
    When bch_cache_set_alloc() fails to kzalloc the cache_set, the
    asyncronous closure handling tries to dereference a cache_set that
    hadn't yet been allocated inside of cache_set_flush() which is called
    by __cache_set_unregister() during cleanup.  This appears to happen only
    during an OOM condition on bcache_register.
    
    Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
    Cc: stable@vger.kernel.org
