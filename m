From: James Pharaoh <james@pharaoh.uk>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Thu, 27 Oct 2016 22:46:40 +0100
Message-ID: <55f00885-fb2b-6132-d687-a2230430f47f@pharaoh.uk>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:47768
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934892AbcJ0Vq4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Oct 2016 17:46:56 -0400
In-Reply-To: <20161026223158.GA9283@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org

On 26/10/16 23:31, Vojtech Pavlik wrote:

> I believe your faith in SSDs is somewhat misplaced, they do not so
> infrequently die ahead of their SMART announcement and if they do, they
> don't just get bad sectors, the whole device is gone.

In my experience they are extremely reliable, compared to traditional 
drives, and much faster, which increases their reliability because a 
rebuild/restore is much faster.

And of course I have redundant backups, stored in systems with 
significantly distinct designs, locations, access controls, etc.

> In case you want to protect your data, either use a RAID for your cache
> devices, too, use it in write through mode, or in write-back mode with
> zero dirty data target.

Ok, I'm not sure what this means, but it sounds like it is something I 
might want to use. Have you got a link for this?

>> I am making assumptions about the ordering of writes that RAID5
>> makes, and will post to the appropriate list about that, with the
>> possibility of another option. However, I also note that bcache
>> "optimises" sequential writes directly to the underlying device:
>
> In case you're using mdraid for the RAID part on a reasonably recent
> Linux kernel, there is no write hole. Linux mdraid implements barriers
> properly even on RAID5, at the cost of performance - mdraid waits for a
> barrier to complete on all drives before submitting more i/o.
>
> Any journalling, log or cow filesystem that relies on i/o barriers for
> consistency will be consistent in Linux even on mdraid RAID5.

Ok, wow, I did not know this. Again, have you got a link to any 
documentation about this. Unfortunately these kind of low-level systems 
tend to be quite hard to find information about...

> Using bcache to accelerate a RAID using a SSD is a fairly common use
> case. What you're asking for can likely be achieved by:
>
> 	echo writeback	> cache_mode
> 	echo 0     	> writeback_percent
> 	echo 10240  	> writeback_rate
> 	echo 5		> writeback_delay
> 	echo 0     	> readahead
> 	echo 0      	> sequential_cutoff
> 	echo 0      	> cache/congested_read_threshold_us
> 	echo 0      	> cache/congested_write_threshold_us
>
> This is what I use personally on my system with success.

Thanks, I'll look at this. Genuinelly a much more helpful response than 
I could ever have hoped for ;-)

James
