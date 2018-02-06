From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v5 06/10] bcache: add stop_when_cache_set_failed option to
 backing device
Date: Tue, 6 Feb 2018 19:24:57 +0800
Message-ID: <60c4c4b9-b377-e024-e005-9560b326dc5e@suse.de>
References: <20180206042100.65021-1-colyli@suse.de>
 <20180206042100.65021-7-colyli@suse.de> <87bmh25r49.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87bmh25r49.fsf@esperi.org.uk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Pavel Goran <via-bcache@pvgoran.name>, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>
List-Id: linux-bcache@vger.kernel.org

On 06/02/2018 6:50 PM, Nix wrote:
> On 6 Feb 2018, Coly Li verbalised:
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index 7917b3820dd5..263164490833 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -287,6 +287,12 @@ struct io {
>>  	sector_t		last;
>>  };
>>  
>> +enum stop_on_faliure {
> 
> failure?
> 
>> +	BCH_CACHED_DEV_STOP_ATUO = 0,
> 
> AUTO?
> 
>> +	enum stop_on_faliure	stop_when_cache_set_failed;
> 
> (... and all uses would need changing too.)
> 
Thanks for the errata, I just send a single update for this patch.

Coly Li
