From: =?UTF-8?B?SmVzw7pzIEfDs21leg==?= <jgomo3@gmail.com>
Subject: Re: Boot proccess messed up after dist-upgrade from Ubuntu 14.04 to 14.04.1
Date: Mon, 11 Aug 2014 19:20:59 -0430
Message-ID: <CAO9z-95zourpFx=-GKCGW4=OdwFhhhYFxrXUU24LzQEKPrHFbA@mail.gmail.com>
References: <CAO9z-97N5vc2E90Tz-hk6OX6-4JfeLK7iRkAFvffFWZB0bThEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:56994 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaHKXvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 11 Aug 2014 19:51:19 -0400
Received: by mail-yh0-f46.google.com with SMTP id a41so6898083yho.33
        for <linux-bcache@vger.kernel.org>; Mon, 11 Aug 2014 16:51:19 -0700 (PDT)
In-Reply-To: <CAO9z-97N5vc2E90Tz-hk6OX6-4JfeLK7iRkAFvffFWZB0bThEg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Josep Lladonosa read the mailing list and helped me to resolve this
issue, and i would like to share with you some things.

=46irst: The solution was to install somehow the bcache-tools 1.0.7-2 i=
n
the system. For that i had to mount it and chroot there. I don't know
if was the newer version which solved the problem or i just needed to
reinstall the tools so it could rebuild the initrd image.

But, here is some unexpected feedback. In order to be able to install
bcache-tools 1.0.7-2 in Ubuntu 10.14.1, i had to manually download the
=2Edeb file due the last version for trusty in the PPA is 1.0.7-1[1].
Maybe this should be fixed, as anyone following the documentation
instruction will simply do an "apt-get install bcache-tools" and he
will receive the 1.0.7-1 version.

Another though about this issue is that i did a fresh install of
Ubuntu 14.04. This is going to happen again when another person does
it and then upgrade it's Ubuntu to 14.04.1. Could be this considered
an Ubuntu bug?.

That's all, and thank you for the help.

[1] https://launchpad.net/~g2p/+archive/ubuntu/storage?field.series_fil=
ter=3Dtrusty

2014-08-11 12:53 GMT-04:30 Jes=C3=BAs G=C3=B3mez <jgomo3@gmail.com>:
> Hello!
>
> I'm using bcache for root in Ubuntu 14.04.
>
> After dist-upgrade to 14.04.1, a BusyBox shell appears instead.
>
> I tried set rootdelay with various values, but it doesn't work neithe=
r.
>
> Also, There is not a /dev/bcache0 in the BusyBox.
>
> With a liveCD, I mounted  /dev/bcache0 and the /boot partition to
> check for references to the uuid of /dev/bcache0 in /etc/fstab and
> /boot/grub/grub.cfg and are ok.
>
> Last, "grub-install"ed but nothing works.
>
> Any Idea?.
