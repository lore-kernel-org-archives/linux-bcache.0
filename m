From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Tue, 26 Sep 2017 22:27:23 +0200
Message-ID: <20170926222723.593624d1@jupiter.sol.kaishome.de>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
        <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
        <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
        <ad61e116-e69b-d62e-b4de-f20198d7a3fe@coly.li>
        <CAD7b65LwYmNA1=oSrYGcYkG3HtjCm7wK2BT+rc97bnKSW=Etiw@mail.gmail.com>
        <55d3cd06-e239-9374-be38-32514fd9089c@coly.li>
        <CAD7b65+2poC-gr6F6Z5EoNG3hvyxE=ugTsuKmUPTtMBbgfGr-A@mail.gmail.com>
        <5c279bfe-4f43-476e-efbf-ed6267670750@upx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43872 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S967769AbdIZU1g (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 16:27:36 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dwwRz-0004iC-63
        for linux-bcache@vger.kernel.org; Tue, 26 Sep 2017 22:27:27 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Tue, 26 Sep 2017 16:28:14 -0300
schrieb FERNANDO FREDIANI <fernando.frediani@upx.com>:

> Hello
> 
> Has anyone had any consideration about the usage of a single SSD for 
> both read and write and how that impacts the overall performance and 
> drive's endurance ?

Well, there's no option in bcache so you won't find out what the
difference would be.

But from my personal experience: Don't use a very cheap SSD, and don't
use a very small SSD.

With writeback caching, I brought my old 128G Crucial MX100 SSD to 99%
lifetime used (according to smartctl) within only one year of usage. I'm
sure it would last much longer as manufacturers tend to be very careful
with these numbers, but I'm also not very keen on trying only to find
out one day that my trusted data was eaten by a sudden SSD death.

After tuning filesystem behavior (no atime etc), I replaced it with a
512G SSD and only used 400G of it for bcache. Lifetime decrease is much
slower now, possibly working at least 4-5 more years (1 year in usage
now).

BTW: If you are going to use an SSD explicitly for caching, this means
you are trading SSD lifetime for increased HDD speed by intention. This
is a well-known side-effect and you should do your planning accordingly.

For me, I calculated that buying a medium-prized SSD every few years to
improve storage performance of a multi-TB HDD array is much cheaper
than getting a multi-TB SSD array or playing funny file
location/partition sizing/file system management games. I just throw
one SSD at it every few years, and the rest of the storage stays the
same: No (or very little) downtimes, no backup/restore, and almost as
fast as native SSD system perceived performance. A small price for a
huge improvement. I can still use the old SSD as replacement drives in
friends or parents laptop for better system performance there as long
as such systems are only used for simple tasks anyway, like checking
mail and browsing the web: This doesn't generate much writes and still
makes those old device snappy systems again. It's a good retirement
plan for your (ab)used caching SSDs.


> I am interested to find out more in order to adjust the necessary
> stuff and monitor it accordingly.

Use smartctl to monitor it: There's either a lifetime counter in
percent, or there's a wear-leveling counter. Both can be used together
with powered-on hours to estimate the time left before you should
consider replacing the SSD.

Once you get near the end of the estimated lifetime, watch the other
smartctl indicators closely if you want to use the SSD longer than
estimated lifetime. As stated above, manufacturers a careful when
estimating wear-leveling, so there's a good chance it would last
longer. Of course, you have working and tested backups in that case
but you have them anyways I'm sure... ;-)

Also, leave a good portion of your SSD untouched when its size is a
power of two (or nearby), e.g. 120/128G, 240/256G, 500/512G. The rule
of thumb is 15-20%. I'm using 400G of a 512G SSD, the rest is trimmed,
free space (except for EFI-ESP). Other manufacturers use "odd" sizes
like 80G, 160G etc. These already include hidden space for
wear-leveling - no need to leave 15-20% free.

Some people would say that you don't need to overprovision modern SSDs.
That is probably true for normal direct filesystem usage. But if you're
using bcache which is a huge blob of continuous data to the SSD
firmware: No chance to do proper wear-leveling as in a file system
which shuffles files around from time to time and runs discards on free
space. Bcache doesn't really do that, it is more like a log-fs only
doing garbage collection when it runs out of space. While bcache
supports discard, it never keeps free discarded space in the cache. It
only sends discards to allow the drive to shuffle around data in that
very moment for wear-leveling. You get better performance and
wear-leveling from bcache if you leave trimmed free space in the SSD.
At least this is my personal experience (very unscientific, tho... I
tried both modes for some time, and the system /feels/ snappier and
smartctl numbers /seem/ to wear slower with only 400G allocated)


> On 14/09/2017 12:14, FERNANDO FREDIANI wrote:
> > Hello Coly
> >
> > I didn't start this thread to provide numbers but to ask people view
> > on the concept and compare how flash technology works compared to
> > how it used to be a few years ago and I used ZFS case as an example
> > because people used to recommend to have separate devices until
> > sometime ago. My aim is to understand why this is not the
> > recommendation for bcache, if it already took in consideration newer
> > technology or if has anything else different on the way it deals
> > with write and read cache.
> >
> > Regards,
> > Fernando
> >
> >
> > On 14/09/2017 12:04, Coly Li wrote:
> >
> > On 2017/9/14 下午4:54, FERNANDO FREDIANI wrote:
> >
> > It depends on every scenario. SSDs generally have a max throughput
> > and a max IOPS for read and write, but when you mix them it becomes
> > more difficult to measure. A typical SSDs caching device used for
> > both tasks will have the normal writing for doing the writeback
> > caching, have writes coming from the permanent storage to cache
> > content more popular (so to populate the cache) and will have reads
> > to serve content already cache to the user who requested.
> >
> > Another point perhaps even more important than that is how the SSD
> > in question will stand for wearing. Now a days SSDs are much more
> > durable, specially those with higher DWPD. I read recently that
> > newer memory technology will do well compared to previous ones.
> >
> > Hi Fernando,
> >
> > It will be great if you may provide some performance numbers on ZFS
> > (I assume it should be ZFS since you mentioned it). I can
> > understand the concept, but real performance number should be more
> > attractive for this discussion :-)
> >
> > Thanks in advance.
> >
> > Coly Li
> >
> > On 14/09/2017 11:45, Coly Li wrote:
> >
> > On 2017/9/14 下午3:10, FERNANDO FREDIANI wrote:
> >
> > Hello Coly.
> >
> > If the users reads a piece of data that is just writen to SSD
> > (unlikely) it should first and in any condition be commited to the
> > permanent storage and then read from there and cached in another
> > area of the SSD. Writaback cache is very volatile and lasts only a
> > few seconds while the data is not yet committed to permanent
> > storage.
> >
> > In fact multiple device suport is not implemented yet, that's why I
> > am asking it and comparing with other well technology as ZFS.
> >
> > Hi Fernando,
> >
> > Do you have some performance number to compare combined and
> > separated configurations on ZFS ? If the performance improvement is
> > not from adding one more SSD device, I don't why dedicate
> > read/write SSDs may help for performance. In my understanding, if
> > any of the SSD has spared throughput capability for read or write,
> > mixed them together on both SSDs may have better performance number.
> >
> >
> > Coly Li
> >
> >
> > On 14/09/2017 04:58, Coly Li wrote:
> >
> > On 2017/9/11 下午4:04, FERNANDO FREDIANI wrote:
> >
> > Hi folks
> >
> > In Bcache people normally use a single SSD for both Read and Write
> > cache. This seems to work pretty well, at least for the load we have
> > been using here.
> >
> > However in other environments, specially on ZFS people tend to
> > suggest to use dedicated SSDs for Write (ZIL) and for Read (L2ARC).
> > Some say that performance will be much better in this way and
> > mainly say they have different wearing levels.
> > The issue now a days is that SSDs for Write Cache (or Writeback)
> > don't need to have much space available (8GB normally is more than
> > enough), just enough for the time until data is committed to the
> > pool (or slower disks) so it is hard to find a suitable SSD to
> > dedicate to this propose only without overprovisioning that part.
> > On the top of that newer SSDs have changed a lot in recent times
> > using different types of memory technologies which tend to be much
> > durable.
> >
> > Given that I personally see that using a single SSD for both Write
> > and Read cache, in any scenarios doesn't impose any significant
> > loss to the storage, given you use new technology SSDs and that you
> > will hardly saturate it most of the time. Does anyone agree or
> > disagree with that ?
> >
> > Hi Fernando,
> >
> > If there is any real performance number, it will be much easier to
> > response this idea. What confuses me is, if user reads a data block
> > which is just written to SSD, what is the benefit for the separated
> > SSDs.
> >
> > Yes I agree with you that some times a single SSD as cache device is
> > inefficient. Multiple cache device on bcache is a not-implemented
> > yet feature as I know.
> >
> > Thanks.
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-bcache" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> 



-- 
Regards,
Kai

Replies to list-only preferred.
