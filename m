From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: Creating bdev on md array fails, but not quite ...
Date: Thu, 27 Mar 2014 14:34:31 +0100
Message-ID: <CAHnuAewpof57hAFpTXesAjG6_pXYoVjDOQD17MSjsByqVDxKag@mail.gmail.com>
References: <CAHnuAewuXgA0B1hRjDCNBoQyJNJCOiZtEs16LSVMTe9Y29RS+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36329 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaC0NfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 27 Mar 2014 09:35:12 -0400
Received: by mail-ob0-f176.google.com with SMTP id wp18so4182285obc.21
        for <linux-bcache@vger.kernel.org>; Thu, 27 Mar 2014 06:35:12 -0700 (PDT)
In-Reply-To: <CAHnuAewuXgA0B1hRjDCNBoQyJNJCOiZtEs16LSVMTe9Y29RS+g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I was a bit quick there =E2=80=94 I hadn't realized I was reusing a cou=
ple of
EBS devices that I'd previously set up as a bdev, so that's why it
wouldn't recreate it.

Still puzzled, though, why a --wipe would result in a device busy error=
=2E

On Thu, Mar 27, 2014 at 2:00 PM, Daniel Smedegaard Buus
<danielbuus@gmail.com> wrote:
> Hi :)
>
> I'm trying to create a scripted bcache setup for an EC2 AMI. It'll
> detect appropriate EBS devices, join them in a raid0 array, then do
> the same for ephemeral devices. This results in /dev/md0 and /dev/md1=
=2E
>
> So far so good.
>
> My script fails when I try to create the bdev;
>
>     # make-bcache --bdev /dev/md0
>     Can't open dev /dev/md0: Device or resource busy
>
> Interesting thing is, I now have
> /sys/devices/virtual/block/md0/bcache, though no /sys/block/bcache0.
>
> I can echo 1 > /sys/devices/virtual/block/md0/bcache/stop and the
> md0/bcache directory disappears. Trying again, I get:
>
>     # make-bcache --bdev /dev/md0
>     Already a bcache device on /dev/md0, overwrite with --wipe-bcache
>     # make-bcache --bdev --wipe-bcache /dev/md0
>     Can't open dev /dev/md0: Device or resource busy
>
> And /sys/devices/virtual/block/md0/bcache reappears.
>
> What gives? This seems pretty strange to me.
>
> The kernel is 3.13.0-19-generic #39-Ubuntu SMP Fri Mar 21 14:18:44 UT=
C
> 2014 x86_64 x86_64 x86_64 GNU/Linux
>
> Thanks,
> Daniel :)
