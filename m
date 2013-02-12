From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache vs enhanceio?
Date: Tue, 12 Feb 2013 13:56:29 -0800
Message-ID: <20130212215629.GJ27179@google.com>
References: <5114334D.7040709@networklabs.co.nz>
 <23363144.24.1360701679980.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <23363144.24.1360701679980.JavaMail.root@zimbra>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>
Cc: Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Feb 12, 2013 at 09:41:20PM +0100, Roy Sigurd Karlsbakk wrote:
> Wouldn't it be better to allow the sysadmin to determine the safety?

The sysadmin can override, but - say you're using bcache for your root
filesystem and after a reboot the SSD doesn't come up, for whatever
reason.

How's the sysadmin supposed to know for sure whether there was dirty
data in the cache? There's no way to reliably track that without bcache
tracking it itself in the backing device's superblock.

Say there wasn't any dirty data in the cache, so you can safely run
without the cache device - so you do, so you can boot up and use your
machine.

Then later you figure out what's wrong with the SSD (cable got
unplugged?), so you reenable caching.

But the cache is now inconsistent - you _cannot_ use that cached data.
With the backing device superblock, bcache can trivially note that the
cache is out of sync and make sure that that cached data isn't used.

If we didn't have that, the sysadmin would have to make _sure_ to use
the right flag when reattaching to specify cached data shouldn't be
used, otherwise he just corrupted all his data.


> Also, if running in writethrough, why shouldn't an SSD be allowed to be added in realtime?

If you're running in writethrough, you'd already be caching... not sure
what you mean?

> All of this works well with systems like ZFS. I really don't see a reason for a filesystem being created to allow caching

ZFS is a filesystem that also does caching, bcache isn't a filesystem.
Did you get something backwards...?
