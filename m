From: Thomas Stein <himbeere@meine-oma.de>
Subject: Re: Is bcache dead?
Date: Thu, 30 Oct 2014 16:58:39 +0100
Message-ID: <1566381.UjjCVndWKb@rather>
References: <545229F8.8000502@profihost.ag> <CALJ65zkZLYdvLL9eaWzZCsJ0z87LWacKHXiMnMdYZxixPHu64A@mail.gmail.com> <545248CE.60202@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from meine-oma.de ([37.120.161.46]:39792 "EHLO meine-oma.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491AbaJ3QRL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 30 Oct 2014 12:17:11 -0400
Received: from port-92-195-62-115.dynamic.qsc.de ([92.195.62.115] helo=rather.localnet)
	by meine-oma.de with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.84)
	(envelope-from <himbeere@meine-oma.de>)
	id 1Xjt3B-0004gT-CB
	for linux-bcache@vger.kernel.org; Thu, 30 Oct 2014 17:58:17 +0100
In-Reply-To: <545248CE.60202@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Thursday 30 October 2014 15:18:54 Stefan Priebe - Profihost AG wrote:
> Am 30.10.2014 um 15:15 schrieb Kent Overstreet:
> > since 3.15!? shit, I don't think I saw any reports until 3.17 came out...
> 
> maybe i'm wrong. Can't guarantee but i already saw it on 3.16.X too.

We should not forget the "load average not falling bellow 1" bug which is 
still present in 3.17.1.

cheers
t.

> > On Thu, Oct 30, 2014 at 7:14 AM, Stefan Priebe - Profihost AG
> > 
> > <s.priebe@profihost.ag> wrote:
> >> Am 30.10.2014 um 15:09 schrieb Vasiliy Tolstov:
> >>> 2014-10-30 15:07 GMT+03:00 Stefan Priebe - Profihost AG 
<s.priebe@profihost.ag>:
> >>>> Hi,
> >>>> 
> >>>> this might be a bit aggressive - sorry for that.
> >>>> 
> >>>> There are a lot of people having deadlocks with bcache_gc and there's
> >>>> no
> >>>> dev looking into this since month.
> >>> 
> >>> As i understand devs provide patches only to next versions of linux.
> >>> Now i'm look at dm-cache.... (with lvm frontend lvmcache)
> >> 
> >> no problem but this bug exists since 3.15 and is not fixed in 3.18-rc..
> >> 
> >> Stefan
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
