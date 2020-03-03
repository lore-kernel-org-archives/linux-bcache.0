From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Tue, 3 Mar 2020 02:22:28 +0100
Message-ID: <495d18c6-3776-33c7-c48b-bb85b31c3a96@cloud.ionos.com>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
 <20200302134048.GK4380@dhcp22.suse.cz>
 <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
 <20200302172840.GQ4380@dhcp22.suse.cz>
 <5693a819-e323-3232-2048-413566c2254f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <5693a819-e323-3232-2048-413566c2254f@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Michal Hocko <mhocko@kernel.org>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com, Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-bcache@vger.kernel.org

Hi Coly,

On 3/2/20 6:47 PM, Coly Li wrote:
>> I have a vague recollection that there are mutlitple timeouts and
>> setting only some is not sufficient.
>>
> Let me try out how to extend udevd timeout.

Not sure if this link [1] helps or not, just FYI.

[1] https://github.com/jonathanunderwood/mdraid-safe-timeouts

Thanks,
Guoqing
