From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v1 03/10] bcache: reduce cache_set devices iteration by
 devices_max_used
Date: Wed, 3 Jan 2018 09:11:50 -0800
Message-ID: <0aa286c4-6eb7-213c-8b74-414b4dc90506@lyle.org>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-4-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180103140325.63175-4-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

On 01/03/2018 06:03 AM, Coly Li wrote:
> Member devices of struct cache_set is used to reference all attached
> bcache devices to this cache set. If it is treated as array of pointers,
> size of devices[] is indicated by member nr_uuids of struct cache_set.
> 
> nr_uuids is calculated in drivers/md/super.c:bch_cache_set_alloc(),
> 	bucket_bytes(c) / sizeof(struct uuid_entry)
> Bucket size is determined by user space tool "make-bcache", by default it
> is 1024 sectors (defined in bcache-tools/make-bcache.c:main()). So default
> nr_uuids value is 4096 from the above calculation.
> 
> Every time when bcache code iterates bcache devices of a cache set, all
> the 4096 pointers are checked even only 1 bcache device is attached to the
> cache set, that's a wast of time and unncessary.
> 
> This patch adds a member devices_max_used to struct cache_set. Its value
> is 1 + the maximum used index of devices[] in a cache set. When iterating
> all valid bcache devices of a cache set, use c->devices_max_used in
> for-loop may reduce a lot of useless checking.
> 
> Personally, my motivation of this patch is not for performance, I use it
> in bcache debugging, which helps me to narrow down the scape to check
> valid bcached devices of a cache set.

Oh, OK.  I was going to argue that I didn't think this was worth it, but
I can see how it would be nice for inspecting memory and debug code.

> 
> Signed-off-by: Coly Li <colyli@suse.de>

Reviewed-by: Michael Lyle <mlyle@lyle.org>
