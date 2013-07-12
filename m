From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Negative stats value
Date: Fri, 12 Jul 2013 01:16:01 -0700
Message-ID: <20130712081601.GA8339@kmo-pixel>
References: <103FE78F-7B2E-4B2F-83E6-51D2DEE33BB3@profihost.ag>
 <20130712012841.GC17799@kmo-pixel>
 <4FAB0670-07BD-4E8F-AD0E-A4CA5572A7EC@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FAB0670-07BD-4E8F-AD0E-A4CA5572A7EC-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Fri, Jul 12, 2013 at 07:13:32AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 12.07.2013 um 03:28 schrieb Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>:
> 
> > On Thu, Jul 11, 2013 at 07:32:05AM +0200, Stefan Priebe - Profihost AG wrote:
> >> I've seen negative dirty cache values several times. Is there a fix available?
> > 
> > Yeah, this should be fixed in the bcache-for-3.11 branch - but it's
> > harmless in the meantime.
> 
> Any special fix I can apply on top of 3.10?

http://evilpiepirate.org/git/linux-bcache.git/commit/?h=bcache-for-3.11&id=444fc0b6b167ed164e7436621a9d095e042644dd
