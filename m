From: kent.overstreet@gmail.com
Subject: Re: how does the caching works in bcachefs
Date: Thu, 9 Jul 2020 12:08:05 -0400
Message-ID: <20200709160805.GA158619@zaphod.evilpiepirate.org>
References: <2308642.L3yuttUQlX@t460-skr>
 <20200708220220.GA109921@zaphod.evilpiepirate.org>
 <2900215.XKtEbqh0OK@t460-skr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgGIQIL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Jul 2020 12:08:11 -0400
Content-Disposition: inline
In-Reply-To: <2900215.XKtEbqh0OK@t460-skr>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan K <shadow_7@gmx.net>
Cc: linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org

On Thu, Jul 09, 2020 at 03:20:14PM +0200, Stefan K wrote:
> Hi and thanks!
> 
> > LRU, same as bcache.
> do you plan to change this , since LRU is not very efficient (in comparison to
> other), maybe 2Q or ARC[1-4]

No, but I'd be happy to help if someone else wanted to implement a new caching
algorithm :)

In real world mixed workloads LRU is fine, it's not that much of a difference
vs. the more sophisticated algorithms. More important is the stuff like
sequential_bypass or some other kind of knob to ensure your backup process
doesn't blow away the entire cache.

> 
> > [...]
> > And you can pin specific files/folders to a device, by setting foreground target
> > to that device and setting background target and promote target to nothing.
> ok thank you very much! That must be documented somewhere ;-)

I just write code, not documentation :)
