From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Add Bcache to an existing Filesystem
Date: Tue, 27 Jun 2017 23:43:54 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706272340300.17052@mail.ewheeler.net>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com> <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com> <864cf409-86ca-dbe1-c6bc-89667a978f44@upx.com> <CAPmG0jZ2ye9z-n8efF9zd7CbBDVFoykrszceq10WpepaGrhx5Q@mail.gmail.com>
 <20170627104654.Horde.qG1pMDnsa0LUeSdzxkMOzCc@webmail.nde.ag> <CAPmG0jbWDiMxJRCwK94uzzR+Mgz-3msx31DTHdwuXEQZ3UfdBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:37376 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753975AbdF0Xnz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 19:43:55 -0400
In-Reply-To: <CAPmG0jbWDiMxJRCwK94uzzR+Mgz-3msx31DTHdwuXEQZ3UfdBg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Henk Slager <eye1tm@gmail.com>
Cc: "Jens-U. Mozdzen" <jmozdzen@nde.ag>, FERNANDO FREDIANI <fernando.frediani@upx.com>, linux-bcache@vger.kernel.org

On Tue, 27 Jun 2017, Henk Slager wrote:

> > On top of that bcache device, I decided to add an LVM layer (making
> > /dev/bcache* a PV), which is really helpful i.e. with the base problem of
> > this thread: You can create additional bcache devices and pvmove your data
> > to the new PV, without interrupting production.
> 
> Yes, if you start from scratch with some disk setup, including LVM can
>  give you a lot of flexibility and almost always-online.
> >> I
> >> think I would choose to add bcache to each of the four harddisks,
> >
> >
> > If you'd do that with a single caching device, you're in for contention. My
> > gut feeling tells me that running a single bcache backing device/caching
> > device combo on top of MD-RAID is less straining than running MD-RAID across
> > a bunch of bcache devices with a common caching device: The MD advantage of
> > spreading the load across multiple "disks" is countered by accessing a
> > common SSD.
> 
> You are right, if you use MD-RAID, after second thought, bcache on top
> of MD is a better choice in most cases as far as I can see. I have
> been thinking to use RAID of MD instead of btrfs raid. I tried/tested
> it with 3-disk RAID5 for some time, but still decided to use only
> btrfs for handling multipe devices.

Definitely.  bcache atop of md, not md atop of bcache.  You would confuse 
the sequential-write logic with md on bcache.  

Also, with bcache on md, align using --data-offset.  8k is most certainly 
not your md chunk size and you don't want write amplification.  You might 
wish to align to your stride width (especially if raid5/6), so 
--data-offset=chunk_size*num_data_disks in sectors.

--
Eric Wheeler
