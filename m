From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Mon, 28 Nov 2011 22:31:26 -0800
Message-ID: <20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
 <4ED47771.9030309@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ED47771.9030309-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Nov 29, 2011 at 02:10:57PM +0800, Brad Campbell wrote:
> On 21/11/11 18:14, Kent Overstreet wrote:
> >I just pushed a new version, and it's only been lightly tested but
> >assuming I haven't screwed anything up it should work on
> >md/dm/rados/iscsi/etc. block devices.
> >
> 
> Great stuff! A couple of nitpicks while I get things set up to run
> some tests..
> 
> Documentation/bcache.txt states :
> <--------->
> To register your bcache devices automatically, you could add something like
> this to an init script:
>   echo /dev/sd* > /sys/fs/bcache/register_quiet
> 
> It'll look for bcache superblocks and ignore everything that doesn't
> have one.
> <--------->
> 
> However this never works for me. It bombs out on the first passed parameter
> 
> root@test:~/bin# echo /dev/sd* /dev/md* > /sys/fs/bcache/register_quiet
> bash: echo: write error: Invalid argument

Whoops, good catch - yeah, the documentation is completely wrong. Fixing
it now.

> I need to use this :
> for i in /dev/sd? /dev/md* ; do [ -n "`/sbin/probe-bcache $i`" ] &&
> echo $i > /sys/fs/bcache/register_quiet ; done
> 
> Now, it does not actually need the test in there, however that stops
> it spewing "write error: Invalid argument" onto the console when you
> echo a device that does not have a bcache superblock.
> 
> It does NOT like you accidentally trying to register a device twice :

Eesh. That's annoying.

I suppose really the bcache symlink in the /sys/block/bcacheN directory
is incorrect - without that stacking _ought_ to work and I'm not sure
it's possible to reliably detect stacking anyways.

Very annoying though - that symlink is very handy. Argh.

hm. maybe I could check the make_request_fn to detect stacking and
prevent it that way... 

No other issues, I take it?
