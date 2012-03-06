From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache and dm targets (specifically lvm)
Date: Mon, 5 Mar 2012 23:03:48 -0800
Message-ID: <20120306070348.GA2601@dhcp-172-18-216-138.mtv.corp.google.com>
References: <CAOzFzEjKapphA5NKCWbEyx4nvjWw+e_dxr+fOLr8f5j586jiyA@mail.gmail.com>
 <CAOzFzEjffLGjYhOznTo1F3moHLq+nvKYZFoy7mkU-q8RPDd9oQ@mail.gmail.com>
 <CAC7rs0vpQAaF9uNhhy2ziLa+3EB6udJVRjGwf=RVoSk0TxuDcw@mail.gmail.com>
 <CAC7rs0us5Xqag_AWq=wsFYqn3Fub3qt59a9=vDeS5cLh2oOg0Q@mail.gmail.com>
 <CAOzFzEifqyFz2G=0OEPA9BN8-kU3MabUhGmU7-jSQCxwPcHrpw@mail.gmail.com>
 <CAH+dOx+eWJKvKz=HEGHaPu8tqqz2CqVjUC1+0GJqta0GE4aYNw@mail.gmail.com>
 <CAOzFzEj=gBXL9UaVytrebU3gr2p1rJaMVPkz1X0oZOALQKbcNA@mail.gmail.com>
 <CAH+dOxKznm_mhe_TkN5eOY8tz6snyAC0TF6bsZpi4P1KtDd9kA@mail.gmail.com>
 <CAOzFzEiSR1izXGuS+djSpCJOTnaPU6KetR=wB8tXmPopUk4Jrg@mail.gmail.com>
 <20120304142139.GA10510@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120304142139.GA10510-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-lvm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Mar 04, 2012 at 09:21:40AM -0500, Mike Snitzer wrote:
> On Fri, Mar 02 2012 at  9:28pm -0500,
> Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org> wrote:
> 
> > Ahh!
> > 
> > I didn't know LVM had a device type lookup table. You can see if you
> > look further that it also reads new types from the lvm.conf file.
> > Adding this line to lvm.conf fixes the problem:
> > 
> > types = [ "bcache", 16 ]
> >
> > I would imagine if merged it would be added to the internal compiled in table.
> 
> Assuming bcache devices are partitionable 16 would be used (like patch
> below), if they aren't then 1 would be used.

Thanks... any insight into what that table is for?

> Kent,
> 
> I know you were frustrated with DM in the past and that is why you
> created your own device type.

That'd be accurate :)

> I'll be looking much closer at bcache in the next week or so.  I'm
> starting to work on a DM-based caching target... it will re-use the
> drivers/md/persistent-data/ infrastructure we've established as part of
> the DM Thin Provisioning target.

Interesting... I'm also working on thin provisioning in bcache. It's
functional now but not production ready, pending the copying garbage
collector which I'm working on now.

For now it'll only be suitable for flash though, as it uses the same
allocation code as the caching code and assumes efficient random reads.

> Anyway, even if bcache remains to be a standalone (non-DM) block device
> in the future I'll have a look at it with an eye toward code sharing
> that might allow other caching layers to build on a common layer.  Even
> if the common code is a policy engine I think it'd be cool to allow
> sharing of policy across caching targets.

I've been working on making bcache's b+tree and other code more modular
for building other things around it. It's gotten quite fast, capable of
somewhere north of a million lookups per second.

> That said I'm also open to porting bcache to DM... but time will tell.
> I'll grab the latest bcache code and jump on the linux-bcache list and
> we can take it one step at a time.

I'm not averse to a dm interface for bcache (though I don't really see
the usefulness myself)... I could definitely spend some time walking you
through code and improving documentation, if you're interested. 
