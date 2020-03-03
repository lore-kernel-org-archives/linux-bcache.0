From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Tue, 3 Mar 2020 08:22:20 +0100
Message-ID: <3e6b36e3-72eb-30e4-c99d-40665ea31725@suse.de>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz> <20200302134919.GB9769@redhat.com>
 <48c6480a-3b26-fb7f-034d-923f9b8875f1@suse.de>
 <dfcd5b4d-592d-fe2a-5c25-ac22729b479e@kernel.dk>
 <2e4898f0-0c2b-9320-b925-456a85ebdea0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbgCCHWX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Mar 2020 02:22:23 -0500
In-Reply-To: <2e4898f0-0c2b-9320-b925-456a85ebdea0@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, mkoutny@suse.com

On 3/2/20 6:32 PM, Coly Li wrote:
> On 2020/3/3 1:19 上午, Jens Axboe wrote:
[ ..
>> What if someone else tried to kill the startup? It'd be pretty
>> frustrating that it was impossible, just because signals were blocked or
>> flushed. The assumption that systemd is the ONLY task that would want to
>> kill it is flawed.
>>
> 
> Indeed now the bcache registration can not be killed. I guess it is
> because the mutex lock held during the metadata checking.
> Sure I will look at how to extend udevd timeout value now, and ask for
> help later.
> 
Please check if the bcache registration really needs to be synchronous.
What exactly do you gain from having a return value (which, seeing
that's a simple write() to a sysfs attribute, is probably ignored anyway)?
To my understanding, the bcache registration process creates the actual
bcache device, which in itself will generate a udev event.
So the existence of the bcache device will already signal a successful
completion of the registration process.
Hence it should be possible to shift the actual bcache registration to a
kworker, and have the 'write()' call completed after schedule_work() (or
equivalents) are called.
That would circumvent the problem, no?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
