From: Coly Li <i@coly.li>
Subject: Re: [PATCH] [RFC] gfs2: add flag REQ_PRIO for metadata read ahead
Date: Wed, 12 Jul 2017 11:59:10 +0800
Message-ID: <6a987624-8bda-874b-0d9b-f604f63e7186@coly.li>
References: <20170711030902.13391-1-colyli@suse.de>
 <alpine.LRH.2.11.1707112009490.10812@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:55698 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754620AbdGLD7R (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 Jul 2017 23:59:17 -0400
In-Reply-To: <alpine.LRH.2.11.1707112009490.10812@mail.ewheeler.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <colyli@suse.de>
Cc: cluster-devel@redhat.com, swhiteho@redhat.com, rpeterso@redhat.com, linux-bcache@vger.kernel.org

On 2017/7/12 上午4:10, Eric Wheeler wrote:
> On Tue, 11 Jul 2017, Coly Li wrote:
> 
>> When gfs2 does metadata read ahead, currently flags (REQ_RAHEAD | REQ_META)
>> are used to submit bio. Flag REQ_META is just a hint for block trace, not
>> for block layer code to handle a bio as metadata request.
>>
>> When doing read ahead for metadata, A REQ_PRIO flag on the metadata bio
>> is very informative to block layer code. For example, if bcache is used as
>> a I/O cache for gfs2, it will be possible for bcache code to cache the
>> pre-fetched metadata blocks on cache device as well, which may be
>> probably to improve metadata I/O performance if the following requests
>> hit the cache.
>>
>> This patch adds REQ_PRIO flag when submitting a metadata readahead bio.
>> A meta data read ahead bio may come from I/O requests for bitmap,
>> directoriesmeta or other general metadata request.
>>
> 
> Are there any places in gfs2 where REQ_PRIO should be placed on 
> latency-sensitive metadata writes?  They would then writeback in bcache 
> after the relevant bcache patch is merged.

Hi Eric,

I just grep REQ_META in fs/gfs2, there are 10 locations use REQ_META.
Among the 10 locations, REQ_PRIO shows up at 3 locations, another 3
locations are REQ_READAHEAD and I add REQ_PRIO to them, the rested
locations are,

1) log.c:662
   In log_write_header(), used to flush gfs2 log header. The author does
not add REQ_PRIO on purpose, because I see REQ_FUA is there. And for no
barrier condition, REQ_PRIO is added with REQ_FUA removed. So it's well
done here.

2) meta_io.c:455
   Here gfs2_meta_ra() tries to read first metadata block, cache the
metadata block in bcache should be helpful.

3) ops_fstype.c:250
   This is for gfs2_read_sb(), it is only called once by init_sb(), we
don't need to cache this block by bcache.

4) quota.c:733
   This is in gfs2_write_buf_to_page() when gfs2 disk quota is updated,
we can have it in cache device.

So it seems REQ_PRIO might be added at meta_io.c:455, and quota.c:733 to
provide more hint to bcache.

Thanks for suggestion.

Coly


>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  fs/gfs2/bmap.c    | 5 +++--
>>  fs/gfs2/dir.c     | 4 +++-
>>  fs/gfs2/meta_io.c | 4 +++-
>>  3 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
>> index 9fa3aef9a5b3..fa3ea29f39cf 100644
>> --- a/fs/gfs2/bmap.c
>> +++ b/fs/gfs2/bmap.c
>> @@ -291,8 +291,9 @@ static void gfs2_metapath_ra(struct gfs2_glock *gl,
>>  		if (trylock_buffer(rabh)) {
>>  			if (!buffer_uptodate(rabh)) {
>>  				rabh->b_end_io = end_buffer_read_sync;
>> -				submit_bh(REQ_OP_READ, REQ_RAHEAD | REQ_META,
>> -						rabh);
>> +				submit_bh(REQ_OP_READ,
>> +					  REQ_RAHEAD | REQ_META | REQ_PRIO,
>> +					  rabh);
>>  				continue;
>>  			}
>>  			unlock_buffer(rabh);
>> diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
>> index db427658ccd9..0741e4018f8c 100644
>> --- a/fs/gfs2/dir.c
>> +++ b/fs/gfs2/dir.c
>> @@ -1514,7 +1514,9 @@ static void gfs2_dir_readahead(struct inode *inode, unsigned hsize, u32 index,
>>  				continue;
>>  			}
>>  			bh->b_end_io = end_buffer_read_sync;
>> -			submit_bh(REQ_OP_READ, REQ_RAHEAD | REQ_META, bh);
>> +			submit_bh(REQ_OP_READ,
>> +				  REQ_RAHEAD | REQ_META | REQ_PRIO,
>> +				  bh);
>>  			continue;
>>  		}
>>  		brelse(bh);
>> diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
>> index fabe1614f879..6103d1c816ef 100644
>> --- a/fs/gfs2/meta_io.c
>> +++ b/fs/gfs2/meta_io.c
>> @@ -461,7 +461,9 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
>>  		bh = gfs2_getbuf(gl, dblock, CREATE);
>>  
>>  		if (!buffer_uptodate(bh) && !buffer_locked(bh))
>> -			ll_rw_block(REQ_OP_READ, REQ_RAHEAD | REQ_META, 1, &bh);
>> +			ll_rw_block(REQ_OP_READ,
>> +				    REQ_RAHEAD | REQ_META | REQ_PRIO,
>> +				    1, &bh);
>>  		brelse(bh);
>>  		dblock++;
>>  		extlen--;
>> -- 
>> 2.12.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Coly Li
