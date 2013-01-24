From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Adding caching to existing volumes?
Date: Thu, 24 Jan 2013 13:21:03 -0800
Message-ID: <20130124212103.GI26407@google.com>
References: <20130122231547.GF26407@google.com>
 <12410785.14.1358961464521.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <12410785.14.1358961464521.JavaMail.root@zimbra>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Haigh <netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 23, 2013 at 06:17:44PM +0100, Roy Sigurd Karlsbakk wrote:
> > You've got to start from scratch, unfortunately.
> > 
> > The reason is that there needs to be a bcache specific superblock on
> > the
> > backing device so bcache can keep the cache and backing device in sync
> > -
> > and especially so you can't accidentally mount and use the backing
> > device without the cache. That would be bad.
> > 
> > I just added an explanation to the faq - thanks for pointing it out.
> > http://bcache.evilpiepirate.org/FAQ
> 
> Then, what happens when the SSD dies?

Formatting a backing device for bcache is separate from attaching it to
a cache device - you can always run it in passthrough mode, and if the
SSD dies while it's in use it'll automatically/transparently detach and
switch to passthrough mode.
