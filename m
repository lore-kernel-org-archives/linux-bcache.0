From: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Fri, 17 Feb 2012 20:12:22 +0100
Message-ID: <20120217191222.GA3002@lazy.lzy>
References: <20120202190122.GA2353@lazy.lzy>
 <20120202221101.GA26768@google.com>
 <20120202222431.GA7171@lazy.lzy>
 <loom.20120216T200235-190@post.gmane.org>
 <20120216203332.GA6597@lazy.lzy>
 <CA++fp8wcxTDJ=mbsKmWi27+yRZg-tyNdWgmhWU6=UeWgC0TZuw@mail.gmail.com>
 <20120216223554.GA6947@lazy.lzy>
 <CAOzFzEhO+6ECN-WjvtMK+-2g7Dwo+DPwQMVWuCZG=Y3BVRNEBw@mail.gmail.com>
 <20120216231754.GA14206@lazy.lzy>
 <CA++fp8w7_uUd35Tcwy1bwEYpR6tJ+fkWMEg+iVEyJ1H4hqKBKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA++fp8w7_uUd35Tcwy1bwEYpR6tJ+fkWMEg+iVEyJ1H4hqKBKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Alex,

> Perhaps, but there are two types of failures that are
> absolutely critical to distinguish between:
> 
> Recoverable, and unrecoverable.
> 
> If there is a superblock, any error in which the cache
> device is not available at activation is recoverable so
> long as the cache device can be made available at
> some other time.

yes and no, depend, as wrote before, on
*if* the cache device is coming and what
is the system doing with the volume.
 
> If there is a superblock, whether such a situation is
> recoverable is now undefined, and dependent on the
> implementation of the filesystem.

OK, let's say it differently, the superblock
*could* be in a different place than the
backing device.
 
> Actually, in modern initramfs' (see dracut) the
> way md devices are set up is via dynamic scanning,
> NOT via a static configuration file.

Actually, the dynamic scanning is done in
user space, not in kernel space.
It could be done using "mdadm.conf" or, by
"udev", using "mdadm -I" and proper udev rules.
This could be replicated with bcache.

As an example, and please note this is just
and example, so no nitpicking, we can consider
the following.

First of all, what is required is to activate
the bcache system from boot and to be able to
use the persistent caching, maybe even in write
back mode (backing not in sync).

What we need is:

1) udev rule, which is trigger by any storage device
found by the kernel. This should support the skipping
of following rules. AFAIK this is somehow supported
in udev, if not it will require a patch.

2) User space tool, let's call "bcacheadm", which can
activate bcache devices. This is called by the above
udev rule, must keep state across calls (it could use
the /dev/ fs or daemonize, for example) and should
have proper return codes, in order to allow udev to
skip following rules.

3) Configuration file, which contains, in the simple
case, pairs of device UUIDs, let's say caching-backing.
In case of more complex configurations it could be a
human (un)readable xml file.

Everything is packed into the initramfs, like it is
nowadays done with mdadm.

When a storage device pops up, udev call, at first,
the bcache rule. bcacheadm will then check if the
device is in the configuration list. If not, it will
just return and the following udev rules will run.
If yes, it will "copy" the device in the proper slot
(figuratively, slot in the list) and, if the slot is
full (caching and backing present), it will ask the
kernel to create the bcache device (and trigger a
further udev event). If the slot is not full, then
it will return and inform udev to skip the following
rules (for this device).

As wrote above, this all run in initramfs, like it
happens for md devices.
This is a bit complex, but I'm pretty sure smart
people can do better.

More or less the initial requirements are fulfilled.

This approach will, de facto, detach the superblock
from the backing device and put it in the config file.

What do we gain? A backing device unformatted.

What do we pay? A part for a little complexity, we
introduce a single point of failure, namely the
configuration file. If this is lost, damaged or
changed unintentionally, we can, potentially,
create the situation where the backing device
is activated without cache.
Of course, the information in this config file
could be reduntant and several fail-safe mechanisms
could be considered.

Is this worth? If you ask me, it is *NOT* worth it.

Nevertheless, my point is that it is *possible*.
Complexity is the limitation, the several dependencies,
the udev weaknesses, and so on.

That's why, I write it again, I fully agree on having
the superblock into the backing device.

Sorry for the long post,

bye,

-- 

piergiorgio
