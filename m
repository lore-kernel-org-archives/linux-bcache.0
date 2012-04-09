From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: Quick howto?
Date: Mon, 9 Apr 2012 21:37:38 +1000
Message-ID: <CAOzFzEiy02VLbfXu1ET9PORUsTV=6GUA8MnT03PV0f8TLJLSBw@mail.gmail.com>
References: <001901cd1643$3801e2c0$a805a840$@snow.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001901cd1643$3801e2c0$a805a840$@snow.nl>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerrit Tamboer <gtamboer-JFNXyGN8thM@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 9 April 2012 21:23, Gerrit Tamboer <gtamboer-JFNXyGN8thM@public.gmane.org> wrote:
> Hi!
>
> I am currently trying to test bcache stability in combination with th=
e btrfs
> filesystem. I am currently stuck with some unanswered questions and I=
 was
> hoping that someone could help me out on the following;
>
> 1. The documentation on the website is out of date, this means there =
is not
> quickstart guide on how to actually use bcache. I was able to compile=
 the
> kernel with bcache support but how do I further configure it? I have =
a sata
> disk on sda with sda1 and sda2 used for / and /home. My sdb is an
> unformatted SSD which I want to use for caching. In this particular s=
etup,
> how do I configure the kernel to use sdb for caching sda1 and sda2?

=46irst make sure you have built bcache into the kernel. In my
experience building as a module caused me a few issues with 3.2. (will
test and get back to the list at some stage)

Next you need to get the bcache-tools repository.
  git://evilpiepirate.org/~kent/bcache-tools.git
Run make to build the tools, and make install to install them. You may
have issues with it trying to install initramfs hooks if you distro
doesnt use the same directory.

=46ormat the devices.
make-bcache -C /dev/sdb #setup the cache device with defaults, you can
tune these later
make-bcache -B /dev/sda2 # I would recommend starting with a spare
disk or partition before attempting to get a system booting from
bcache

Register the devices with bcache
echo /dev/sdb > /sys/fs/bcache/register
echo /dev/sda2 > /sys/fs/bcache/register

Attach the cache to the backing device. To do this you need the UUID
of the cache set. This was returned in make-bcache -C step but you can
get it back with "ls /sys/fs/bcache" or the blk-id command in
bcache-tools.
echo "$UUIDHERE" > /sys/block/bcache0/bcache/attach

The cache is now online and you should be able to see bcache stats etc
in /sys/block/bcache0/bcache/

>
> 2. Currently the git repo is a full kernel with bcache support, is th=
ere a
> way to only fetch the bcache patch for other kernels? I have a linux =
box
> with linux 2.6.x and I would like to patch bcache into it instead of
> compiling 3.1.x and migrating to it.

There is some 2.6.32/34 code hanging about. Wait for Kent to reply
with details of what is available.
I would highly recommend running the 3.1 or 3.2 builds however,
changes beside bcache have make the Linux kernel much more performant
recently.
If you want to apply bcache as a single monolithic patch against a
stock 3.2 kernel you can generate the patch with this command:
git diff 805a6af8dba5dfdd35ec35dc52ec0122400b2610 > /path/to/file.patch

Else you can generate a full patch series with:
git format-patch 805a6af8dba5dfdd35ec35dc52ec0122400b2610

>
> 3. If I would temporarily want to disable caching to do maintenance, =
is
> there a way to flush the current queue to disk?

I think the "stop' method will do this. Currently I pause I/O on the
volumes and wait for the dirty data to drain (because I am paranoid)
before running stop though.
Kent might be able to offer some additional insight here.

>
> Thanks in advance!
>
> Regards,
>
> Gerrit Tamboer
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846
