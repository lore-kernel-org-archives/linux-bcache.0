From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: can't attach caching device to backing device
Date: Sun, 20 Nov 2011 21:31:15 -0800
Message-ID: <CAC7rs0sXfPXY81BpdQhtNMrj--bUeP+VSSqbDMvTYA_DyMRf3g@mail.gmail.com>
References: <8C67A0427441E84B879B0D6058D20D5222410FE6@EXCH-MBX-1.epic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8C67A0427441E84B879B0D6058D20D5222410FE6-QfgMShIfpGfUFh++4gLpBEEOCMrvLtNR@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Rush <jarush-Ub+6UvMsOfg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

When you tried to attach the cache, did the file you were echoing to
exist? That looks correct but I'm not sure what else would generate
that error.

=46or the UUIDs to show up in blkid, blkid itself would have to be
updated to know about the bcache superblock (IIRC it lives in
util-linux). I should probably ping the author and see if that can get
included.

If you have the udev rules and probe-bcache installed, the symlinks
/ought/ to show up when you reboot but I haven't tested that in ages.

I just got the code written so that it ought to be able to work on top
of md devices again, which means I should be able to run it at home
and I'll have to fix probe-bcache if it's broken then :)

On Mon, Nov 14, 2011 at 3:10 PM, Justin Rush <jarush-Ub+6UvMsOfg@public.gmane.org> wrote:
> Using 3.1.0-rc9
>
> I created a cache device on /dev/sdk1
> # ./make-bcache -C -b512k -w4k --writeback /dev/sdk1
>
> and a backing device on /dev/md127p1.
> ./make-bcache -B /dev/md127p1
>
> # ./probe-bcache /dev/sdk1
> 5f42bdd1-4342-4ab6-8dda-855989a09604: UUID=3D"" TYPE=3D"bcache"
>
> # ./probe-bcache /dev/md127p1
> 6bbac9a4-afbd-4d40-9562-cdd290622c5d: UUID=3D"" TYPE=3D"bcache"
>
> I then registered them by:
> # echo /dev/sdk1 >/sys/fs/bcache/register # echo /dev/md127p1 >/sys/f=
s/bcache/register
>
> I have /dev/bcache0
>
> When I try to attach the cache, I get this:
> # echo "5f42bdd1-4342-4ab6-8dda-855989a09604" >/sys/block/md127/md127=
p1/bcache/attach
> -bash: echo: write error: No such file or directory
>
> I believe this problem is due to the UUIDs for the two devices, but t=
his is just a guess. =A0The UUID for /dev/sdk1 and /dev/md127p1 doesn't=
 appear to be registering properly as they don't show up in blkid. =A0I=
 tried specifying the UUID to use with the -U option when creating the =
devices, but that didn't seem to help. =A0I do have the udev rules file=
 from the tools in place
>
> Does anyone know what is going on here and how to fix it?
>
> Justin Rush
> jarush-Ub+6UvMsOfg@public.gmane.org
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
