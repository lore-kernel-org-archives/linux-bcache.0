From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: can't use ramdisk as cache device. Receive "Can't attach [UUID]:
 cache set not found" error
Date: Thu, 25 Feb 2016 08:15:54 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602250812230.3635@mail.ewheeler.net>
References: <CABXj3oCqcw0dYGPWZTjEAgWwtA9QMWPT2vsdRBK04S55Mukocg@mail.gmail.com> <alpine.LRH.2.11.1602240735220.32077@mail.ewheeler.net> <CABXj3oBdEo4NrVxgiDGk2Byte-4x_4dpn2Z5HPdySyo89cJKBA@mail.gmail.com> <alpine.LRH.2.11.1602250641360.3635@mail.ewheeler.net>
 <CABXj3oDg+6XCnh6YmrLfK7afd99EMnzmOfDQTQX_f8Q2jdtuzw@mail.gmail.com> <alpine.LRH.2.11.1602250726030.3635@mail.ewheeler.net> <alpine.LRH.2.11.1602250737220.3635@mail.ewheeler.net> <CABXj3oBmF4wmfqGMyCfOWD84=aF5CcmtzO1Q21drEsqPqwf3wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:39208 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759342AbcBYIP5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 03:15:57 -0500
In-Reply-To: <CABXj3oBmF4wmfqGMyCfOWD84=aF5CcmtzO1Q21drEsqPqwf3wg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Scott McGillivray <scott.mcgillivray@gmail.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>


On Thu, 25 Feb 2016, Scott McGillivray wrote:

> yes thank you. When using zram and -w 4096 it worked as expected.
> 
> But when i re-tested with /dev/ram0 which is using the BLK_DEV_RAM/brd
> ram device as cache. The make-bcache worked OK but when i tried to
> register the device via "echo /dev/ram0 > /sys/fs/bcache/register" it
> blows up with below error in dmesg.
> 
> Call Trace:
> [ 8460.086681]  [<ffffffff812f8ae7>] kobj_attr_store+0xf/0x19
> [ 8460.086685]  [<ffffffff811fd737>] sysfs_kf_write+0x3e/0x40
> [ 8460.086689]  [<ffffffff811fcc40>] kernfs_fop_write+0xe9/0x136
> [ 8460.086694]  [<ffffffff8119b0ed>] __vfs_write+0x28/0xa7
> [ 8460.086699]  [<ffffffff81286ed3>] ? security_file_permission+0x3b/0x42
> [ 8460.086705]  [<ffffffff8109b30c>] ? percpu_down_read+0x1f/0x41
> [ 8460.086708]  [<ffffffff8119d604>] ? __sb_start_write+0x24/0x41
> [ 8460.086712]  [<ffffffff8119bba2>] vfs_write+0x8f/0xe5
> [ 8460.086715]  [<ffffffff8119c534>] SyS_write+0x46/0x79
> [ 8460.086720]  [<ffffffff81645176>] entry_SYSCALL_64_fastpath+0x16/0x75
> [ 8460.086722] Code: 00 48 83 ff 04 77 09 49 89 bd b8 0a 00 00 eb 0f
> e8 c6 c3 ff ff 48 ff c8 49 89 85 b8 0a 00 00 49 8b bd b8 0a 00 00 48
> 85 ff 75 02 <0f> 0b 48 ff c7 e8 a6 c3 ff ff 48 8d 14 c5 00 00 00 00 48
> ff c8
> [ 8460.086766] RIP  [<ffffffffc00e832f>] register_bcache+0xe27/0x1423 [bcache]

I just posted a patch in the thread "Re: bcache: register_cache() error 
opening sdh2" that might cleanup register_cache() error handling, and 
might give a better error---but ram0 devices are rather old and might not 
do what you want.  I seem to remember they need to be initialized by 
	dd if=/dev/zero of=/dev/ram0 
or some such thing.  I always seem to have trouble with /dev/ramX devices.

You might be better off using /dev/loop0 and loopback a file in /dev/shm/ 
or /dev/hugepages/.


--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298


