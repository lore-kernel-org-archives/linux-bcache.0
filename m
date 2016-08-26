From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] mount: page allocation failure: order:7,
 mode:0x24000c0(GFP_KERNEL) / BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000008
Date: Fri, 26 Aug 2016 10:05:36 +0200
Message-ID: <80a69355-55e3-f685-4cb6-8368ace1e36e@mejor.pl>
References: <a8d0676a968c4901e94ab74be158c1e4@mejor.pl>
 <20160826021412.laaxaokzrtf2kwkc@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:54141 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbcHZIF4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Aug 2016 04:05:56 -0400
In-Reply-To: <20160826021412.laaxaokzrtf2kwkc@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 26.08.2016 o 04:14, Kent Overstreet pisze:
> On Thu, Aug 25, 2016 at 07:16:41PM +0200, Marcin wrote:
>> Hi again,
>> I created tiered filesystem (tier 1 device has 1.4TB, tier 0 device has
>> 10GB) but mounting failed (host has 1GB of RAM):
> 
> enable CONFIG_COMPACTION - I'm going to change bcache's kconfig to enable that
> if bcache is enabled, this comes up too much.
> 
> though, I believe that's the mempool for compression workspaces, can probably
> switch that to vmalloc.

I saw thread "OOM regression in 4.7". I was thinking if it can be case
here but I have got COMPACTION turned on. And this situation occured
when most of ram was used by filesystem cache (but it wasn't dirty data).
