From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Mon, 28 Nov 2011 23:54:40 -0800
Message-ID: <20111129075440.GB14194@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
 <4ED47771.9030309@fnarfbargle.com>
 <20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com>
 <4ED48A64.4080406@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ED48A64.4080406-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Nov 29, 2011 at 03:31:48PM +0800, Brad Campbell wrote:
> I'm not sure that stacking is the issue. I simply did
> 
> echo /dev/md10 > /sys/fs/bcache/register
> echo /dev/md10 > /sys/fs/bcache/register
> 
> at that point it all came crashing down. I'd have thought simply
> detecting that a particular device was already registered would
> solve the problem.

Ok, that's weird. It shouldn't be able to register the second time
because the first register opens it exclusively, and the second open
will fail with -EBUSY.

> Well, I had intended to run some tests with it stacked on top of md,
> but as I pointed out in the last oops in my prior mail, every time I
> try and attach the cache set to /dev/md10 the machine panics, so
> I've not really progressed to actually trying things out. I figured
> re-running the tests I'd already run with it stacked on a single
> drive was pretty pointless.

Bah, I suck at reading comprehension tonight, didn't see the second
oops.

That one looks strange, I haven't seen an oops there before. Which raid
type are you using, and which driver? Hopefully it's related to the raid
type and not the driver...
