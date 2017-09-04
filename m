From: Coly Li <i@coly.li>
Subject: Re: [PATCH 01/19] bcache: Fix leak of bdev reference
Date: Tue, 5 Sep 2017 01:30:04 +0800
Message-ID: <e9019647-62b5-1c14-8b2f-66528b972b5c@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <20170705182447.GA10673@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170705182447.GA10673@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, axboe@kernel.dk, Jan Kara <jack@suse.cz>
List-Id: linux-bcache@vger.kernel.org

On 2017/7/6 上午2:24, Christoph Hellwig wrote:
> On Fri, Jun 30, 2017 at 01:42:50PM -0700, bcache@lists.ewheeler.net wrote:
>> From: Jan Kara <jack@suse.cz>
>>
>> If blkdev_get_by_path() in register_bcache() fails, we try to lookup the
>> block device using lookup_bdev() to detect which situation we are in to
>> properly report error. However we never drop the reference returned to
>> us from lookup_bdev(). Fix that.
> 
> This look ok, but I think that whole chunk of code should just go
> away - adding a lookup_bdev and resulting mess just for a slightly
> different error message is just insane.

Hi Christoph,

When you mentioned "whole chunk of code", do you mean the following
block of code ?


1960         if (IS_ERR(bdev)) {
========= start of whole chunk of code ============
1961                 if (bdev == ERR_PTR(-EBUSY)) {
1962                         bdev = lookup_bdev(strim(path));
1963                         mutex_lock(&bch_register_lock);
1964                         if (!IS_ERR(bdev) && bch_is_open(bdev))
1965                                 err = "device already registered";
1966                         else
1967                                 err = "device busy";
1968                         mutex_unlock(&bch_register_lock);
1969                         if (!IS_ERR(bdev))
1970                                 bdput(bdev);
1971                         if (attr == &ksysfs_register_quiet)
1972                                 goto out;
1973                 }
========= end of whole chunk of code ============
1974                 goto err;
1975         }

I don't mind to remove it, just double check I don't misunderstand what
you meant.

Thanks.


-- 
Coly Li
