From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Working bcache patchset?
Date: Mon, 11 Jun 2012 03:31:34 -0700
Message-ID: <20120611103134.GA23066@moria.home.lan>
References: <18d9ec0eee7d5cee38ced035d38a7a23@modelnine.org>
 <20120611103036.GA32260@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120611103036.GA32260-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 11, 2012 at 03:30:46AM -0700, Kent Overstreet wrote:
> On Fri, Jun 08, 2012 at 12:40:31PM +0200, Heiko Wundram wrote:
> > Hey!
> > 
> > I'm currently evaluating bcache for a pet project of mine (seeing
> > the great performance numbers in the hosting environment tests
> > posted here really sold me on to the idea), but I'm currently
> > stumped by the bcache HEAD repository state (bcache on a 3.4.0+)
> > from http://evilpiepirate.org/cgi-bin/cgit.cgi/linux-bcache.git,
> > which does compile fine (but only if you don't activate CGROUP
> > support for bcache, that is broken, and the "simple" naming fixes
> > for struct bcache_group I tested don't allow it to compile
> > either...), but:
> 
> Yeah, the block cgroup stuff changed and I've been meaning to ask Tejun
> the best way to do that now since he's been working on that stuff.
> 
> > 
> > * the current head implements a (slightly) different kind of
> > sysfs-API than is documented (concerning cache_mode, the "writeback"
> > flag doesn't exist anymore), which is self-documenting mostly, at
> > least from what I gather,
> 
> The documentation is perpetually out of date.
> 
> > * and secondly, it's easy to lose a volume completely by simply
> > setting a backing volume to writeback caching mode. Detaching the
> > cache from a working writeback volume doesn't work at all (gives no
> > dmesg output, does not seem to start the flush), stopping the
> > backing volume does work, reattaching the cache device after
> > registering the backing device again is impossible: "bcache:
> > Couldn't find uuid for md127 in set",
> > * and thirdly, setting readahead to anything else than zero makes
> > bcache access blocks behind the end of device (the backing device
> > isn't a multiple of the readahead size I tested): "md127: rw=0,
> > want=5816029416, limit=5816028912"
> 
> Thanks for the bug reports - you weren't the only one who noticed
> writeback issues, I spent the weekend chasing down bugs and I should
> have new code up soon.
> 
> I think I've probably got all the writeback issues sorted out now - the
> one that was affecting you was a bug where background writeback wasn't
> marking anything as clean, so it'd never finish. When you try to detach
> a device with dirty data, the detach is supposed to finish as soon as
> all the dirty data is flushed.
> 
> The reregister after you stop was probably because when you detached, it
> marked the superblock as detached... but that shouldn't happen until
> after the dirty data is flushed, so there might be a bug there. Were you
> unable to reattach, or was that just not reattaching automatically?
> 
> > 
> > As people have had success with bcache from what I gather: is there
> > any working revision/patch I can up/downgrade to? ;-) All other tags
> > published on the mentioned gitweb don't seem to be versions which
> > could be used pseudo-productively, and cloning from the published
> > repository git://evilpiepirate.org/~kent/linux-bcache.git currently
> > fails:
> 
> Unfortunately no, the old well tested stuff is for older internel
> kernels (and it's now very old) and the stuff for upstream kernels has
> been in quite a state of flux since I've been finally trying to push it
> upstream.
> 
> But I've been devoting more time to the public branches lately, so I
> ought to have the last of these issues sorted out soon.
> 
> > 
> > modelnine # git clone git://evilpiepirate.org/~kent/linux-bcache.git
> > Cloning into 'linux-bcache'...
> > remote: Counting objects: 2441832, done.
> > remote: aborting due to possible repository corruption on the remote
> > side.
> > fatal: early EOF
> > fatal: index-pack failed
> > modelnine #
> 
> That's the server side OOMing. I eventually gave up trying to get it to
> work consistently. The workaround is to clone from a different repo and
> add it as a remote and then fetch.
> 
> > 
> > Scrolling through the repository state published by web didn't
> > immediately hint at a previous tag/state in the repository that
> > would be usable. Thanks for any hints!
> > 
> > -- 
> > --- Heiko.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
