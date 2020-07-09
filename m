From: Stefan K <shadow_7@gmx.net>
Subject: Re: how does the caching works in bcachefs
Date: Thu, 09 Jul 2020 15:20:14 +0200
Message-ID: <2900215.XKtEbqh0OK@t460-skr>
References: <2308642.L3yuttUQlX@t460-skr> <20200708220220.GA109921@zaphod.evilpiepirate.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:43919 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgGINUR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Jul 2020 09:20:17 -0400
In-Reply-To: <20200708220220.GA109921@zaphod.evilpiepirate.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org

Hi and thanks!

> LRU, same as bcache.
do you plan to change this , since LRU is not very efficient (in compariso=
n to other), maybe 2Q or ARC[1-4]

> [...]
> And you can pin specific files/folders to a device, by setting foregroun=
d target
> to that device and setting background target and promote target to nothi=
ng.
ok thank you very much! That must be documented somewhere ;-)


[1] https://en.ru.is/media/skjol-td/cache_comparison.pdf
[2] https://dbs.uni-leipzig.de/file/ARC.pdf
[3] http://people.cs.vt.edu/~butta/docs/sigmetrics05_kernelPrefetch.pdf
[4] http://www.vldb.org/conf/1994/P439.PDF

On Thursday, July 9, 2020 12:37:29 AM CEST kent.overstreet@gmail.com wrote=
:
> On Wed, Jul 08, 2020 at 11:46:00PM +0200, Stefan K wrote:
> > Hello,
> >
> > short question: how does the caching works with bcachefs? Is it like  =
"first
> > in first out" or is it more complex like the ARC system in zfs?
>
> LRU, same as bcache.
>
> > The same with the write-cache,  will be everything written to the SSD/=
NVMe
> > (Cache) and then to the HDD? When will will the filesystem say "its wr=
itten to
> > disk"? And what happens with the data on the write cache if we have a
> > powerfail?
>
> Disks that are used as caches are treated no differently from other disk=
s by the
> filesystem. If you want bcachefs to not rely on a specific disk, you can=
 set its
> durability to 0, and then it'll basically only be used as a writethrough=
 cache.
>
> >
> > And can I say have this file/folder always in the cache, while it work=
s "normal" ?
>
> Yes.
>
> So caching is configured differently, specifically so that it can be con=
figured
> on a per file/directory basis. Instead of having a notion of "cache devi=
ce",
> there are options for
>  - foregroud target: which device or group of devices are used for foreg=
round
>    writes
>  - background target: if enabled, the rebalance thread will in the backg=
round
>    move data to this target in the background, leaving a cached copy on =
the
>    foreground target
>  - promote target: if enabled, when data is read and it doesn't exist in=
 this
>    target, a cached copy will be added there
>
> So these options can be set to get you writeback mode, by setting foregr=
ound
> target and promote target to your SSD and background target to your HDD.
>
> And you can pin specific files/folders to a device, by setting foregroun=
d target
> to that device and setting background target and promote target to nothi=
ng.
>
