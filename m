From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Mon, 5 Jan 2015 03:06:02 -0800
Message-ID: <20150105110602.GA31622@kmo-pixel>
References: <20141228023534.GA25860@cuci.nl>
 <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
 <54A81B78.2070409@rolffokkens.nl>
 <20150104004621.GA4460@kmo-pixel>
 <20150105084919.GA11249@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60551 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbbAELDa (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 5 Jan 2015 06:03:30 -0500
Received: by mail-pa0-f51.google.com with SMTP id ey11so28533741pad.38
        for <linux-bcache@vger.kernel.org>; Mon, 05 Jan 2015 03:03:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20150105084919.GA11249@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: linux-bcache@vger.kernel.org

On Mon, Jan 05, 2015 at 09:49:19AM +0100, Stephen R. van den Berg wrote:
> Kent Overstreet wrote:
> >Yes, correct. The on disk format changes in bcache-dev are just too deep to
> >feasibly write backwards compat code, unfortunately.
> 
> >And the on disk format is still in flux - for just a bit longer hopefully
> >though, right now I'm working on a pretty major revamp that's getting close to
> 
> Any chance we could get a git url of the bcache-tools-in-flux as well?

Yeah, I just pushed the current (very much WIP) stuff to the bcache-dev branch
under the main bcache-tools repo
