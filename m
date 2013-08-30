From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache hangs and calll trace
Date: Fri, 30 Aug 2013 14:18:07 -0700
Message-ID: <20130830211807.GB20307@kmo-pixel>
References: <521ED8E3.5010407@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <521ED8E3.5010407-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, Aug 29, 2013 at 07:15:15AM +0200, Stefan Priebe wrote:
> Hi,
> 
> i got this one today. I have a load aof 1200 after this.

It's not clear from the backtraces where it's getting stuck - can you
try the patch I just mailed out and see if that fixes it? The deadlock
that fixes it could be the cause here.
