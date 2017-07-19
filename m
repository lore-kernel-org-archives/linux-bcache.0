From: Bob Peterson <rpeterso@redhat.com>
Subject: Re: [PATCH] [RFC] gfs2: add flag REQ_PRIO for metadata read ahead
Date: Wed, 19 Jul 2017 12:05:33 -0400 (EDT)
Message-ID: <1261389690.32250995.1500480333920.JavaMail.zimbra@redhat.com>
References: <20170711030902.13391-1-colyli@suse.de> <alpine.LRH.2.11.1707112009490.10812@mail.ewheeler.net> <6a987624-8bda-874b-0d9b-f604f63e7186@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932690AbdGSQFg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Jul 2017 12:05:36 -0400
In-Reply-To: <6a987624-8bda-874b-0d9b-f604f63e7186@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <colyli@suse.de>, cluster-devel@redhat.com, swhiteho@redhat.com, linux-bcache@vger.kernel.org

----- Original Message -----
| >> This patch adds REQ_PRIO flag when submitting a metadata readahead bio.
| >> A meta data read ahead bio may come from I/O requests for bitmap,
| >> directoriesmeta or other general metadata request.
| >>
| > 
| > Are there any places in gfs2 where REQ_PRIO should be placed on
| > latency-sensitive metadata writes?  They would then writeback in bcache
| > after the relevant bcache patch is merged.
| 
| Hi Eric,
| 
| I just grep REQ_META in fs/gfs2, there are 10 locations use REQ_META.
| Among the 10 locations, REQ_PRIO shows up at 3 locations, another 3
| locations are REQ_READAHEAD and I add REQ_PRIO to them, the rested
| locations are,
| 
| 1) log.c:662
|    In log_write_header(), used to flush gfs2 log header. The author does
| not add REQ_PRIO on purpose, because I see REQ_FUA is there. And for no
| barrier condition, REQ_PRIO is added with REQ_FUA removed. So it's well
| done here.
| 
| 2) meta_io.c:455
|    Here gfs2_meta_ra() tries to read first metadata block, cache the
| metadata block in bcache should be helpful.
| 
| 3) ops_fstype.c:250
|    This is for gfs2_read_sb(), it is only called once by init_sb(), we
| don't need to cache this block by bcache.
| 
| 4) quota.c:733
|    This is in gfs2_write_buf_to_page() when gfs2 disk quota is updated,
| we can have it in cache device.
| 
| So it seems REQ_PRIO might be added at meta_io.c:455, and quota.c:733 to
| provide more hint to bcache.
| 
| Thanks for suggestion.
| 
| Coly

Hi Coly,

So does this mean you are revising the patch and I should wait for a new one?
Or is this patch good as it is? BTW, you may want to change
the comment from "directoriesmeta" to "directory meta".

Regards,

Bob Peterson
Red Hat File Systems
