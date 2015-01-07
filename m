From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Wed, 7 Jan 2015 12:17:19 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1501071214210.19734@ware.dreamhost.com>
References: <20141228023534.GA25860@cuci.nl> <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com> <54A81B78.2070409@rolffokkens.nl> <20150104004621.GA4460@kmo-pixel> <54A94A1C.9050906@rolffokkens.nl> <CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
 <54AC5F22.6040200@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:53637 "EHLO
	homiemail-a9.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbbAGURV (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 7 Jan 2015 15:17:21 -0500
In-Reply-To: <54AC5F22.6040200@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: Slava Pestov <sp@datera.io>, Kent Overstreet <kmo@daterainc.com>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On Tue, 6 Jan 2015, Rolf Fokkens wrote:

> On 01/05/2015 08:47 AM, Slava Pestov wrote:
> > The plan is to incrementally backport bug fixes and optimizations from
> > bcache-dev to upstream for the foreseeable future.
> As an ethousiastic bcache user myself I would be very happy if there's a
> transition plan! :-)

Would it make sense to call this bcache2 and merge both into the linux 
tree once bcache2 is stable enough for broader testing?

To the extent possible, you could reuse common code paths and simplify the 
backporting of bug fixes into the existing stable branch.

-Eric
 
> Out of curiosity, will the backing device layout in general change, or will
> specifically the superblock change? If it's 'only' the superblock (and not
> it's size) I can imagine a feasable migration.
> 
> Rolf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
