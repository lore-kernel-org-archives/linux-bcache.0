From: Nix <nix@esperi.org.uk>
Subject: Re: Add Bcache to an existing Filesystem
Date: Tue, 27 Jun 2017 14:23:47 +0100
Message-ID: <87d19py36k.fsf@esperi.org.uk>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
        <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com>
        <864cf409-86ca-dbe1-c6bc-89667a978f44@upx.com>
        <CAPmG0jZ2ye9z-n8efF9zd7CbBDVFoykrszceq10WpepaGrhx5Q@mail.gmail.com>
        <20170627104654.Horde.qG1pMDnsa0LUeSdzxkMOzCc@webmail.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:52112 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbdF0NXx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 09:23:53 -0400
In-Reply-To: <20170627104654.Horde.qG1pMDnsa0LUeSdzxkMOzCc@webmail.nde.ag>
        (Jens-U. Mozdzen's message of "Tue, 27 Jun 2017 10:46:54 +0000")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: Henk Slager <eye1tm@gmail.com>, FERNANDO FREDIANI <fernando.frediani@upx.com>, linux-bcache@vger.kernel.org

On 27 Jun 2017, Jens-U. Mozdzen verbalised:

> Hi *,
>
> Zitat von Henk Slager <eye1tm@gmail.com>:
>> [...] There
>> is someone on the list who uses bcache on top of MD RAID5 AFAIR.
>
> that would probably be me: backing device was an MD-RAID6 (we've
> switched to RAID1 in the meantime because the data fits on a single
> disk (netto) and we needed the HDD slots) and caching device is an
> MD-RAID1 consisting of two SSDs.

Me too, but the fact that my bcache cache device exploded with "missing
magic" errors after less than a week makes me perhaps not a very good
advert for this.

>> I think I would choose to add bcache to each of the four harddisks,
>
> If you'd do that with a single caching device, you're in for  contention. My gut feeling tells me that running a single bcache
> backing device/caching device combo on top of MD-RAID is less  straining than running MD-RAID across a bunch of bcache devices with
> a  common caching device: The MD advantage of spreading the load across  multiple "disks" is countered by accessing a common SSD.

It all depends what your speed is like: if the load is at all seeky, an
SSD's zero seek time will dominate. md atop bcache will certainly have
far more SSD-write overhead than bcache atop md, because every time md
does a full-stripe read or read-modify-write cycle you'll be burning
holes in the SSD for no real speed benefit whatsoever...

One thing to note about working atop md is that you do have to be
careful about alignment: you don't want every md write to incur a
read-modify-write cycle after you've gone to some lengths to tell your
filesystems what the RAID offset is. You should compute an appropriate
--data-offset for not only the array configuration now (so a multiple of
your chunk size, at least, and possibly of your stripe size) but if you
are planning to add more data spindles you should figure out a (larger)
--data-offset that will retain appropriate alignment for plausible
larger sets of spindles you might grow to in the future.

(Also note that bcache does *not* communicate the RAID geometry through
to overlying filesystems -- if you want decent write performance on
RAID-5 or -6 you'll need to do that yourself, via mke2fs -E
stripe_width/stride, mkfs.xfs sunit and swidth arguments, cryptsetup
--align-payload, etc. You can use btrace on the underlying real block
device to see if the requests look aligned after you're done, but before
populating it with data. :) )

-- 
NULL && (void)
