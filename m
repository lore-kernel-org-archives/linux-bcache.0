From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: speed up dirty data cleaning
Date: Thu, 7 Nov 2013 18:49:04 -0800
Message-ID: <20131108024904.GL3842@kmo>
References: <527B90EF.10404@profihost.ag>
 <527BAF4B.9080609@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <527BAF4B.9080609-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, Nov 07, 2013 at 04:18:35PM +0100, Stefan Priebe - Profihost AG wrote:
> After some time it seems to start writing out all the data at a good
> disk speed.
> 
> But how does bcache determine when to write which kind of data out of
> bcache.

There's a PD controller that tries to keep the amount of dirty data at
writeback_percent percentage of your cache size. But, since the dirty data
account was _still_ broken, that would screw up that PD controller.

Workaround is to set writeback_percent to 0
