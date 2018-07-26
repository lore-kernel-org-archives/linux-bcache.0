From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v3] bcache: set max writeback rate when I/O request is
 idle
Date: Thu, 26 Jul 2018 21:18:17 +0800
Message-ID: <8b8cbad7-0aec-7d41-ff97-d8c07e8820be@suse.de>
References: <20180726104255.40929-1-colyli@suse.de>
 <46dcb9f6-f193-c538-7cc8-c26729d0c404@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <46dcb9f6-f193-c538-7cc8-c26729d0c404@profihost.ag>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/26 7:49 PM, Stefan Priebe - Profihost AG wrote:
> Am 26.07.2018 um 12:42 schrieb Coly Li:
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
> Tested-by: Stefan Priebe <s.priebe@profihost.ag>
> 
> Working fine now.
> 

Great news, thanks !

Coly Li

>> Fixes: Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
>> Cc: stable@vger.kernel.org #4.16+
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Tested-by: Kai Krakow <kai@kaishome.de>
>> Cc: Michael Lyle <mlyle@lyle.org>
>> Cc: Stefan Priebe <s.priebe@profihost.ag>
>> ---
>> Channgelog:
>> v3, Do not acquire bch_register_lock in set_at_max_writeback_rate().
>> v2, Fix a deadlock reported by Stefan Priebe.
>> v1, Initial version.
>>
>>  drivers/md/bcache/bcache.h    | 10 ++--
>>  drivers/md/bcache/request.c   | 54 ++++++++++++++++++++-
>>  drivers/md/bcache/super.c     |  4 ++
>>  drivers/md/bcache/sysfs.c     | 14 ++++--
>>  drivers/md/bcache/util.c      |  2 +-
>>  drivers/md/bcache/util.h      |  2 +-
>>  drivers/md/bcache/writeback.c | 91 +++++++++++++++++++++++------------
>>  7 files changed, 133 insertions(+), 44 deletions(-)
[snipped]
