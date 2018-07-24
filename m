From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2] bcache: set max writeback rate when I/O request is
 idle
Date: Tue, 24 Jul 2018 16:28:15 +0800
Message-ID: <3017b789-5bb5-1767-3eef-3bf5dffb7126@suse.de>
References: <20180724040310.1590-1-colyli@suse.de>
 <0153e339-543f-6b78-a461-78abf7c800e8@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <0153e339-543f-6b78-a461-78abf7c800e8@profihost.ag>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/24 3:16 PM, Stefan Priebe - Profihost AG wrote:
> Am 24.07.2018 um 06:03 schrieb Coly Li:
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
>>
>> Fixes: Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
>> Cc: stable@vger.kernel.org #4.16+
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Tested-by: Kai Krakow <kai@kaishome.de>
>> Cc: Michael Lyle <mlyle@lyle.org>
>> Cc: Stefan Priebe <s.priebe@profihost.ag>
> 
> Hi Coly,
> 
> i'm still experiencing the same bug as yesterday while rebooting every
> two times i get a deadlock in cache_set_free.
> 
> Sadly it's so late ion the shutdown process that netconsole is already
> unloaded or at least i get no messages from while it happens. The traces
> look the same like yesterday.

Hi Stefan,

Do you use the v2 patch on latest SLE15 kernel source? Let me try to
reproduce it on my machine. I assume when you reboot, the cache is still
dirty and not clean up, am I right ? And which file system do you mount
on top of the bcache device ?

Thanks.

Coly Li
