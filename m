From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache-tools: minor change for bcache-register
Date: Mon, 26 Aug 2013 14:48:48 -0700
Message-ID: <20130826214848.GC2798@kmo-pixel>
References: <521B1C5E.2090007@rolffokkens.nl>
 <20130826161758.GA4780@blackbox.djwong.org>
 <kvfvst$j12$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <kvfvst$j12$2@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Aug 26, 2013 at 04:31:25PM +0000, Gabriel de Perthuis wrote:
> On Mon, 26 Aug 2013 09:17:58 -0700, Darrick J. Wong wrote:
> > On Mon, Aug 26, 2013 at 11:14:06AM +0200, Rolf Fokkens wrote:
> >> /sys/fs/bcache/register 2>/dev/null
> >> 
> >> I can imagine there's a more elegant solution, suggestions are welcome.
> > 
> > /sys/fs/bcache/register_quiet
> 
> Good point: the messages come from the kernel.
> 
> register_quiet would make legitimate errors harder to debug however.
> 
> I'll just send a patch to change "device already registered"
> to a low-priority pr_debug message rather than something that
> looks like an error.

register_quiet isn't supposed to suppress legit errors - if it does
that's a bug
