From: Leslie Basmid <leslie.basmid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Done installing bcache, a few questions
Date: Sat, 23 Feb 2013 12:42:10 +0100
Message-ID: <CA+XuAn+LiNbTrn06gn+CgXP2wmXc97ZnVU_39B=y3NxGoUDqzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi all,

I'm just done installing bcache on a laptop I've had with a 500GB HD
(sda) + 16GB SSD (sdb), and I have a few questions, just to make sure
that I have done everything correctly.

1. I have chosen to use the "bcache-for-upstream" branch, as I needed
features from more recent kernels than the 3.2 could offer. So far
everything is running smoothly, but do you have any remarks regarding
that choice ? Am I running any risk that I should be aware of ? Should
I rather use the main, unstable, "bcache" branch ?

1.5 I'd be more than happy to fill bug reports and run some tests you
wish me to do so (as I'm running a devel branch). My kernel dev days
are far behind now, but I would be happy to help this promising
project in any way I can. Just contact me.

2. I have setup LVM above bcache. So /dev/sda4 is the only "cached"
partition on sda, and the whole setup has been created using:
make-bcache -B /dev/sda4 -C /dev/sdb

Is having a partition as a  backing device and a whole device as a
caching device OK/recommended ?

3. Should I resize my logical volumes, what particular precautions
should I take ? I have the idea that I should maybe "flush the cache"
or something like that, to make sure that the informations in cache
are still relevant after the resizing (of both the LV and the FS).

Tanks in advance for your answers,
Leslie.
