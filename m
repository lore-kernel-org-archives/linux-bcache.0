From: Wido den Hollander <wido@42on.com>
Subject: Re: [PATCH v1] bcache: partition support: add 16 minors per major
Date: Tue, 25 Oct 2016 09:05:04 +0200 (CEST)
Message-ID: <1510692086.172.1477379105196@ox.pcextreme.nl>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
 <20160928191142.2e545aa5@harpe.intellique.com>
 <1406388200.5277.1475090090844@ox.pcextreme.nl>
 <20160929160903.10b63b45@harpe.intellique.com>
 <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
 <20160929183122.3641f307@harpe.intellique.com>
 <293451899.5382.1475167934533@ox.pcextreme.nl>
 <20160929191127.779f94d0@harpe.intellique.com>
 <1673593557.6129.1476447335568@ox.pcextreme.nl>
 <alpine.LRH.2.11.1610231807320.24191@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp01.mail.pcextreme.nl ([109.72.87.137]:45309 "EHLO
        smtp01.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750804AbcJYHFL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Oct 2016 03:05:11 -0400
In-Reply-To: <alpine.LRH.2.11.1610231807320.24191@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, Eric Wheeler <bcache@lists.ewheeler.net>
Cc: "Jens-U. Mozdzen" <jmozdzen@nde.ag>, Kent Overstreet <kent.overstreet@gmail.com>, Emmanuel Florac <eflorac@intellique.com>


> Op 24 oktober 2016 om 3:19 schreef Eric Wheeler <bcache@lists.ewheeler.net>:
> 
> 
> On Fri, 14 Oct 2016, Wido den Hollander wrote:
> > > Op 29 september 2016 om 19:11 schreef Emmanuel Florac <eflorac@intellique.com>:
> > > Le Thu, 29 Sep 2016 18:52:14 +0200 (CEST)
> > > Wido den Hollander <wido@42on.com> écrivait:
> > > > > I agree, but usually you wouldn't partition an MD-RAID either, would
> > > > > you? OSDs are still holding (so far) ordinary filesystems locally
> > > > > mounted on the nodes (except for BlueStore AFAIK).
> > > > I have partitioned MD-RAID before, works just fine.
> > > 
> > > Yes, sure. It just doesn't feel right, my  grey-bearded Unix instinct
> > > tingles :)
> > > 
> > > > The question still remains, can bcache be patched that it allocates
> > > > the right minor in the kernel so that it allows for partitions.
> > > 
> > > Even looks easy... As Sam Yaple made a patch.
> > > 
> > > > I'm not a kernel nor bcache developer, just looking for somebody who
> > > > would be willing to do this. Happy to assist, support and test!
> > > 
> > > Well if I have some time I may give it a try next week :)
> > > 
> > 
> > I was wondering if you were able to take a look at this?
> 
> Hi Wido,
> 
> See below and please test.  It works for me, but I've not done any more 
> than create a partition and verify that it was detected.  Use-case 
> opinions aside, some may or may not wish to use partitions atop of bcache. 
> (If you do, just make sure they are aligned correctly!).
> 
> I'll add your tested-by and request a pull for v4.9 unless someone has 
> good reason to implement this differently.
> 

I build a kernel yesterday and tested it this morning, what I see is that it works and I can use the devices.

root@VM-f3149531-0c9f-47c4-bbf6-85226190bd26:~# ls -l /dev/bcache0*
brw-rw---- 1 root disk 251, 0 Oct 25 08:57 /dev/bcache0
brw-rw---- 1 root disk 251, 1 Oct 25 08:58 /dev/bcache0p1
brw-rw---- 1 root disk 251, 2 Oct 25 08:59 /dev/bcache0p2
brw-rw---- 1 root disk 251, 3 Oct 25 09:00 /dev/bcache0p3
root@VM-f3149531-0c9f-47c4-bbf6-85226190bd26:~# parted /dev/bcache0 print
Model: Unknown (unknown)
Disk /dev/bcache0: 107GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  10.7GB  10.7GB  ext4         primary
 2      10.7GB  53.7GB  42.9GB  ext4         primary
 3      53.7GB  107GB   53.7GB  ext4         primary

root@VM-f3149531-0c9f-47c4-bbf6-85226190bd26:~# df -h|grep bcache
/dev/bcache0p2   40G   48M   38G   1% /tmp/bcache2
/dev/bcache0p1  9.8G   23M  9.2G   1% /tmp/bcache1
/dev/bcache0p3   50G   52M   47G   1% /tmp/bcache3
root@VM-f3149531-0c9f-47c4-bbf6-85226190bd26:~#

As you can see, I have a 100GB device, created a GPT label and three partitions. I formatted them with EXT4 and mounted them.

I can write files just as you would do on any other EXT4 filesystem.

Tested by: Wido den Hollander <wido@widodh.nl>

Wido

> Kent, is there any reason to change this implementation?
> 
> --
> Eric Wheeler
> 
> 
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 849ad44..6e53afd 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -58,6 +58,7 @@
>  struct workqueue_struct *bcache_wq;
>  
>  #define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
> +#define BCACHE_MINORS		16 /* partition support */
>  
>  /* Superblock */
>  
> @@ -783,8 +784,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  	if (minor < 0)
>  		return minor;
>  
> +	minor *= BCACHE_MINORS;
> +
>  	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
> -	    !(d->disk = alloc_disk(1))) {
> +	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
>  		ida_simple_remove(&bcache_minor, minor);
>  		return -ENOMEM;
>  	}
