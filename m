From: Henk Slager <eye1tm@gmail.com>
Subject: Re: Add Bcache to an existing Filesystem
Date: Mon, 26 Jun 2017 21:19:44 +0200
Message-ID: <CAPmG0jZ2ye9z-n8efF9zd7CbBDVFoykrszceq10WpepaGrhx5Q@mail.gmail.com>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com> <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com>
 <864cf409-86ca-dbe1-c6bc-89667a978f44@upx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:33458 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751335AbdFZTTp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Jun 2017 15:19:45 -0400
Received: by mail-qk0-f179.google.com with SMTP id r62so9280670qkf.0
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jun 2017 12:19:45 -0700 (PDT)
In-Reply-To: <864cf409-86ca-dbe1-c6bc-89667a978f44@upx.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Jun 26, 2017 at 8:14 PM, FERNANDO FREDIANI
<fernando.frediani@upx.com> wrote:
> Well, just a bit more detail of my scenario. This 8TB is a Linux RAID 10 on
> the top of 4 x 4TB disks, therefore the filesystem is currently mounted in a
> /dev/md124 which is a ext4. The physical disks in turn have each a single
> partition with type "Linux RAID" and they apparently start on sector 2048
> (see below on of these disks):
>
> Disk /dev/sdd: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk label type: gpt
> #         Start          End    Size  Type            Name
>  1         2048   7814037134    3.7T  Linux RAID

OK, setup is clear. I am only using this stack (w.r.t. backing device):
 harddisk(gpt partitioned) - bcache - luks - btrfs. That layering for
1 HDD + 1 SSD, but also for 1 SSD + 4 HDD using btrfs raid10. I wanted
to use btrfs multi-device/raid feature, so that is one reason why I
prefer bcache directly on top of partition. So for the btrfs raid10
situation, I have 4 bcache devices.

But if you use MD, you could choose to put bcache on top of MD. There
is someone on the list who uses bcache on top of MD RAID5 AFAIR. I
think I would choose to add bcache to each of the four harddisks,
primarily because I am not familiar enough now with Linux multiple
devices tooling, only how it was 10 years back. I would definitely
need to study, trial-run, etc it first. gdisk and dd are relatively
simple and static w.r.t changes, so that is what I have been usiing to
add and remove bcache. But maybe you feel comfortable enough with
changing things just above or below the MD layer and is it the same
accaptable risk.
