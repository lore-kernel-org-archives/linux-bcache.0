From: Coly Li <i@coly.li>
Subject: Re: [PATCH 01/19] bcache: Fix leak of bdev reference
Date: Wed, 6 Sep 2017 13:25:10 +0800
Message-ID: <14051b81-4184-8efa-6e90-74693e2dd18d@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <20170705182447.GA10673@infradead.org>
 <e9019647-62b5-1c14-8b2f-66528b972b5c@coly.li>
 <20170905064348.GA23716@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:60682 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbdIFFZZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Sep 2017 01:25:25 -0400
In-Reply-To: <20170905064348.GA23716@infradead.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, axboe@kernel.dk, Jan Kara <jack@suse.cz>

On 2017/9/5 下午2:43, Christoph Hellwig wrote:
> On Tue, Sep 05, 2017 at 01:30:04AM +0800, Coly Li wrote:
>>
>> When you mentioned "whole chunk of code", do you mean the following
>> block of code ?
>>
>>
>> 1960         if (IS_ERR(bdev)) {
>> ========= start of whole chunk of code ============
>> 1961                 if (bdev == ERR_PTR(-EBUSY)) {
>> 1962                         bdev = lookup_bdev(strim(path));
>> 1963                         mutex_lock(&bch_register_lock);
>> 1964                         if (!IS_ERR(bdev) && bch_is_open(bdev))
>> 1965                                 err = "device already registered";
>> 1966                         else
>> 1967                                 err = "device busy";
>> 1968                         mutex_unlock(&bch_register_lock);
>> 1969                         if (!IS_ERR(bdev))
>> 1970                                 bdput(bdev);
>> 1971                         if (attr == &ksysfs_register_quiet)
>> 1972                                 goto out;
>> 1973                 }
>> ========= end of whole chunk of code ============
>> 1974                 goto err;
>> 1975         }
>>
>> I don't mind to remove it, just double check I don't misunderstand what
>> you meant.
> 
> Yes, that's the problematic block.
> 
Hi Christoph,

I tested the code, and my patch which removes the above code. The result
is, I feel the above chunk of code is useful. When I tried to register a
device and it was already registered. Without the above code, I only saw
"failed to open device", didn't realize it was because this device is
registered already. After adding the above code back, I knew where the
problem was.

The above chunk of code improves user experience and provides more
detailed diagnose information, it is useful. Then I suggest to keep the
code here and pick up Jan's patch.

Thanks.

-- 
Coly Li
