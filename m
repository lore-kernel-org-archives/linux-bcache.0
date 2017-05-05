From: Nix <nix@esperi.org.uk>
Subject: Re: what happened to the nifty ioprio cache hinting stuff?
Date: Fri, 05 May 2017 22:48:45 +0100
Message-ID: <874lwzasaq.fsf@esperi.org.uk>
References: <877f1zil5d.fsf@esperi.org.uk>
        <20170502201559.5cd65131@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:40360 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdEEVss (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 May 2017 17:48:48 -0400
In-Reply-To: <20170502201559.5cd65131@jupiter.sol.kaishome.de> (Kai Krakow's
        message of "Tue, 2 May 2017 20:15:59 +0200")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 2 May 2017, Kai Krakow said:

> Am Tue, 02 May 2017 11:54:38 +0100
> schrieb Nix <nix@esperi.org.uk>:
>
>> I found the ioprio cache hinting quite exciting (I know, I'm weird):
>> it won't help with writeback or e.g. NFS, but it will certainly let me
>> do things like run backups without wearing my SSD out.
>
> I'm certainly waiting for the patches to be upstreamed. Meanwhile, I
> stopped the hassle of applying the patches and just resorted to putting
> my backups partition into "write-around" mode. It still gets big
> improvements in performance and is nice to wear leveling.

I'm running in writearound mode regardless, since my bcache is atop an
md array, and that array is journalled on the same SSD (for powerfail
reliability and because in write-back mode it greatly speeds up writes),
and I don't want to burn the SSD out *that* badly. It still speeds
things up hugely :)

>> This was in ewheeler's for-4.10-block-bcache-updates branch, but it
>> didn't get into 4.10 or 4.11, even while other commits on the same
>> branch did :( is it dead? (I mean, it still seems to *apply* to
>> 4.11...)
>
> Last time I looked at bitbucket (the only place I found it) to pull the
> patches via http, it was horribly slow and even complained that the
> repository is too big to be browsed or generate patch sets.
>
> Would it be possible to mirror it somewhere else? Bitbucket is really
> slow for me, direct git-clone didn't even work.
>
> I was just trying to pull the branch and rebase it ontop of current
> kernels myself because I couldn't apply these patches. But I eventually
> gave up due to bitbuckets superior *cough* performance... :-(

It is much faster to take an existing kernel working tree and do a

git remote add ewheeler https://bitbucket.org/ewheelerinc/linux.git
git remote update ewheeler

since this only needs to get a few hundred KiB of objects.
