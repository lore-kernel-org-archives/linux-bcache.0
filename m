From: Coly Li <i@coly.li>
Subject: Re: [PATCH 2/2] bcache: fix calling ida_simple_remove()
 withincorrectminor
Date: Mon, 8 May 2017 23:23:44 +0800
Message-ID: <4dc24094-079b-9cac-a0aa-d46b1e00861a@coly.li>
References: <201705081444060852029@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:56960 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755269AbdEHPXy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 May 2017 11:23:54 -0400
In-Reply-To: <201705081444060852029@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2017/5/8 下午2:44, tang.junhui@zte.com.cn wrote:
> Hello Coly,
> 
> 
> ＞ I mean if there are partitions on bcache devices, like
> 
> ＞ /dev/bcache0p1, /dev/bcache0p2 ... /dev/bcache0p16
> 
> ＞ /dev/bcache1p1, /dev/bcache1p2 ... /dev/bcache0p16
> 
> ＞ 
> 
> ＞ 
> 
> ＞ bcache0 is not the last level to allocate minor number, bcache0p1 is.
> 
> ＞ What we should fix might be:
> 
> ＞ /dev/bcache0 has minor 0
> 
> ＞ /dev/bcache1 has minor 16
> 
> ＞ /dev/bcache2 has minor 32
> 
> 
> My patch does not break this. Please review the patch again.

I think I come to understand you, yes your fix makes sense.

In your patch d->disk->first_minor is assigned by
IDA_TO_BCACHE_MINORS(minor), which left-shifts minor by 4 bits. So your
patch will introduce a potential overflow for device minor number.

MINORMASK is 20 bits, if you call ida_simple_get() like this,

minor = ida_simple_get(&bcache_minor, 0, BCACHE_TO_IDA_MONIRS(MINORMASK
+ 1), GFP_KERNEL);

The overflow should be removed.

I have no more concern about your patch. Nice catch, thank you !

-- 
Coly Li
