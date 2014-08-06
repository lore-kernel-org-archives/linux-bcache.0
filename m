From: Slava Pestov <sp@datera.io>
Subject: Re:
Date: Wed, 6 Aug 2014 10:10:42 -0700
Message-ID: <CACHGV4+_Odo73VV2pWpAJk5=y+QJKLLmsJXhsTcKVLKFM8Phjg@mail.gmail.com>
References: <CAHnuAey8g7OUZPS6QQP_4h6P07=6q8r3J6kZr8D=DJ67fwFhfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:38679 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbaHFRKn (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 6 Aug 2014 13:10:43 -0400
Received: by mail-oa0-f42.google.com with SMTP id n16so2079570oag.29
        for <linux-bcache@vger.kernel.org>; Wed, 06 Aug 2014 10:10:42 -0700 (PDT)
In-Reply-To: <CAHnuAey8g7OUZPS6QQP_4h6P07=6q8r3J6kZr8D=DJ67fwFhfQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Daniel Smedegaard Buus <danielbuus@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi Daniel,

Can you post the oops output here? There were no bcache changes from
3.15 to 3.16 so I'm not sure what could have gone wrong.

On Wed, Aug 6, 2014 at 5:06 AM, Daniel Smedegaard Buus
<danielbuus@gmail.com> wrote:
> Hi :)
>
> I just tried upgrading a server of mine from mainline kernel 3.15.4 to
> 3.16, and upon reboot no bcache device in sight. Grepping dmesg for
> bcache yielded an empty output, and besides the dmesg was full of
> oopses.
>
> This is a live server, so I immediately remove kernel 3.16, and upon
> reboot, bcache was back and happy.
>
> I know this isn't very useful for anything debugging, but as a very
> general question, I'm just wondering if there's something I should
> have done prior to upgrading, or if this might be a bug of some sort?
>
> Cheers,
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
