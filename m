From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Tue, 3 Mar 2020 09:30:20 +0800
Message-ID: <fc05381c-f14f-3a40-465d-a8510fe6e93b@suse.de>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
 <20200302134048.GK4380@dhcp22.suse.cz>
 <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
 <20200302172840.GQ4380@dhcp22.suse.cz>
 <5693a819-e323-3232-2048-413566c2254f@suse.de>
 <495d18c6-3776-33c7-c48b-bb85b31c3a96@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgCCBa1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 20:30:27 -0500
In-Reply-To: <495d18c6-3776-33c7-c48b-bb85b31c3a96@cloud.ionos.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Michal Hocko <mhocko@kernel.org>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com, Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>

On 2020/3/3 9:22 上午, Guoqing Jiang wrote:
> Hi Coly,
> 
> On 3/2/20 6:47 PM, Coly Li wrote:
>>> I have a vague recollection that there are mutlitple timeouts and
>>> setting only some is not sufficient.
>>>
>> Let me try out how to extend udevd timeout.
> 
> Not sure if this link [1] helps or not, just FYI.
> 
> [1] https://github.com/jonathanunderwood/mdraid-safe-timeouts
> 

Guoqing,

Thanks. Let me look into it :-)

-- 

Coly Li
