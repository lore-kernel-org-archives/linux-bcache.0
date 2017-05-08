From: Coly Li <i@coly.li>
Subject: Re: [PATCH 2/2] bcache: fix calling ida_simple_remove() withincorrect
 minor
Date: Mon, 8 May 2017 14:20:15 +0800
Message-ID: <1241af54-a3d7-58b9-fe55-b926c6956f56@coly.li>
References: <201705081248047779480@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:55660 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752674AbdEHGUn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 May 2017 02:20:43 -0400
In-Reply-To: <201705081248047779480@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2017/5/8 下午12:48, tang.junhui@zte.com.cn wrote:
> Hello Coly,
> 
> 
> ＞ Hi Junhui,
> 
> ＞ 
> 
> ＞ I think this is a design on purpose. Current multiple partitions bcache
> 
> ＞ design is per-device, not per major number, and each bcache devices as
> 
> ＞ 16 partitions at max.
> 
> ＞ 
> 
> ＞ This is why when you see a bcache device is initialized, the first minor
> 
> ＞ of the device will *BCACHE_MINORS.
> 
> ＞ 
> 
> ＞ Your patch won't make all minor numbers of the partitions of a bcache
> 
> ＞ device being continuous, IMHO this is not correct.
> 
> ＞ 
> 
> ＞ Thanks.
> 
> ＞ 
> 
> ＞ Coly
> 
> 
> We get minor number by ida_simple_get(), but the minor what we are going to
> 
> relase is minor*BCACHE_MINORS, so we release a wrong minor
> minor*BCACHE_MINORS, 
> 
> and the right minor number leakage occures.

I mean if there are partitions on bcache devices, like
/dev/bcache0p1, /dev/bcache0p2 ... /dev/bcache0p16
/dev/bcache1p1, /dev/bcache1p2 ... /dev/bcache0p16


bcache0 is not the last level to allocate minor number, bcache0p1 is.
What we should fix might be:
/dev/bcache0 has minor 0
/dev/bcache1 has minor 16
/dev/bcache2 has minor 32

Maybe I didn't understand you correctly. Can your patch make sure all
partitions of a bcache device have adjacent minor numbers ? Correct me
if I am wrong.


-- 
Coly Li
