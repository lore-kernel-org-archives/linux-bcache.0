From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Sat, 3 Jan 2015 16:46:21 -0800
Message-ID: <20150104004621.GA4460@kmo-pixel>
References: <20141228023534.GA25860@cuci.nl>
 <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
 <54A81B78.2070409@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49476 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbADAnu (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 3 Jan 2015 19:43:50 -0500
Received: by mail-pd0-f173.google.com with SMTP id ft15so25739193pdb.4
        for <linux-bcache@vger.kernel.org>; Sat, 03 Jan 2015 16:43:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <54A81B78.2070409@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: Slava Pestov <sp@datera.io>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On Sat, Jan 03, 2015 at 05:40:24PM +0100, Rolf Fokkens wrote:
> Hi Slava,
> 
> Sounds like the kernel (using bcache-dev) is not able to handle the current
> format. If so, bcache-tools may help in "reformatting" bcache devices, but
> that's no solution for existing systems.
> 
> So is my understanding correct that there's no easy kernel upgrade path (to
> bcache-dev) ?

Yes, correct. The on disk format changes in bcache-dev are just too deep to
feasibly write backwards compat code, unfortunately.

And the on disk format is still in flux - for just a bit longer hopefully
though, right now I'm working on a pretty major revamp that's getting close to
done (self describing and packed metadata). This revamp is making the on disk
format _much_ more flexible though, and cleaning up a lot of stuff at the same
time.
