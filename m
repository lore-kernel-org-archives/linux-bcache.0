From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 1/2] bcache: Remove redundant set_capacity
Date: Wed, 30 Nov 2016 10:34:29 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1611301030001.442@mail.ewheeler.net>
References: <1480037969-45042-1-git-send-email-wangyijing@huawei.com> <alpine.LRH.2.11.1611291246140.1914@mail.ewheeler.net> <583E32AE.5060106@huawei.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-2125174138-1480530874=:442"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:51196 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754672AbcK3Sgu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 30 Nov 2016 13:36:50 -0500
In-Reply-To: <583E32AE.5060106@huawei.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: wangyijing <wangyijing@huawei.com>
Cc: axboe@fb.com, kent.overstreet@gmail.com, git@linux.ewheeler.net, colyli@suse.de, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-2125174138-1480530874=:442
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 30 Nov 2016, wangyijing wrote:

> 
> 
> 在 2016/11/30 4:49, Eric Wheeler 写道:
> > On Fri, 25 Nov 2016, Yijing Wang wrote:
> > 
> >> set_capacity() has been called in bcache_device_init(),
> >> remove the redundant one.
> >>
> >> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> >> ---
> >>  drivers/md/bcache/super.c | 3 ---
> >>  1 file changed, 3 deletions(-)
> >>
> >> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >> index 849ad44..b638a16 100644
> >> --- a/drivers/md/bcache/super.c
> >> +++ b/drivers/md/bcache/super.c
> >> @@ -1126,9 +1126,6 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
> >>  	if (ret)
> >>  		return ret;
> >>  
> >> -	set_capacity(dc->disk.disk,
> >> -		     dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
> >> -
> > 
> > It probably is a duplicate set_capacity, but has anyone tested bringing on 
> > a writeback volume, and late-attaching the cache volume with this patch 
> > applied?
> > 
> > Otherwise stated, is it possible to get the backing device attached 
> > without setting the capacity?
> 
> Hi Eric, I tested this case in following steps, the result is fine, the capability is setted.
> 
> [root@38 sys]# make-bcache -B /dev/nvme1n1
> UUID:			6758bd42-c226-4de9-a6d5-fb003af63f9f
> Set UUID:		2661eadd-79b4-4c56-a2fb-9f8b505aa9fd
> version:		1
> block_size:		1
> data_offset:		16
> [root@38 sys]# ls /dev/bcache
> bcache/  bcache0
> [root@38 sys]# fdisk -l
> Disk /dev/nvme1n1: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> ....
> Disk /dev/bcache0: 1.8 TiB, 2000398925824 bytes, 3907029152 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> ....
> [root@38 sys]# make-bcache -C /dev/ram0
> UUID:			b64a4425-b9c1-4650-9cab-3856410c9566
> Set UUID:		a0a31965-a89d-43b6-a5d6-968897abeb7a
> version:		0
> nbuckets:		1024
> block_size:		1
> bucket_size:		1024
> nr_in_set:		1
> nr_this_dev:		0
> first_bucket:		1
> [root@38 sys]# echo a0a31965-a89d-43b6-a5d6-968897abeb7a > /sys/block/bcache0/bcache/attach
> [root@38 sys]# echo writeback > /sys/block/bcache0/bcache/cache_mode
> [root@38 sys]# mount /dev/bcache0 /tmp
> [root@38 sys]# cd /tmp/
> [root@38 tmp]# fio ~/fio_write.sh
> file1: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
> fio-2.2.8
> Starting 1 thread
> file1: Laying out IO file(s) (1 file(s) / 128MB)
> Jobs: 1 (f=1): [w(1)] [0.0% done] [0KB/177.2MB/0KB /s] [0/45.4K/0 iops] [eta 05h:33m:13s]
> 
> Thanks!
> Yijing.

I want to make sure that the set_capacity call that happens on cache 
attachment is not necessary when a backing device is attached without 
its dirty writeback cache since bcache0 is not presented until the cache 
attaches in that case.

Can you also unregister the volume, attach the backing device first, and 
then the cache while the cache is dirty to make sure that the size is set 
correctly?

--
Eric Wheeler

> 
> > 
> > -Eric
> > 
> >>  	dc->disk.disk->queue->backing_dev_info.ra_pages =
> >>  		max(dc->disk.disk->queue->backing_dev_info.ra_pages,
> >>  		    q->backing_dev_info.ra_pages);
> >> -- 
> >> 2.5.0
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-2125174138-1480530874=:442--
