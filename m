From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: [PATCH] bcache: fix uninterruptible sleep in writeback thread
Date: Fri, 2 May 2014 10:10:05 +0200
Message-ID: <CAHnuAeyAyRtFeLc1r8mDS-TzxVCmfzjJW8ctKf38rQELS8qnhg@mail.gmail.com>
References: <1398981150-27765-1-git-send-email-sp@daterainc.com> <CAHnuAexH1qRug5pbvZkprMLKbiJT6XkKjkbfBo1on7sr=qhmGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:44842 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaEBIKr (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 2 May 2014 04:10:47 -0400
Received: by mail-ob0-f180.google.com with SMTP id va2so2087905obc.25
        for <linux-bcache@vger.kernel.org>; Fri, 02 May 2014 01:10:46 -0700 (PDT)
In-Reply-To: <CAHnuAexH1qRug5pbvZkprMLKbiJT6XkKjkbfBo1on7sr=qhmGA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: linux-bcache@vger.kernel.org, Slava Pestov <sp@daterainc.com>

On Fri, May 2, 2014 at 9:20 AM, Daniel Smedegaard Buus
<danielbuus@gmail.com> wrote:
> Forgive me for being a rookie, but I'm not entirely sure which sources
> I should test this on. Is there a git branch specific to bcache? Or
> another specific kernel branch that I should use this on? Or would it
> just be any recent version (such as 3.15-rc3, which I kinda need for
> Java to work without oopsing).

Okay, it patched just fine against the 3.15-rc3 tar from kernel.org.
I'm compiling it to debs on a micro instance now, gonna check it out
later (probably gonna take forever ;) ).

Thanks!
