From: Nix <nix@esperi.org.uk>
Subject: Re: bcache crashes at boot time
Date: Thu, 22 Jun 2017 12:24:05 +0100
Message-ID: <874lv8tgdm.fsf@esperi.org.uk>
References: <CAE4BCM2DCZ5E29AbXmDwn8T3VBzUczLZa+CXkYVH_dZNrcqVeA@mail.gmail.com>
        <alpine.LRH.2.11.1706202158180.17052@mail.ewheeler.net>
        <87k245vbwp.fsf@esperi.org.uk>
        <alpine.LRH.2.11.1706220045190.17052@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:52988 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753121AbdFVLYL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2017 07:24:11 -0400
In-Reply-To: <alpine.LRH.2.11.1706220045190.17052@mail.ewheeler.net> (Eric
        Wheeler's message of "Thu, 22 Jun 2017 00:47:52 +0000 (UTC)")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: kent.overstreet@gmail.com, Igor Pavlenko <ipavlenko.mail@gmail.com>, linux-bcache@vger.kernel.org

On 22 Jun 2017, Eric Wheeler verbalised:
> The physical blocksize must be the same as the cachedev IIRC.  If 4k, use 
> -w 4k in make-bcache.  There's a thread somewhere discussing those 
> details.  

They are both 4096, and my make_bcache line was

make_bcache -B /dev/md/fast -C /dev/ssd2 --block 4096 --bucket 2M --data-offset $((2*30720))

which should be appropriate, I think? (This was my second attempt: I
came out with a number of unprintable words when I found that
make_bcache doesn't try to figure out an appropriate data offset when
used atop a RAID array, so the default options misalign the entire
thing.)

(Something I didn't make clear enough is that there there were several
successful restarts and remounts before the failed one.)

This is a writethrough cache, so it can't be a writeback problem (thank
goodness).

-- 
NULL && (void)
