From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: set max writeback rate when I/O request is idle
Date: Mon, 23 Jul 2018 21:39:19 +0800
Message-ID: <b535d904-7d8a-15c3-c85b-d915ae2ceb18@suse.de>
References: <20180722161316.2347-1-colyli@suse.de>
 <CAC2ZOYvhJnMFm2-wFo1xPkJFTtB_xYo7EbfUZyvw07mvG5+Ahg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAC2ZOYvhJnMFm2-wFo1xPkJFTtB_xYo7EbfUZyvw07mvG5+Ahg@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Kai Krakow <kai@kaishome.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/23 9:14 PM, Kai Krakow wrote:
> 2018-07-22 18:13 GMT+02:00 Coly Li <colyli@suse.de>:
>> Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
>> allows the writeback rate to be faster if there is no I/O request on a
>> bcache device. It works well if there is only one bcache device attached
>> to the cache set. If there are many bcache devices attached to a cache
>> set, it may introduce performance regression because multiple faster
>> writeback threads of the idle bcache devices will compete the btree level
>> locks with the bcache device who have I/O requests coming.
>>
>> This patch fixes the above issue by only permitting fast writebac when
>> all bcache devices attached on the cache set are idle. And if one of the
>> bcache devices has new I/O request coming, minimized all writeback
>> throughput immediately and let PI controller __update_writeback_rate()
>> to decide the upcoming writeback rate for each bcache device.
>>
>> Also when all bcache devices are idle, limited wrieback rate to a small
>> number is wast of thoughput, especially when backing devices are slower
>> non-rotation devices (e.g. SATA SSD). This patch sets a max writeback
>> rate for each backing device if the whole cache set is idle. A faster
>> writeback rate in idle time means new I/Os may have more available space
>> for dirty data, and people may observe a better write performance then.
>>
>> Please note bcache may change its cache mode in run time, and this patch
>> still works if the cache mode is switched from writeback mode and there
>> is still dirty data on cache.
> 
> Running with this patch on 4.17, I see reduced IO lags in desktop
> usage during heavy writes. The reduction is minor but noticeable. The
> small short IO lags seem to be fixed with this but I still see the
> stalls with long lags in desktop usage. I don't address those to
> bcache, tho. This seems more like an issue resulting from using bees
> on btrfs.
> 
> 
>> Fixes: Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
>> Cc: stable@vger.kernel.org #4.16+
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Michael Lyle <mlyle@lyle.org>
> 

Hi Kai,

> Tested-by: Kai Krakow <kai@kaishome.de>
> 

Thank you for the testing and information sharing, very helpful :-)

Coly Li

> 
>> ---
>>  drivers/md/bcache/bcache.h    |  9 +---
>>  drivers/md/bcache/request.c   | 42 ++++++++++++++-
>>  drivers/md/bcache/sysfs.c     | 14 +++--
>>  drivers/md/bcache/util.c      |  2 +-
>>  drivers/md/bcache/util.h      |  2 +-
>>  drivers/md/bcache/writeback.c | 98 +++++++++++++++++++++++++----------
>>  6 files changed, 126 insertions(+), 41 deletions(-)
[snip]
