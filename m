From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: running iozone on bcache0 device yields wrongly read data
Date: Wed, 18 Sep 2013 01:48:35 -0700
Message-ID: <20130918084835.GA19161@kmo-pixel>
References: <5238AAE5.8000800@aei.mpg.de>
 <20130917204059.GB32037@kmo-pixel>
 <52392D4D.3020506@aei.mpg.de>
 <20130918044551.GD32386@kmo-pixel>
 <52394B5C.8000106@aei.mpg.de>
 <523967C8.7010502@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <523967C8.7010502-l1a6w7hxd2yELgA04lAiVw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carsten Aulbert <Carsten.Aulbert-l1a6w7hxd2yELgA04lAiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Sep 18, 2013 at 10:43:52AM +0200, Carsten Aulbert wrote:
> Hi again (sorry for the amount of small emails)
> 
> On 09/18/2013 08:42 AM, Carsten Aulbert wrote:
> >> Writeback or writethrough?
> 
> > Sorry, writeback as this testing is aimed for high performance scratch
> > space.
> > 
> 
> Just  tested, the same happens with writethrough

Oh, damn. Can you check 3.10.9 and 3.10.10?
