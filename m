From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Can't resgister cache
Date: Tue, 14 Feb 2012 22:24:56 -0800
Message-ID: <CAH+dOx+g=eKDgTCnVdZYKrtn7tZjAnWeMdYP0KuZwD=rktsuJw@mail.gmail.com>
References: <1329283588.3289.294.camel@ipcus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329283588.3289.294.camel@ipcus>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Franco <franco-uJ2R6605E/fKnmoGZ802fQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Not sure what's going on with not being able to register again - not a
lot of info to go off of. It was working last I checked in the
bcache-3.2-dev branch, it might be buggy in the older bcache branch.

=46rom your numbers it looks like the 8 gb of data wasn't in the cache =
-
bcache bypasses sequential IO by default. You can flip it off by
echoing 0 to sequential_cutoff.

On Tue, Feb 14, 2012 at 9:26 PM, Franco <franco-uJ2R6605E/fKnmoGZ802fQ@public.gmane.org> wrote=
:
> Hi
>
> I was in the process of testing linux-bcache but was seeing some stra=
nge
> behaviour so I thought I would remount my cached filesystem. I then
> noticed that the performance results started looking like the cache j=
ust
> wasn't there, so I unregistered it:
>
> bcache: Cache set be008612-38aa-4082-9f42-1bada25cb002 unregistered
> bcache: Caching disabled for sdc
>
> but now when I try to register it again, I get bcache: error
> opening /dev/sdb: device busy.
>
> I haven't tried rebooting yet but probably will do after I've sent th=
is
> message.
>
> These were the strange results I was getting that prompted me to unmo=
unt
> and remount the filesystems.
>
> Setup: hardware RAID 5 16 disk array with 2 partitions, 1 Intel 40GB =
SSD
> for bcache.
>
> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
> /dev/bcache0 =A0 =A0 =A0 =A0 =A01.9T =A0 26G =A01.8T =A0 2% /data33
> /dev/sdd =A0 =A0 =A0 =A0 =A0 =A0 =A01.9T =A0 23G =A01.8T =A0 2% /data=
34
>
> Wrote an 8GB file to each filesystem, then tried reading it back.
> Machine has 8GB RAM.
>
> Speed for random reads from identical SSD =3D 181.766523 MB/Sec, rand=
om
> read test done in the following order with measured speed in MB/Sec. =
The
> random IO is actually just reading with a 4GB stride, wrapping around=
 at
> the end of the file.
>
> /data33 49
> /data34 114
> /data33 114
> /data33 and /data44 simultaneously 78 and 59 respectively
> /data33 76
> /data33 68
> /data34 114
> /data34 96
> /data34 69
> /data34 74
> /data33 118
> /data33 40
> /data34 91
>
> After remounting both filesystems:
>
> /data34 148
> /data33 120
> /data34 120
> /data33 82
>
>
> After unregistering the cache
>
> /data33 65
> /data34 83
> /data33 99
> /data34 113
>
> Cheers,
> Franco
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
