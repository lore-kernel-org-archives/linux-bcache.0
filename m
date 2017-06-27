From: Henk Slager <eye1tm@gmail.com>
Subject: Re: Add Bcache to an existing Filesystem
Date: Tue, 27 Jun 2017 16:41:23 +0200
Message-ID: <CAPmG0jbWDiMxJRCwK94uzzR+Mgz-3msx31DTHdwuXEQZ3UfdBg@mail.gmail.com>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com> <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com>
 <864cf409-86ca-dbe1-c6bc-89667a978f44@upx.com> <CAPmG0jZ2ye9z-n8efF9zd7CbBDVFoykrszceq10WpepaGrhx5Q@mail.gmail.com>
 <20170627104654.Horde.qG1pMDnsa0LUeSdzxkMOzCc@webmail.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35782 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdF0Ol0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 10:41:26 -0400
Received: by mail-qk0-f174.google.com with SMTP id 16so26749558qkg.2
        for <linux-bcache@vger.kernel.org>; Tue, 27 Jun 2017 07:41:26 -0700 (PDT)
In-Reply-To: <20170627104654.Horde.qG1pMDnsa0LUeSdzxkMOzCc@webmail.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: FERNANDO FREDIANI <fernando.frediani@upx.com>, linux-bcache@vger.kernel.org

> On top of that bcache device, I decided to add an LVM layer (making
> /dev/bcache* a PV), which is really helpful i.e. with the base problem of
> this thread: You can create additional bcache devices and pvmove your data
> to the new PV, without interrupting production.

Yes, if you start from scratch with some disk setup, including LVM can
 give you a lot of flexibility and almost always-online.
>> I
>> think I would choose to add bcache to each of the four harddisks,
>
>
> If you'd do that with a single caching device, you're in for contention. My
> gut feeling tells me that running a single bcache backing device/caching
> device combo on top of MD-RAID is less straining than running MD-RAID across
> a bunch of bcache devices with a common caching device: The MD advantage of
> spreading the load across multiple "disks" is countered by accessing a
> common SSD.

You are right, if you use MD-RAID, after second thought, bcache on top
of MD is a better choice in most cases as far as I can see. I have
been thinking to use RAID of MD instead of btrfs raid. I tried/tested
it with 3-disk RAID5 for some time, but still decided to use only
btrfs for handling multipe devices.

W.r.t. contention for 1 SSD bcaching 4 HDDs: I can definitely notice
this for some access patterns/tasks. I once chose btrfs raid10 when
all HDD were much older/slower and I wanted high enough transfer rates
on file level. But the HDDs are now all newer/faster model and the
strict need for high transfer rates is gone. It currently makes more
sense to use less SATA ports and also less spinning disks and re-use
HDD(s) for redundancy/backup on a file-system-level.
