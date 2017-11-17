From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bio: ensure __bio_clone_fast copies bi_partno
Date: Fri, 17 Nov 2017 08:27:40 -0700
Message-ID: <8f93b1dd-9909-a9be-28d1-a10e4f06bdd7@kernel.dk>
References: <20171117074725.22536-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171117074725.22536-1-mlyle@lyle.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 11/17/2017 12:47 AM, Michael Lyle wrote:
> A new field was introduced in 74d46992e0d9dee7f1f376de0d56d31614c8a17a,
> bi_partno, instead of using bdev->bd_contains and encoding the partition
> information in the bi_bdev field.  __bio_clone_fast was changed to copy
> the disk information, but not the partition information.  At minimum,
> this regressed bcache and caused data corruption.

That's not good... Fix looks good to me, I'll queue this up for a pull
today. Thanks for bisecting this, Michael.

-- 
Jens Axboe
