From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache hangs on writes, recovers after disabling discard on
 cache device
Date: Fri, 26 Jul 2013 13:13:25 -0700
Message-ID: <20130726201325.GA6017@kmo-pixel>
References: <51C891C9.4060809@modelnine.org>
 <alpine.DEB.2.02.1307111748130.26927@orbit.lan>
 <20130712011554.GA17799@kmo-pixel>
 <alpine.DEB.2.02.1307121902540.10602@orbit.lan>
 <alpine.DEB.2.02.1307162111590.3617@orbit.lan>
 <20130716210527.GC27000@kmo-pixel>
 <alpine.DEB.2.02.1307181458180.18577@orbit.lan>
 <20130718175309.GB4848@kmo-pixel>
 <alpine.DEB.2.02.1307262143200.22718@orbit.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307262143200.22718-pfGh9vBu50j/PtFMR13I2A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Juha Aatrokoski <jha-6fQLAAUwtFMxHbG02/KK1g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Jul 26, 2013 at 09:44:32PM +0300, Juha Aatrokoski wrote:
> On Thu, 18 Jul 2013, Kent Overstreet wrote:
> >Oh man, thanks for pointing me at that code. This looks like a brown
> >paper bag bug...
> >
> >Try this patch and tell me what happens:
> 
> Uptime now seven days without encountering the bug. Previously it
> didn't take more than four days to trigger, so looking good (so
> far).

Great! I'll send the fix out for 3.11 and 3.10.
