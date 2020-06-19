From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH][next] bcache: Use struct_size() in kzalloc()
Date: Fri, 19 Jun 2020 23:01:58 +0800
Message-ID: <dc039b66-5967-381b-ea84-b411b74578a4@suse.de>
References: <20200617222733.GA24156@embeddedor>
 <1c6adee3-bbad-dc88-3dd2-af823f279271@suse.de>
 <48589b2a3ec33a6504d23d166a32e7820d2e0b70.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390777AbgFSPCE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:04 -0400
In-Reply-To: <48589b2a3ec33a6504d23d166a32e7820d2e0b70.camel@perches.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Joe Perches <joe@perches.com>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>

On 2020/6/18 13:42, Joe Perches wrote:
> On Thu, 2020-06-18 at 13:38 +0800, Coly Li wrote:
>> On 2020/6/18 06:27, Gustavo A. R. Silva wrote:
>>> Make use of the struct_size() helper instead of an open-coded version
>>> in order to avoid any potential type mistakes.
> []
>>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> []
>>> -			io = kzalloc(sizeof(struct dirty_io) +
>>> -				     sizeof(struct bio_vec) *
>>> -				     DIV_ROUND_UP(KEY_SIZE(&w->key),
>>> -						  PAGE_SECTORS),
>>> +			io = kzalloc(struct_size(io, bio.bi_inline_vecs,
>>                                                      ^^^^^^^^^^^^^^^^^^
>>                                                      I like this :-)
>>
>>> +						DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
>>
>> The above line seems too long for 80 characters limitation. Does
>> checkpatch.pl complain for this ?
> 
> No.  checkpatch has changed:

OK, then this patch is good for me.

> 
> From bdc48fa11e46f867ea4d75fa59ee87a7f48be144 Mon Sep 17 00:00:00 2001
> From: Joe Perches <joe@perches.com>
> Date: Fri, 29 May 2020 16:12:21 -0700
> Subject: [PATCH] checkpatch/coding-style: deprecate 80-column warning
> 
> Yes, staying withing 80 columns is certainly still _preferred_.  But
> it's not the hard limit that the checkpatch warnings imply, and other
> concerns can most certainly dominate.
> 
> Increase the default limit to 100 characters.  Not because 100
> characters is some hard limit either, but that's certainly a "what are
> you doing" kind of value and less likely to be about the occasional
> slightly longer lines.
> 
> Miscellanea:
> 
>  - to avoid unnecessary whitespace changes in files, checkpatch will no
>    longer emit a warning about line length when scanning files unless
>    --strict is also used
> 
>  - Add a bit to coding-style about alignment to open parenthesis
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I see. My current monitor may display 4 terminal window with 85
characters width, expending the limit to 100 characters means I probably
have to change my current monitor with a good cause.

Thank you, for such good change.

Coly Li
