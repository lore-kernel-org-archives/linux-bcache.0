From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache version 9
Date: Fri, 03 Dec 2010 19:24:55 -0800
Message-ID: <4CF9B487.1010009__42721.2959541523$1291434310$gmane$org@gmail.com>
References: <20101121140808.GA6429@moria> <20101122010914.GB7688@kroah.com> <4CEB7648.8030000@gmail.com> <20101201041610.GA5891@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101201041610.GA5891-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <public-greg-U8xfFu+wG4EAvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>
Cc: Kent Overstreet <public-kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, public-linux-bcache-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org, public-linux-kernel-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org, public-linux-fsdevel-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org
List-Id: linux-bcache@vger.kernel.org




On 11/30/2010 08:16 PM, Greg KH wrote:
> True, but I thought configfs could handle "bare" config items, you might
> want to look a bit closer as to how people are using it.  But I could be
> totally wrong however.

The documentation is pretty specific and I haven't seen any 
counterexamples, but I'll see what I can find.

>> There do exist global interfaces in sysfs, not attached to any
>> device - besides /sys/kernel, there's /sys/fs which doesn't have any
>> rhyme or reason to it I can discern.
>
> /sys/fs is for different filesystem specific things.
>
>> ecryptfs has
>> /sys/ext4/ecryptfs/version, ext4 has per device stuff that you can't
>> find from the device's dir (you woludn't know /sys/fs/ext4/md0
>> exists from looking at /sys/block/md0). There's also /sys/fs/cgroup,
>> which is another unique thing as far as I can tell...
>
> No, sys/fs/cgroup/ is where the cgroup filesystem is mounted.

Yes, but as far as how the namespace is used it's exactly the same. By 
that logic, I could stick anything in /sys/fs if I made a filesystem for 
it to mount there. cgroupfs is just an interface, users wouldn't care if 
the same interface was written against sysfs (except for mounting 
multiple instances, but that's still not an argument for putting a 
mountpoint in /sys/fs).

>> Then there's /sys/module which has a bunch of ad hoc stuff, but as
>> far as I can tell that's all still module parameters and
>> register_cache and register_dev certainly aren't module parameters.
>
> It's not ad hoc, it's module specific things.

Exactly :p Bcache lives in a module, as does most code. There's no 
pattern to it besides that, is all I was saying.

> What is "bcache"?  Is it related to filesystems?

It uses SSDs to cache block devices; you'd cache say /dev/md0 with 
/dev/sdb, reads and writes get added to the cache and writes get 
buffered in the cache if writeback caching is on.

> If so, use
> /sys/fs/bcache and I have no issues with it.  But don't put it in
> /sys/kernel/ without at least asking.

You could say it's related to filesystems, but it's an awful stretch 
since it lives entirely at the block layer.

It's on the list of things that need fixing before merging, but that's a 
solid list. Priority #1 has been making it rock solid, which appears to 
be done... I've still got to finish handling all the potential memory 
allocation failures correctly and do something about the hooks in the 
block layer, which is a much bigger problem. I prefer my hacks to be 
obvious, ugly hacks :)


--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
