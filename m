From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] bio: ensure __bio_clone_fast copies bi_partno
Date: Fri, 17 Nov 2017 18:18:04 +0100
Message-ID: <20171117171804.GA27106@lst.de>
References: <20171117074725.22536-1-mlyle@lyle.org> <1510937438.2846.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510937438.2846.16.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "mlyle@lyle.org" <mlyle@lyle.org>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-bcache@vger.kernel.org

On Fri, Nov 17, 2017 at 04:50:39PM +0000, Bart Van Assche wrote:
> 
> How about the following class of assignments in drivers/md/raid1.c:
> 
> 		mbio->bi_disk = (void *)conf->mirrors[i].rdev;
> 
> Should these assignments perhaps be followed by a mbio->bi_partno assignment?

No.  They assign a struct md_rdev to the bi_disk pointer, abusing it
for internal storage.  They should not assign mbio->bi_partno.
Instead we should figure out a way to get rid of this.

> 
> How about the following class of assignments in the NVMe code:
> 
>                bio->bi_disk = disk;
> 
> Should these assignments perhaps be followed by a bio->bi_partno assignment?

No, the multipath code always works on whole namespaces, not partitions.
