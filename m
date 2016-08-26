From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs]  mount: page allocation failure: order:7,
 mode:0x24000c0(GFP_KERNEL)  /   BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000008
Date: Thu, 25 Aug 2016 18:14:12 -0800
Message-ID: <20160826021412.laaxaokzrtf2kwkc@kmo-pixel>
References: <a8d0676a968c4901e94ab74be158c1e4@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36837 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbcHZCWZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 22:22:25 -0400
Received: by mail-pa0-f48.google.com with SMTP id di2so22235893pad.3
        for <linux-bcache@vger.kernel.org>; Thu, 25 Aug 2016 19:21:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <a8d0676a968c4901e94ab74be158c1e4@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Thu, Aug 25, 2016 at 07:16:41PM +0200, Marcin wrote:
> Hi again,
> I created tiered filesystem (tier 1 device has 1.4TB, tier 0 device has
> 10GB) but mounting failed (host has 1GB of RAM):

enable CONFIG_COMPACTION - I'm going to change bcache's kconfig to enable that
if bcache is enabled, this comes up too much.

though, I believe that's the mempool for compression workspaces, can probably
switch that to vmalloc.
