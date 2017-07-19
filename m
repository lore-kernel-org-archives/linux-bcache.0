From: Coly Li <i@coly.li>
Subject: Re: [PATCH] [RFC] gfs2: add flag REQ_PRIO for metadata read ahead
Date: Thu, 20 Jul 2017 03:03:59 +0800
Message-ID: <4faeb702-aeb0-fbe6-ef3f-989971275033@coly.li>
References: <20170711030902.13391-1-colyli@suse.de>
 <alpine.LRH.2.11.1707112009490.10812@mail.ewheeler.net>
 <6a987624-8bda-874b-0d9b-f604f63e7186@coly.li>
 <1261389690.32250995.1500480333920.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:59532 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754204AbdGSTEQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Jul 2017 15:04:16 -0400
In-Reply-To: <1261389690.32250995.1500480333920.JavaMail.zimbra@redhat.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Bob Peterson <rpeterso@redhat.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <colyli@suse.de>, cluster-devel@redhat.com, swhiteho@redhat.com, linux-bcache@vger.kernel.org

On 2017/7/20 上午12:05, Bob Peterson wrote:
> ----- Original Message -----
> | >> This patch adds REQ_PRIO flag when submitting a metadata readahead bio.
> | >> A meta data read ahead bio may come from I/O requests for bitmap,
> | >> directoriesmeta or other general metadata request.
> | >>
> | > 
> | > Are there any places in gfs2 where REQ_PRIO should be placed on
> | > latency-sensitive metadata writes?  They would then writeback in bcache
> | > after the relevant bcache patch is merged.
> | 
> | Hi Eric,
> | 
> | I just grep REQ_META in fs/gfs2, there are 10 locations use REQ_META.
> | Among the 10 locations, REQ_PRIO shows up at 3 locations, another 3
> | locations are REQ_READAHEAD and I add REQ_PRIO to them, the rested
> | locations are,
> | 
> | 1) log.c:662
> |    In log_write_header(), used to flush gfs2 log header. The author does
> | not add REQ_PRIO on purpose, because I see REQ_FUA is there. And for no
> | barrier condition, REQ_PRIO is added with REQ_FUA removed. So it's well
> | done here.
> | 
> | 2) meta_io.c:455
> |    Here gfs2_meta_ra() tries to read first metadata block, cache the
> | metadata block in bcache should be helpful.
> | 
> | 3) ops_fstype.c:250
> |    This is for gfs2_read_sb(), it is only called once by init_sb(), we
> | don't need to cache this block by bcache.
> | 
> | 4) quota.c:733
> |    This is in gfs2_write_buf_to_page() when gfs2 disk quota is updated,
> | we can have it in cache device.
> | 
> | So it seems REQ_PRIO might be added at meta_io.c:455, and quota.c:733 to
> | provide more hint to bcache.
> | 
> | Thanks for suggestion.
> | 
> | Coly
> 
> Hi Coly,
> 
> So does this mean you are revising the patch and I should wait for a new one?
> Or is this patch good as it is? BTW, you may want to change
> the comment from "directoriesmeta" to "directory meta".
> 
> Regards,
> 

Hi Bob,

It's great o hear from you :-)
Yes I will post a V2 (not RFC) patch for review, with comment typo fix.

Thanks for your replying !

-- 
Coly Li