> 
> 
> 
> On 25 February 2016 at 15:39, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> > On Thu, 25 Feb 2016, Eric Wheeler wrote:
> >
> >> On Thu, 25 Feb 2016, Scott McGillivray wrote:
> >>
> >> > that doesn't work either. It gives the same error from my opening
> >> > post. Although this time it's also giving a new message in dmesg about
> >> > block size.
> >> >
> >> >
> >> > bcache: bch_cached_dev_attach() Couldn't attach sdf: block size less
> >> > than set's block size
> >> > bcache: __cached_dev_store() Can't attach 0bba8852-ad4f-41f4-bfa3-679a886a14ad
> >> >                : cache set not found
> >> >
> >> > which is strange because both devices block size are the same
> >> >
> >> > $ blockdev --getbsz /dev/sdf
> >> > 4096
> >> >
> >> > $ blockdev --getbsz /dev/zram0
> >> > 4096
> >>
> >>
> >> Try this:
> >>   make-bcache -w 4096 -C /dev/zram0
> >
> > I'm not sure if -w needs to be called on the backing device too---but if
> > you do then expect to loose data when reformatting.
> >
> > If you decide reformat both backing and cache devices to test, then you
> > might consider aligning your data to your backing volume's stride width
> > with --data-offset NNN while you're at it if you haven't already.
> >
> > -Eric
> >
> >>
> >> >
> >> >
> >> > On 25 February 2016 at 14:44, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> >> > > On Thu, 25 Feb 2016, Scott McGillivray wrote:
> >> > >
> >> > >> No, doesn't' work either i'm afraid. Below is example of failing
> >> > >> silently with ram disk and succeeded with HDD as cache device.
> >> > >>
> >> > >> Tested with /lib/modules/4.5.0-rc3+/kernel/drivers/md/bcache/bcache.ko
> >> > >>
> >> > >>
> >> > >> with zram - doesn't work
> >> > >> =================
> >> > >>
> >> > >> $ ls -al /sys/fs/bcache/
> >> > >> total 0
> >> > >> drwxr-xr-x 2 root root    0 Feb 25 13:42 .
> >> > >> drwxr-xr-x 9 root root    0 Feb 25 13:40 ..
> >> > >> --w------- 1 root root 4096 Feb 25 13:40 register
> >> > >> --w------- 1 root root 4096 Feb 25 13:40 register_quiet
> >> > >>
> >> > >> $ file /dev/zram0
> >> > >> /dev/zram0: block special (250/0)
> >> > >>
> >> > >> $ fdisk -l /dev/zram0
> >> > >> Disk /dev/zram0: 1 GiB, 1073741824 bytes, 262144 sectors
> >> > >>
> >> > >> $ make-bcache -C /dev/zram0
> >> > >> UUID: 87e63981-7bd8-4cc3-93db-9ca275367c21
> >> > >> Set UUID: 0bba8852-ad4f-41f4-bfa3-679a886a14ad
> >> > >> version: 0
> >> > >> nbuckets: 2048
> >> > >> block_size: 8
> >> > >> bucket_size: 1024
> >> > >> nr_in_set: 1
> >> > >> nr_this_dev: 0
> >> > >> first_bucket: 1
> >> > >
> >> > > did you   `echo /dev/zram0 > /sys/fs/bcache/register`
> >> > > and then  `echo <CSET-UUID> > /sys/block/bcache0/bcache/attach`
> >> > >
> >> > > Not sure which UUID is the CSET UUID.  Probably
> >> > > 0bba8852-ad4f-41f4-bfa3-679a886a14ad.
> >> > >
> >> > > See attaching bcache0 to a cache:
> >> > > https://www.kernel.org/doc/Documentation/bcache.txt
> >> > >
> >> > > -Eric
> >> > >
> >> > >>
> >> > >>
> >> > >> No errors, but nothing in dmesg and contents of /sys/fs/bcache/ remain
> >> > >> exactly the same... no UUID. Seems to just silently fail.
> >> > >>
> >> > >>
> >> > >> with HDD - works as expected.
> >> > >> =====================
> >> > >>
> >> > >> $ fdisk -l /dev/sdf
> >> > >> Disk /dev/sdf: 1 GiB, 1073741824 bytes, 2097152 sectors
> >> > >>
> >> > >> $ file /dev/sdf
> >> > >> /dev/sdf: block special (8/80)
> >> > >>
> >> > >> $ make-bcache -C /dev/sdf
> >> > >> UUID: 3234c9e7-8186-4a7c-99a8-ae6a371c6f2c
> >> > >> Set UUID: 9a71faf7-a408-4f4d-906e-e5d67e43291f
> >> > >> version: 0
> >> > >> nbuckets: 2048
> >> > >> block_size: 1
> >> > >> bucket_size: 1024
> >> > >> nr_in_set: 1
> >> > >> nr_this_dev: 0
> >> > >> first_bucket: 1
> >> > >>
> >> > >> $ ls -al /sys/fs/bcache/
> >> > >> total 0
> >> > >> drwxr-xr-x 3 root root    0 Feb 25 13:48 .
> >> > >> drwxr-xr-x 9 root root    0 Feb 25 13:40 ..
> >> > >> drwxr-xr-x 7 root root    0 Feb 25 13:48 9a71faf7-a408-4f4d-906e-e5d67e43291f
> >> > >> --w------- 1 root root 4096 Feb 25 13:40 register
> >> > >> --w------- 1 root root 4096 Feb 25 13:40 register_quiet
> >> > >>
> >> > >> $ dmesg
> >> > >> [  714.168488] bcache: register_cache() registered cache device sdf
> >> > >>
> >> > >>
> >> > >> Thank you.
> >> > >>
> >> > >> On 24 February 2016 at 15:37, Eric Wheeler <lists@ewheeler.net> wrote:
> >> > >> >
> >> > >> > On Tue, 16 Feb 2016, Scott McGillivray wrote:
> >> > >> >
> >> > >> >> Hello
> >> > >> >>
> >> > >> >> I am using Ubuntu 15.10 with latest nightly 4.5 kernel. Ubuntu creates
> >> > >> >> 16 RAM drives as /dev/ram0 - ram16 by default and i am trying to test
> >> > >> >> bcache and use one of these as a cache device.
> >> > >> >>
> >> > >> >> wipefs /dev/sdd
> >> > >> >> wipefs /dev/sdd -a
> >> > >> >> wipefs /dev/ram0
> >> > >> >> wipefs /dev/ram0 -a
> >> > >> >> make-bcache -B /dev/sdd -C /dev/ram0
> >> > >> >
> >> > >> > Does it work with /dev/zram0?   You would prep it something like this:
> >> > >> >
> >> > >> >         modprobe zram
> >> > >> >         echo $((1024*1024*1024)) > /sys/block/zram0/disksize # 1GB
> >> > >> >         make-bcache  -C /dev/zram0
> >> > >> >
> >> > >> > -Eric
> >> > >> >
> >> > >> >
> >> > >> >
> >> > >> >> At this point there were no errors output but there is also no UUID
> >> > >> >> entry in /sys/fs/bcache/. Only register and register_quiet.
> >> > >> >>
> >> > >> >> bache-super-show correctly prints info about both block and cache
> >> > >> >> devices when queried but when i try to manually attach the cache
> >> > >> >> device with echo cset.uuid > /sys/block/bcache0/bcache/attach i get no
> >> > >> >> error but in dmesg i see
> >> > >> >>
> >> > >> >> bcache: __cached_dev_store() Can't attach
> >> > >> >> 3f2521a6-2103-4e2e-a47d-cc56558e8f7d: cache set not found
> >> > >> >>
> >> > >> >> If i repeat this example but use another sd block device as cache then
> >> > >> >> it works OK.
> >> > >> >>
> >> > >> >> Can anyone confirm if it should be possible to use the ramdisk based
> >> > >> >> block device as a caching device with bcache ?
> >> > >> >>
> >> > >> >> I also tried to use a loop device as cache and that didn't work
> >> > >> >> either.. i got "kernel bug" in dmesg for
> >> > >> >> drivers/md/bcache/super.c:1812. RIP []
> >> > >> >> cache_alloc.isra.21+0x646/0x670[bcache]
> >> > >> >>
> >> > >> >> Does bcache need the cache device to be a certain block type i.e sd 8
> >> > >> >> ? Should i be able to use any block device from /proc/devices as a
> >> > >> >> cache device ?
> >> > >> >>
> >> > >> >> The kernel options used for ramdisk are:
> >> > >> >>
> >> > >> >> CONFIG_BLK_DEV_RAM=y
> >> > >> >> CONFIG_BLK_DEV_RAM_COUNT=16
> >> > >> >> CONFIG_BLK_DEV_RAM_SIZE=65536
> >> > >> >> CONFIG_BLK_DEV_RAM_DAX=y
> >> > >> >>
> >> > >> >> Thank you.
> >> > >> >> Scott
> >> > >> >> --
> >> > >> >> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >> > >> >> the body of a message to majordomo@vger.kernel.org
> >> > >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > >> >>
> >> > >> >
> >> > >> >
> >> > >> >
> >> > >> > --
> >> > >> > Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
> >> > >> > 888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
> >> > >> > www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
> >> > >> >
> >> > >> --
> >> > >> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >> > >> the body of a message to majordomo@vger.kernel.org
> >> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > >>
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
