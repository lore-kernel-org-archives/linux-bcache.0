From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache: Fix a writeback performance regression
Date: Wed, 21 Aug 2013 16:47:15 -0700
Message-ID: <20130821234715.GA4630@moria.home.lan>
References: <20130814225904.GA6427@kmo-pixel>
 <520C788A.1060208@profihost.ag>
 <520DFAB4.1050402@profihost.ag>
 <52114614.4070509@profihost.ag>
 <20130819222718.GA32104@kmo-pixel>
 <52132243.8050803@profihost.ag>
 <521323D1.1070503@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <521323D1.1070503-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Aug 20, 2013 at 10:07:45AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 20.08.2013 10:01, schrieb Stefan Priebe - Profihost AG:
> > Am 20.08.2013 00:27, schrieb Kent Overstreet:
> >> On Mon, Aug 19, 2013 at 12:09:24AM +0200, Stefan Priebe wrote:
> >>>
> >>> Vanilla 3.10.7 + bcache: Fix a writeback performance regression
> >>>
> >>> http://pastebin.com/raw.php?i=LXZk4cMH
> >>
> >> Whoops, at first I thought this was the same bug as one I'd already been
> >> chasing down that had been a harmless bug - turns out I didn't look
> >> closely enough at the backtrace.
> >>
> >> What happened is background writeback is deadlocking, because for some
> >> reason the workqueue it's running out of is a singlethreaded workqueue,
> >> so as soon as it decides to queue enough writeback bios that it has to
> >> sleep on that semaphore (which often won't happen due to the PD
> >> controller based ratelimiting) - boom, deadlock.
> >>
> >> Here's the fixup patch I just tested and am applying:
> 
> Oh i'm now seeing very high CPU spikes of kworker... i don't see if i
> remove bcache: Fix a writeback performance regression.

Are you able to reproduce it? I'm not having any luck reproducing it...
