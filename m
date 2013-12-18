From: Pavol Cupka <pavol.cupka@gmail.com>
Subject: Re: 2 drives btrfs raid1 with one ssd
Date: Wed, 18 Dec 2013 20:11:44 +0100
Message-ID: <CAH4oapepG0UgG_g8EHDpGSYKCGSKi9AFEAU8BGH63d5Bx6e+AQ@mail.gmail.com>
References: <1387155717.6876.29.camel@N900-P>
	<op.w75uxvdkf3gqgg@desktop.patton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qe0-f45.google.com ([209.85.128.45]:34945 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3LRTLp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Dec 2013 14:11:45 -0500
Received: by mail-qe0-f45.google.com with SMTP id 6so78163qea.4
        for <linux-bcache@vger.kernel.org>; Wed, 18 Dec 2013 11:11:44 -0800 (PST)
In-Reply-To: <op.w75uxvdkf3gqgg@desktop.patton.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
Cc: linux-bcache@vger.kernel.org

I was thinking of simulating L2ARC like design from ZFS for btrfs.
that's why I wanted one ssd partition taking care of both mirrored
drives, mostly for read cache.


thanks for your reply.
pavol

On Mon, Dec 16, 2013 at 2:11 AM, Matthew Patton <pattonme@yahoo.com> wrote:
> On Sun, 15 Dec 2013 20:01:57 -0500, Pavol Cupka <pavol.cupka@gmail.com>
> wrote:
>
>> I would like to use a bcache for btrfs filesystem residing on two
>> identical disk as raid1 using btrfs' raid (without soft/hard raid).
>>
>> Is it possible?
>
>
> if I understood you correctly, no.
>
>
>> I would like to use the same ssd/ssd partition for caching both
>> drives/mirror. Is this doable?
>
>
> You will have to build the btrfs 'raid' on top of two bcache devices. If the
> caching device for both devices in the same SSD (partitioned) what's the
> point? Assuming Btrfs has a similar feature set to MD's Raid1 write-mostly,
> you could accelerate the one side, and run the other half of the mirror
> without acceleration. Otherwise I would just use MD's Raid1 and be done with
> it. Put btrfs/ext4/xfs on top as you like.
>
> Does your intended workload really benefit from putting an SSD into the mix?
