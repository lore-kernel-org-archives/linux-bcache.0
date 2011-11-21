From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: New version up with fix for md and other block devices
Date: Mon, 21 Nov 2011 02:14:02 -0800
Message-ID: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I just pushed a new version, and it's only been lightly tested but
assuming I haven't screwed anything up it should work on
md/dm/rados/iscsi/etc. block devices.

I've only tested backing devices on raid devices; awhile back someone
ran into a bug when the cache device was a raid1. I'm not sure if it
ever got fixed, and it took awhile to reproduce - so if anyone feels
like testing it please let me know.

There were also a pair of very slow silent data corruption bugs found
and fixed a few weeks ago; I updated the public repository with the
fixes for those as soon as I had them but I was negligent in posting
about it. So, the new code's better and when we discovered those bugs we
added some more extensive verification code, I don't expect to find any
more corruption bugs (fingers crossed).

But anyways, if anyone runs into bugs with this version please let me
know. I know the documentation is horribly out of date, sorry about that
and hopefully I'll have time to work on that soon.

Hopefully I'll be able to post some real benchmarks soon too, it has
gotten phenomenally fast...
