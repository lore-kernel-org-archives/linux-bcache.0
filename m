From: Tim Small <tim@buttersideup.com>
Subject: Re: bcache gets stuck flushing writeback cache when used in
 combination with LUKS/dm-crypt and non-default bucket size
Date: Sun, 15 May 2016 10:08:41 +0100
Message-ID: <57383C99.6090206@buttersideup.com>
References: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com>
 <alpine.LRH.2.11.1605101816240.22680@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.251.4]:34193 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbcEOJqU (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 May 2016 05:46:20 -0400
In-Reply-To: <alpine.LRH.2.11.1605101816240.22680@mx.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, James Johnston <johnstonj.public@codenest.com>
Cc: linux-bcache@vger.kernel.org

Hello,

I've just hit the same bug in production, as it happens on a similar config:

. 4.5.1 (Debian backports kernel)
. bcache with 2M bucket (Intel DC S3500), with dm-crypt layered on top
of the backing device (4x 8TB RAID5).

I'm reducing the cc list, as I think this is bcache specific.

On 11/05/16 02:38, Eric Wheeler wrote:

> You might try LUKS atop of bcache instead of under it.  This might be 
> better for privacy too, otherwise your cached data is unencrypted.

I chose the same config as James, because the SSD has hardware
encryption (whereas the hard drives don't), and it'd be nice if cache
reads didn't get the extra CPU overhead/latency since the workload is
read-heavy, and cache hit should be pretty high (and the CPU doesn't
have AES-NI).

>> # Make cache set on second drive
>> # IMPORTANT:  Problem does not occur if I omit --bucket parameter.
>> make-bcache --bucket 2M -C /dev/sdb
> 
> 2MB is quite large, maybe it exceeds the 256-bvec limit.

In my case I followed the instructions in the make-bcache manual page
which say:

"The bucket size is intended to be equal to the size of your SSD's erase
blocks"

A bit of research suggested an erase block size of either 2M or 4M for
the SSD I was using.  Is this manual page incorrect?

> Ming Lei's patch got in to 4.6 yet, but try this:
>   https://lkml.org/lkml/2016/4/5/1046
> 
> and maybe Shaohua Li's patch too:
>   http://www.spinics.net/lists/raid/msg51830.html

I'll give them both a go...

Perhaps there should probably be a bcache wiki hosted on kernel.org to
cover this sort of stuff, as the bcache docs seem to be a bit lacking
currently?

Tim.
