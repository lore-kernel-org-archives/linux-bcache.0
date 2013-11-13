From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: RE: 3.10LTS ok for production?
Date: Tue, 12 Nov 2013 16:21:00 -0800
Message-ID: <08dd01cee006$3d6de180$b849a480$@acm.org>
References: <20131109030128.GJ5474@bender.unx.csupomona.edu> <20131109064721.GC30271@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131109064721.GC30271@kmo-pixel>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Kent Overstreet' <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> From: Kent Overstreet [mailto:kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org]
> Sent: Friday, November 08, 2013 10:47 PM
>
> Yes - 3.10 LTS (or 3.11) has been what you want to be running for awhile
> now; I've been making sure all the bugfixes get backported quickly.

Cool, thanks for the feedback. I ended up starting with a 3.11.7 kernel
after all, I'm going to play with that and see what happens. I'm looking
forward to the potential support for redundant cache devices within bcache
itself, so I won't have to mirror my two SSDs, but still have redundancy for
writeback and more overall space for read caching. Not sure what the
timeline is for that, but imagine it wouldn't be backported to 3.10.
