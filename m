From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
Date: Mon, 9 Dec 2019 17:52:45 +0800
Message-ID: <dc01bf2c-4457-9658-c0a3-cbd4b7eff82b@suse.de>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
 <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
 <20191209073744.GB3852@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191209073744.GB3852@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Liang Chen <liangchen.linux@gmail.com>, kent.overstreet@gmail.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/12/9 3:37 下午, Christoph Hellwig wrote:
> On Fri, Dec 06, 2019 at 05:44:38PM +0800, Coly Li wrote:
>>>  {
>>> -	struct cache_sb *out = page_address(bio_first_page_all(bio));
>>> +	struct cache_sb *out;
>>>  	unsigned int i;
>>> +	struct buffer_head *bh;
>>> +
>>> +	/*
>>> +	 * The page is held since read_super, this __bread * should not
>>> +	 * cause an extra io read.
>>> +	 */
>>> +	bh = __bread(bdev, 1, SB_SIZE);
>>> +	if (!bh)
>>> +		goto out_bh;
>>> +
>>> +	out = (struct cache_sb *) bh->b_data;
>>
>> This is quite tricky here. Could you please to move this code piece into
>> an inline function and add code comments to explain why a read is
>> necessary for a write.
> 
> A read is not nessecary.  He only added it because he was too fearful
> of calculating the data offset directly.  But calculating it directly
> is almost trivial and should just be done here.  Alternatively if that
> is still to hard just keep a pointer to the cache_sb around, which is
> how most file systems do it.
> 
Copied, if Liang does not have time to handle this as your suggestion, I
will handle it.

Thanks for the hint.

-- 

Coly Li
