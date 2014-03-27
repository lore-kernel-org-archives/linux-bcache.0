From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Creating bdev on md array fails, but not quite ...
Date: Thu, 27 Mar 2014 14:00:56 +0100
Message-ID: <CAHnuAewuXgA0B1hRjDCNBoQyJNJCOiZtEs16LSVMTe9Y29RS+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44258 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaC0NBg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 27 Mar 2014 09:01:36 -0400
Received: by mail-ob0-f172.google.com with SMTP id wm4so4190884obc.3
        for <linux-bcache@vger.kernel.org>; Thu, 27 Mar 2014 06:01:36 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi :)

I'm trying to create a scripted bcache setup for an EC2 AMI. It'll
detect appropriate EBS devices, join them in a raid0 array, then do
the same for ephemeral devices. This results in /dev/md0 and /dev/md1.

So far so good.

My script fails when I try to create the bdev;

    # make-bcache --bdev /dev/md0
    Can't open dev /dev/md0: Device or resource busy

Interesting thing is, I now have
/sys/devices/virtual/block/md0/bcache, though no /sys/block/bcache0.

I can echo 1 > /sys/devices/virtual/block/md0/bcache/stop and the
md0/bcache directory disappears. Trying again, I get:

    # make-bcache --bdev /dev/md0
    Already a bcache device on /dev/md0, overwrite with --wipe-bcache
    # make-bcache --bdev --wipe-bcache /dev/md0
    Can't open dev /dev/md0: Device or resource busy

And /sys/devices/virtual/block/md0/bcache reappears.

What gives? This seems pretty strange to me.

The kernel is 3.13.0-19-generic #39-Ubuntu SMP Fri Mar 21 14:18:44 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

Thanks,
Daniel :)
