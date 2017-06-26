From: Henk Slager <eye1tm@gmail.com>
Subject: Re: Add Bcache to an existing Filesystem
Date: Mon, 26 Jun 2017 20:05:35 +0200
Message-ID: <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34491 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdFZSFh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Jun 2017 14:05:37 -0400
Received: by mail-qk0-f174.google.com with SMTP id d78so7608421qkb.1
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jun 2017 11:05:36 -0700 (PDT)
In-Reply-To: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Jun 26, 2017 at 6:12 PM, FERNANDO FREDIANI
<fernando.frediani@upx.com> wrote:
> Hello folks.
>
> I have been using Bcache in a server in production with pretty good results
> so far.
>
> Now I am looking to add it also to another server that is suffering from
> disk I/O. However this server in question has a fairly large storage running
> (circa 8TB of used data) and therefore stopping it for a long period becomes
> difficult.
>
> Question is: Can I add an SSD and Bcache to this server and use it for the
> existing 8TB filesystem ? If so when I run make-bcache -B /dev/sdx1 to
> create the backing device will it not overwrite what is currently on
> /dev/sdx1 ?

Yes you can if you are prepared to do some re-partition tricks. Maybe
there is a tool/script that can do that, AFAIK there is some python
prog called blocks for this.

Anyhow, what make-bcache -B /dev/sdx1 does is write an 8KiB sized
header at the start of /dev/sdx1. So in case this is the only GPT
based partition on the diskdevice that currently starts at
512-byte-sized sector 2048, there is usually some free space between
GPT table and 2048. So make sure you have all backupped, then unmount
the fs and use gdisk to set the starting sector of /dev/sdx1 to 2032,
by delete first and re-create (with alignment set to 16 sectors
first).

Then make sure the kernel uses the new partition table (partprobe or
reboot) and run make-bcache -C <SSD> -B /dev/sdx1. You can now access
the fs via /dev/bcache0

Some people might consider this way too risky, but I have successfully
used it, also in reverse order for removal of bcache. You might have a
slighty different disk setup than I assume, but I hope th eprinciple
is clear. If you would script it, it takes about the time of an
unmount+mount, so seconds instead of hours or even days.
