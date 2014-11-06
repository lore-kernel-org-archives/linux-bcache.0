From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: Is bcache dead?
Date: Thu, 06 Nov 2014 23:12:39 +0100
Message-ID: <545BF257.6020708@rolffokkens.nl>
References: <545229F8.8000502@profihost.ag> <CALJ65zm0UpNKZKZmT26Gv6+CA6ijTS60+PVoCroLA4aipo-bPg@mail.gmail.com> <54529797.2020004@hardwarefreak.com> <20141030233425.GA28233@kmo-pixel> <545B8DDC.4070905@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62221 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKFWUi (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 6 Nov 2014 17:20:38 -0500
Received: by mail-wi0-f177.google.com with SMTP id ex7so2912505wid.4
        for <linux-bcache@vger.kernel.org>; Thu, 06 Nov 2014 14:20:36 -0800 (PST)
In-Reply-To: <545B8DDC.4070905@bahj.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Zachary Palmer <zep_kernel.org@bahj.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Another happy user experience: I started packaging bcache-tools for 
Fedora 20 summer 2013, just because I wanted to use bcache. After 
alligning bcache-tools with util-linux, Dracut and LVM2 (all these 
packages needed minor tweaks, that were all integrated upstream) I have 
been using bcache myself (of course). I've been living on the edge by 
using writeback caching and a cheap SSD, and it has all been working 
like a charm! Well, I've been living over the edge actually by 
attempting to enable TRIM - I blame the resulting corruptions on the 
cheap SSD. And I had occasional "bcache_writeback 100% CPU" issues, but 
those seem to be gone (currently kernel 3.16).

And searching for bcache at bugzilla.redhat.com: no bugs pop up. Could 
be that there are no bcache users at all, but I know for fact that 
that's not true.

So (when not using TRIM): excellent performance and stability. Thanks 
for the good work!

Rolf

On 11/06/2014 04:03 PM, Zachary Palmer wrote:
> If I can throw mine in as well, I've been running bcache on my Debian 
> Wheezy laptop for around a year now.  (I'm using the Debian backports 
> 3.12 kernel.)  When I first moved to bcache, I noticed that certain 
> operations -- interacting with Git repositories and building LaTeX 
> documents, for instance -- became much snappier. I'm using a feeble 
> little 32GB SSD that came with the laptop to cache a 1TB drive and I'm 
> even using writethrough caching (more out of paranoia about the 
> quality of my cheap little SSD than anything else), but it makes a 
> difference.
>
> Since then, it has been quietly humming along and I've stopped paying 
> attention to it.  And that's the beauty of a good tool like this: I 
> can stop paying attention to it.  I've enjoyed a year of better I/O 
> and, other than in the initial setup, I haven't paid anything in 
> maintenance burden: no instability, no hiccups, no unexplained hangs.  
> So for my part as an end user just trying to get a little edge out of 
> my laptop hardware, thank you!  I expect I'm speaking on behalf of 
> quite a few people when I say that you've made things better in a 
> subtle but significant way.  :)
>
> Cheers,
>
> Zach
