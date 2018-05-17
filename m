From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2] bcache: return 0 from bch_debug_init() if
 CONFIG_DEBUG_FS=n
Date: Thu, 17 May 2018 22:33:51 +0800
Message-ID: <4dcc0ee4-6db1-3da5-5526-1b2d4121dd88@suse.de>
References: <20180517095348.21392-1-colyli@suse.de>
 <20180517113548.GA24817@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180517113548.GA24817@kmo-pixel>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/5/17 7:35 PM, Kent Overstreet wrote:
> On Thu, May 17, 2018 at 05:53:48PM +0800, Coly Li wrote:
>> Commit 539d39eb2708 ("bcache: fix wrong return value in bch_debug_init()")
>> returns the return value of debugfs_create_dir() to bcache_init(). When
>> CONFIG_DEBUG_FS=n, bch_debug_init() always returns 1 and makes
>> bcache_init() failedi.
>>
>> This patch makes bch_debug_init() always returns 0 if CONFIG_DEBUG_FS=n,
>> so bcache can continue to work for the kernels which don't have debugfs
>> enanbled.
>>
>> Fixes: Commit 539d39eb2708 ("bcache: fix wrong return value in bch_debug_init()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Reported-by: Massimo B. <massimo.b@gmx.net>
>> Reported-by: Kai Krakow <kai@kaishome.de>
>> Tested-by: Kai Krakow <kai@kaishome.de>
>> Cc: Kent Overstreet <kent.overstreet@gmail.com>
>> ---
>>  drivers/md/bcache/bcache.h | 5 +++++
>>  drivers/md/bcache/debug.c  | 8 ++++----
>>  2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index 3a0cfb237af9..5b3fe87f32ee 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -994,8 +994,13 @@ void bch_open_buckets_free(struct cache_set *);
>>  
>>  int bch_cache_allocator_start(struct cache *ca);
>>  
>> +#ifdef CONFIG_DEBUG_FS
> 
> you could just use if (IS_ENABLED(CONFIG_DEBUG_FS)) in bch_debug_init, that way
> you don't need to add an #ifdef
> 

Yes, it is much simpler. v3 patch resent for your review.

Thanks for the hint.

Coly Li
