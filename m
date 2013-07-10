From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Bug#715019: linux-image-3.10-rc7-amd64: Bcache (with cache on
 LVM?) stops system from shutting down
Date: Wed, 10 Jul 2013 16:00:38 -0700
Message-ID: <20130710230038.GB13527@kmo-pixel>
References: <20130705135658.9757.33407.reportbug@domo-b>
 <20130705184222.GX4752@decadent.org.uk>
 <CAL3dRBXX8Ex3iNE1v8N4pswqwh08enGPih0sP_ubpqUmbctdHA@mail.gmail.com>
 <1373496148.24446.21.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1373496148.24446.21.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Jarno Elonen <jarno.elonen-DbzOA/0qlwOT8k0kg1mbHA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 715019-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org, lvm2-R+A61+qa7K2F9N/2sQ04j0B+6BGkLq7r@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jul 10, 2013 at 11:42:28PM +0100, Ben Hutchings wrote:
> On Mon, 2013-07-08 at 19:56 +0300, Jarno Elonen wrote:
> > Ok, I tried to take a photo but apparently the camera was set for very
> > low resolution. :/ Anyway, a few pictures attached, and here's also a
> > manual transcript of a few lines:
> [...]
> > [242866.xxxxxx] ata5.00: exception Emask 0x0 SAct 0x0 SError 0x0
> > action 0x6 frozen
> > [242866.xxxxxx] ata5.00: failed command: FLUSH CACHE EXT
> > [242866.xxxxxx] ata8.00: exception Emask 0x0 SAct 0x0 SError 0x0
> > action 0x6 frozen
> > [242866.xxxxxx] ata8.00: failed command: FLUSH CACHE EXT
> > [242866.xxxxxx] ata8.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> > [242866.xxxxxx]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask
> > 0x4 (timeout)
> > [242866.xxxxxx] ata8.00: status { DRDY }
> > [242867.xxxxxx] ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> > ...
> > [242877.xxxxxx] ata3: COMRESET failed (errno=-16)
> > [242877.xxxxxx] ata5: COMRESET failed (errno=-16)
> > ...
> > 
> > These kinds of splurs com up once in a minute or so.
> 
> This suggests to me that LVM is *not* part of the problem, but instead
> the disks are being shut down before bcache has been quiesced.
> 
> bcache developers - is this supposed to just work, or does the init
> system need to do (or not do) something special for bcache devices?

This is supposed to work - bcache has a reboot notifier, which shuts
stuff down.

I _suspect_ what might be going on (I've seen the same issue myself with
bcache + md) is stacked block devices breaks it - which makes sense; the
block devices have to be torn down in the right order (because they
depend on each other) but the reboot notifier stuff just runs all the
notifiers one after the other, synchronously. And I can't just put the
asynchronous magic in the bcache code because, well, returning from our
notifier is how the core stuff knows that everything should be done
shutting down that can be.

I haven't actually tried to look and check that this is what's going on,
but if it is the right solution is for the reboot notifier to run all
the callbacks asynchronously.
