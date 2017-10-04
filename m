From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Thu, 5 Oct 2017 02:43:56 +0800
Message-ID: <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li>
 <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li>
 <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
 <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li>
 <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
 <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li>
 <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
 <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:33806 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbdJDSoE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Oct 2017 14:44:04 -0400
In-Reply-To: <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/10/2 上午1:34, Michael Lyle wrote:
> On Sun, Oct 1, 2017 at 10:23 AM, Coly Li <i@coly.li> wrote:
>> Hi Mike,
>>
>> Your data set is too small. Normally bcache users I talk with, they use
>> bcache for distributed storage cluster or commercial data base, their
>> catch device is large and fast. It is possible we see different I/O
>> behaviors because we use different configurations.
> 
> A small dataset is sufficient to tell whether the I/O subsystem is
> successfully aggregating sequential writes or not.  :P  It doesn't
> matter whether the test is 10 minutes or 10 hours...  The writeback
> stuff walks the data in order.  :P

Hi Mike,

I test your patch4,5 all these days, it turns out that your patch works
better when dirty data is full on cache device. And I can say it works
perfectly when dirty data is full on cache device and backing cached
device is a single spinning hard disk.

It is not because your data set is full, it is because when your data
set is small, the cache can be close to full state, then there is more
possibility to have adjacent dirty data blocks to writeback.

In the best case of your patch4,5, dirty data full on cache device and
cached device is a single spinning hard disk, writeback performance can
be 2x faster when there is no front end I/O. See one of the performmance
data (the lower the better)
http://blog.coly.li/wp-content/uploads/2017/10/existing_dirty_data_on_cache_single_disk_1T_full_cache.png



When the backing cached device gets faster and faster, your patch4,5
performs less and less advantage.

For same backing cached device size, when cache device gets smaller and
smaller, your patch4,5 performs less and less advantage.

And in the following configuration I find current bcache code performs
better (not too much) then your patch4,5 reorder method,
- cached device: A md linear device combined by 2x1.8T hard disks
- cache device: A 1800G NVMe SSD
- fio rand write blocksize 512K
- dirty data occupies 50% space of cache device (900G from 1800G)
One of the performance data can be found here,
http://blog.coly.li/wp-content/uploads/2017/10/existing_dirty_data_on_ssd_900_1800G_cache_half.png

> 
> ***We are measuring whether the cache and I/O scheduler can correctly
> order up-to-64-outstanding writebacks from a chunk of 500 dirty
> extents-- we do not need to do 12 hours of writes first to measure
> this.***
> 
> It's important that there be actual contiguous data, though, or the
> difference will be less significant.  If you write too much, there
> will be a lot more holes in the data from writeback during the test
> and from writes bypassing the cache.
>

I see,  your patches do perform better when dirty data are contiguous on
SSD. But we should know how much the probability in real world this
assumption can be real. Especially in some cases, your patches make
writeback performance slower than current bcache code does.

To test your patches, the following backing devices are used,
- md raid5 device composed by 4 hard disks
- md linear device composed by 2 hard disks
- md raid0 devices composed by 4 hard disks
- single 250G SATA SSD
- single 1.8T hard disk

And the following cache devices are used,
- 3.8T NVMe SSD
- 1.8T NVMe SSD partition
- 232G NVMe SSD partition

> Having all the data to writeback be sequential is an
> artificial/synthetic condition that allows the difference to be
> measured more easily.  It's about a 2x difference under these
> conditions in my test environment.  I expect with real data that is
> not purely sequential it's more like a few percent.

From my test, it seems in the following situation your patches4,5 works
better,
1)   backing cached device is slow
2.1) higher percentage of (cache_device_size/cached_device_size), this
means dirty data on cache device has more probability to be contiguous.
or 2.2) dirty data on cache device is almost full

This is what I observe in these days testing. I will continue to try
tomorrow to see in which percentage of dirty data on cache device when
current bcache code performs worse than your patch. So far I see when
cache is 50% full, and cache device is half size of cached device, your
patch4,5 won't have performance advantage, in my testing environment.

All performance comparison png files are too big, once I finish the
final benchmark, I will combine them into a pdf file and share a link.

Thanks.

-- 
Coly Li
