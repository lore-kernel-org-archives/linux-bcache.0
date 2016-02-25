From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Thu, 25 Feb 2016 18:18:03 +0800
Message-ID: <CAC8teKUjvdyPM62UnwuFsXMoa74LsnxAOwm7ioFb03-TyA=4ZA@mail.gmail.com>
References: <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net>
 <56C1F2A4.4090208@evilazrael.de> <20160224204530.GA13079@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34634 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbcBYKSX (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 05:18:23 -0500
Received: by mail-ob0-f181.google.com with SMTP id ts10so44611050obc.1
        for <linux-bcache@vger.kernel.org>; Thu, 25 Feb 2016 02:18:23 -0800 (PST)
In-Reply-To: <20160224204530.GA13079@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Christoph Nelles <evilazrael@evilazrael.de>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org

2016-02-25 4:45 GMT+08:00 Marc MERLIN <marc@merlins.org>:
> On Wed, Feb 24, 2016 at 06:53:05AM +0000, Eric Wheeler wrote:
>> Be sure to cherry-pick these from linux 4.5-rc1:
>>       git cherry-pick 2ef9ccbf~1..627ccd20
>> or use one of the 4.1 or 3.18 longterm kernels.
>
> So, I added these patches to my 4.4.2 kernel, but it still crashes when
> seeing one cache device at boot.
>
> Crash:
> https://goo.gl/photos/8H1DtYjSijK4ngFv6
>
>         while (!kthread_should_stop()) {
>                 try_to_freeze();
>
>                 w = bch_keybuf_next(&dc->writeback_keys);
>                 if (!w)
>                         break;
>
>>>>>>           BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
>
>                 if (KEY_START(&w->key) != dc->last_read ||
>
> I have to remove the partition for my system to boot.
>
> Before I destroy it, any other patches I should try?
>
> And to be fair, it's a huge pain to deal with this, there should be an
> easier way to just turn bcache off from the kernel command line. In this
> case it was really a lot of work to get back to even a booting system.
>
> You also said:
>> 4.1.18 has the patches, so unless there is something specific in 4.4 that
>> you need, I recommend 4.1.  We've been running 4.1.17 with patches in
>> production for a while and it works great.  Haven't tried vanilla 4.1.18
>> yet, but I plan to soon.
>
> Sadly, I run btrfs, I can't just go to random old kernels like this.
> Is bcache not stable in up to date kernels?
>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Marc,
When did you *first* see this BUG_ON? During boot up or far after the
whole system is up?

-zyh
