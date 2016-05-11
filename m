From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 3/3] bcache: Remove redundant block_size assignment
Date: Wed, 11 May 2016 12:16:28 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605111216020.22680@mx.ewheeler.net>
References: <1462869529-11293-1-git-send-email-wangyijing@huawei.com> <1462869529-11293-3-git-send-email-wangyijing@huawei.com> <alpine.LRH.2.11.1605101839350.22680@mx.ewheeler.net> <57328F7A.9000508@huawei.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1595348259-490524224-1462994188=:22680"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:33928 "EHLO mx.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbcEKTQU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 May 2016 15:16:20 -0400
In-Reply-To: <57328F7A.9000508@huawei.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: wangyijing <wangyijing@huawei.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1595348259-490524224-1462994188=:22680
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 11 May 2016, wangyijing wrote:

> 
> 
> 在 2016/5/11 9:41, Eric Wheeler 写道:
> > On Tue, 10 May 2016, Yijing Wang wrote:
> > 
> >> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> >> ---
> >>  drivers/md/bcache/super.c |    1 -
> >>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >> index 1ccb9be..64d0be6 100644
> >> --- a/drivers/md/bcache/super.c
> >> +++ b/drivers/md/bcache/super.c
> >> @@ -134,7 +134,6 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
> >>  	case BCACHE_SB_VERSION_CDEV:
> >>  	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
> >>  		sb->nbuckets	= le64_to_cpu(s->nbuckets);
> >> -		sb->block_size	= le16_to_cpu(s->block_size);
> >>  		sb->bucket_size	= le16_to_cpu(s->bucket_size);
> > 
> > 
> > Are you sure we want to do that?  
> > 
> > The bcache superblock allows us to assign the block size presented by 
> > bcache and we wouldn't want 4k users to suddenly revert to 512b.  
> 
> Hi, I have nothing functional to change here, we have assigned block_size already before here.
> 
> 	sb->block_size	= le16_to_cpu(s->block_size);    //first assignment

I agree. Ack'ed.   


--
Eric Wheeler


> 
> 	err = "Superblock block size smaller than device block size";
> 	if (sb->block_size << 9 < bdev_logical_block_size(bdev))
> 		goto err;
> 
> 	switch (sb->version) {
> 	case BCACHE_SB_VERSION_BDEV:
> 		sb->data_offset	= BDEV_DATA_START_DEFAULT;
> 		break;
> 	case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
> 		sb->data_offset	= le64_to_cpu(s->data_offset);
> 
> 		err = "Bad data offset";
> 		if (sb->data_offset < BDEV_DATA_START_DEFAULT)
> 			goto err;
> 
> 		break;
> 	case BCACHE_SB_VERSION_CDEV:
> 	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
> 		sb->nbuckets	= le64_to_cpu(s->nbuckets);
> 		sb->block_size	= le16_to_cpu(s->block_size);       //redundant one
> 
> Thanks!
> Yijing.
> 
> 
> > 
> > 
> > --
> > Eric Wheeler
> > 
> > 
> > 
> >>  
> >>  		sb->nr_in_set	= le16_to_cpu(s->nr_in_set);
> >> -- 
> >> 1.7.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > 
> > .
> > 
> 
> 
--1595348259-490524224-1462994188=:22680--
