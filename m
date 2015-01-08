From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Wed, 7 Jan 2015 18:30:54 -0800
Message-ID: <20150108023054.GB1263@kmo-pixel>
References: <20141228023534.GA25860@cuci.nl>
 <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
 <54A81B78.2070409@rolffokkens.nl>
 <20150104004621.GA4460@kmo-pixel>
 <54A94A1C.9050906@rolffokkens.nl>
 <CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
 <54AC5F22.6040200@rolffokkens.nl>
 <alpine.DEB.2.02.1501071214210.19734@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:41985 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbbAHC2e (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 7 Jan 2015 21:28:34 -0500
Received: by mail-qg0-f43.google.com with SMTP id z107so402055qgd.2
        for <linux-bcache@vger.kernel.org>; Wed, 07 Jan 2015 18:28:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501071214210.19734@ware.dreamhost.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Rolf Fokkens <rolf@rolffokkens.nl>, Slava Pestov <sp@datera.io>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On Wed, Jan 07, 2015 at 12:17:19PM -0800, Eric Wheeler wrote:
> On Tue, 6 Jan 2015, Rolf Fokkens wrote:
> 
> > On 01/05/2015 08:47 AM, Slava Pestov wrote:
> > > The plan is to incrementally backport bug fixes and optimizations from
> > > bcache-dev to upstream for the foreseeable future.
> > As an ethousiastic bcache user myself I would be very happy if there's a
> > transition plan! :-)
> 
> Would it make sense to call this bcache2 and merge both into the linux 
> tree once bcache2 is stable enough for broader testing?

Yeah that might be what happens.

> To the extent possible, you could reuse common code paths and simplify the 
> backporting of bug fixes into the existing stable branch.

Code reuse is problematic because struct bkey itself changes, a lot of the code
that's factored out as a library now depends on the specific layout of struct
bkey :/

Gonna try and backport as much as possible that doesn't require changing the on
disk format when I have time, though.
