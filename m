From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] bcache: bch_open_as_blockdevs() register_cache_set err
 Bad checksum
Date: Fri, 9 Sep 2016 11:30:06 +0200
Message-ID: <281a2205-9a59-ac55-a5a8-7ebe66d52d03@mejor.pl>
References: <18fba014-c2d9-2685-cf6d-b1ee0de35bda@mejor.pl>
 <20160909091548.j5h4axfpghzznux2@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:34656 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752325AbcIIJa4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 05:30:56 -0400
In-Reply-To: <20160909091548.j5h4axfpghzznux2@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 09.09.2016 o 11:15, Kent Overstreet pisze:
> On Fri, Sep 09, 2016 at 09:36:59AM +0200, Marcin Mirosław wrote:
>> Hi!
>> Today I launched host at my job. When I tried to mount bcachefs I got:
>> bcache: bch_open_as_blockdevs() register_cache_set err Bad checksum
>>
>> This is simple, not tieres fs. I don't have idea what to do next to help
>> debug this. Data on this fs are completely unimportant.
> 
> The superblock checksum is bad (I'm going to improve that error message)... what
> in the heck...
> 
> Anything remotely unusual about the machine or how you were using it?


It's a desktop with KDE, I used this fs for keeping portage tree & i put
compilation tmp dir on it (with lz4 compression). Stack is:
lvm->raid10->4 x HDD


> Existing filesystem, right? Not freshly formatted?

Existing filesystem.

> The only thing I can really think of is there was a torn write while writing the
> superblock - if the power failed or the VM was killed partway through writing
> the superblock, that would cause it. Unfortunately we don't have backup
> superblocks yet... I suppose I should really get on that...

This is physical machine, I turned it off gracefully. Does image of
block device be usefull for you?

Thanks, Marcin
