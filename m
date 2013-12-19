From: Pavol Cupka <pavol.cupka@gmail.com>
Subject: Re: 2 drives btrfs raid1 with one ssd
Date: Thu, 19 Dec 2013 05:04:55 +0100
Message-ID: <CAH4oapejLOoWP58__hAqvTNP7nQULBycxGRCqrAW3_x8yhdg8w@mail.gmail.com>
References: <1387155717.6876.29.camel@N900-P>
	<op.w75uxvdkf3gqgg@desktop.patton.net>
	<CAH4oapepG0UgG_g8EHDpGSYKCGSKi9AFEAU8BGH63d5Bx6e+AQ@mail.gmail.com>
	<1387420255.21384.YahooMailNeo@web181506.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:59440 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3LSEE4 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Dec 2013 23:04:56 -0500
Received: by mail-qa0-f41.google.com with SMTP id j5so4381409qaq.7
        for <linux-bcache@vger.kernel.org>; Wed, 18 Dec 2013 20:04:55 -0800 (PST)
In-Reply-To: <1387420255.21384.YahooMailNeo@web181506.mail.ne1.yahoo.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

could you do it without mdraid? directly using the btrfs raid1 settings?

thanks

On Thu, Dec 19, 2013 at 3:30 AM, matthew patton <pattonme@yahoo.com> wrote:
>> I was thinking of simulating L2ARC like design from ZFS for btrfs.
>
>
> construct one leg of the MD Raid1 from a bCache device. Construct the other leg from regular disk and put it into write-mostly. Put BTRfs on top. Now you have L2ARC.
