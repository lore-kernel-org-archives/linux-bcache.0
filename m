From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: [PATCH] bcache: fix uninterruptible sleep in writeback thread
Date: Fri, 2 May 2014 09:20:14 +0200
Message-ID: <CAHnuAexH1qRug5pbvZkprMLKbiJT6XkKjkbfBo1on7sr=qhmGA@mail.gmail.com>
References: <1398981150-27765-1-git-send-email-sp@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:37755 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaEBHUz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 2 May 2014 03:20:55 -0400
Received: by mail-oa0-f50.google.com with SMTP id i11so4790313oag.9
        for <linux-bcache@vger.kernel.org>; Fri, 02 May 2014 00:20:54 -0700 (PDT)
In-Reply-To: <1398981150-27765-1-git-send-email-sp@daterainc.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: linux-bcache@vger.kernel.org, Slava Pestov <sp@daterainc.com>

On Thu, May 1, 2014 at 11:52 PM, Slava Pestov <sp@datera.io> wrote:
> There were two issues here:
>
> - writeback thread did not start until the device first became dirty
> - writeback thread used uninterruptible sleep once running
>
> Without this patch I see kernel warnings printed and a load average of
> 1.52 after booting my test VM. With this patch the warnings are gone and
> the load average is near 0.00 as expected.
>

Ooooh, that sounds fantastic! I can't test it now, I'm at work and
have to look at other task, and ATM I don't have an instance with
proper sources either... I'm currently running a mainline 3.15-rc3
kernel for Utopic (I'm on Ubuntu Trusty). I would love to give it a
whirl during the weekend, though.

Forgive me for being a rookie, but I'm not entirely sure which sources
I should test this on. Is there a git branch specific to bcache? Or
another specific kernel branch that I should use this on? Or would it
just be any recent version (such as 3.15-rc3, which I kinda need for
Java to work without oopsing).

Thanks,
Daniel :)
