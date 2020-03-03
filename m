From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Tue, 3 Mar 2020 17:03:07 +0100
Message-ID: <20200303160307.GI4380@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200303121918.GA27520@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Coly Li <colyli@suse.de>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
List-Id: linux-bcache@vger.kernel.org

On Tue 03-03-20 13:19:18, Oleg Nesterov wrote:
[...]
> but I am not sure this optmization makes sense.

I would much rather start with a clarification on what should be use
what shouldn't. Because as of now, people tend to copy patterns which
are broken or simply do not make any sense at all.

-- 
Michal Hocko
SUSE Labs
