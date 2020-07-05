From: Coly Li <colyli@suse.de>
Subject: Re: Input requirement for persistent configuration items in bcache
Date: Sun, 5 Jul 2020 18:23:09 +0800
Message-ID: <7764e570-e7d7-052a-5a0d-ac028454ab88@suse.de>
References: <0fe47cd9-ffa0-b440-44ca-6ed9419dfb01@suse.de>
 <20200705091214.GL14425@xoff>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgGEKXO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 06:23:14 -0400
In-Reply-To: <20200705091214.GL14425@xoff>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthias Ferdinand <bcache@mfedv.net>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 2020/7/5 17:12, Matthias Ferdinand wrote:
> On Sun, Jul 05, 2020 at 12:45:41PM +0800, Coly Li wrote:
>> While I am thinking about this, I do appreciate your help about the
>> input on which configuration item should be stored in the on-disk
>> superblock.
> 
> Hi,


Hi Matthias,

Thank you for the input.

> 
> my use case is rather limited, all my bcache devices run in writeback
> mode, and the only parameters I keep playing with are writeback_percent
> and sequential_cutoff.
> 
> My short list of favourites:
> 
>    - cache_mode
>    - writeback_percent
>    - sequential_cutoff
> 

Yes I plan to define a very limited minimum configuration set. And
rested should be configured via user space tool.

> But I vaguely remember that I used rebooting as last resort after too
> much fiddling with tunables; persisting them in the superblock means
> losing this reset-to-defaults method. Would be nice to have some other
> way of resetting.
> 
> An alternative to modifying the superblock might be something
> more out-of-band like iptables does with iptables-save and
> iptables-restore: convert current settings to text, e.g. on shutdown or
> at regular intervals, and restore settings on boot from this text file.

Yeah, I think in the same way as yours.

Coly Li
