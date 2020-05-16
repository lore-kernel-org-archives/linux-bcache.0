From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Date: Sat, 16 May 2020 17:35:25 +0200
Message-ID: <20200516153525.GA16693@lst.de>
References: <20200516035434.82809-1-colyli@suse.de> <20200516035434.82809-4-colyli@suse.de> <20200516124020.GC13448@lst.de> <d3fe49f1-d37b-689e-ae0e-078b1254d7e7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d3fe49f1-d37b-689e-ae0e-078b1254d7e7@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk, linux-bcache@vger.kernel.org, kbusch@kernel.org
List-Id: linux-bcache@vger.kernel.org

On Sat, May 16, 2020 at 09:13:50PM +0800, Coly Li wrote:
> It is OK for me to set the zone_nr and zone size without calling
> blk_revalidate_disk_zones().

Yes.  And without having seen your code I'm pretty sure it should
get simpler by not using blk_revalidate_disk_zones.
