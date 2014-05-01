From: Slava Pestov <sp@datera.io>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Thu, 1 May 2014 14:54:29 -0700
Message-ID: <CACHGV4L76Env_vu+bVqNgbRwuKa8TEY05wvXC8GBQUjzMuPWjQ@mail.gmail.com>
References: <20140411002636.GB9176@birch.djwong.org>
	<20140411004649.GA4817@kmo>
	<20140411014135.GA18933@birch.djwong.org>
	<20140412023101.GC9176@birch.djwong.org>
	<CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com>
	<20140430172455.GA3029@birch.djwong.org>
	<CAHnuAexAx_QK3tycB_2o60JDYZAHUgbec=fu3i47ZSXrL4nARg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:48766 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaEAVy3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 1 May 2014 17:54:29 -0400
Received: by mail-ob0-f180.google.com with SMTP id va2so1578451obc.39
        for <linux-bcache@vger.kernel.org>; Thu, 01 May 2014 14:54:29 -0700 (PDT)
In-Reply-To: <CAHnuAexAx_QK3tycB_2o60JDYZAHUgbec=fu3i47ZSXrL4nARg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Daniel Smedegaard Buus <danielbuus@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Kent Overstreet <kmo@daterainc.com>, Sam Fulcomer <enotty@brown.edu>, Francis Moreau <francis.moro@gmail.com>, Daniel J Blueman <daniel@quora.org>, linux-bcache@vger.kernel.org

Hi Daniel and Darrick,

I mailed a patch that attempts to fix the uninterruptible issue while
taking Kent's feedback regarding your earlier patch into account.
Please test it out and let me know what you think.

On Thu, May 1, 2014 at 2:38 AM, Daniel Smedegaard Buus
<danielbuus@gmail.com> wrote:
> On Wed, Apr 30, 2014 at 7:24 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
>>
>> I haven't spent time on figuring out the other source of load average.  Kent
>> didn't seem to like the patch to convert the bcache_writeback thread to
>> interruptible sleep (I recall he said it was 'wrong', but didn't elaborate).
>>
>
> Sorry to hear that... Would be really nice to be able to go back to
> normal load. And I cannot revert to an older kernel, as I need
> 3.15-rc2 or greater to fix a different problem concerning Oracle Java
> :/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
