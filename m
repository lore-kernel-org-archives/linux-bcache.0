From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: running iozone on bcache0 device yields wrongly read data
Date: Tue, 17 Sep 2013 13:40:59 -0700
Message-ID: <20130917204059.GB32037@kmo-pixel>
References: <5238AAE5.8000800@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5238AAE5.8000800-l1a6w7hxd2yELgA04lAiVw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carsten Aulbert <Carsten.Aulbert-l1a6w7hxd2yELgA04lAiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Sep 17, 2013 at 09:17:57PM +0200, Carsten Aulbert wrote:
> Hi all
> 
> I've spent some time on IRC today (thanks eegiks for input) but I fear
> the problem I encountered is not solved yet.
> 
> http://pastebin.com/t0di2MKi
> 
> has some kind of summary on which kind of machine I am running and what
> command lines switches I use for iozone. It seems I need to go at least
> to -s 1g to start triggering this issue (latest run output attached).
> 
> I've tried it with an almost vanilla 3.11.0 and a patched
> 3.11.1+bcache-for-3.11 kernel but both show this issue. A cross test on
> a similar host but only using an HDD did not show this issue.
> 
> Any clues/hints how to figure out if this is caused by the underlying
> hardware or if this is something internal to bcache? What else would you
> need as input? Shall I switch on debugging and what can I do to help you
> figure out what's wrong?

What's your setup? Are you running md, lvm? What filesystem?

I'm getting a couple bug reports, and I think I know what commit
introduced the regression but it seems to require something else
slightly unusual in the stack to trigger, so I'm trying to figure out
what the common factor is.
