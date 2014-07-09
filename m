From: Slava Pestov <sp@datera.io>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Wed, 9 Jul 2014 11:19:49 -0700
Message-ID: <CACHGV4LX4r7f-gb+hsiNe0GYDODwUq8G-VsEx8_oJCxOpweQpg@mail.gmail.com>
References: <20140411002636.GB9176@birch.djwong.org>
	<20140411004649.GA4817@kmo>
	<20140411014135.GA18933@birch.djwong.org>
	<20140412023101.GC9176@birch.djwong.org>
	<CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com>
	<20140430172455.GA3029@birch.djwong.org>
	<CAHnuAexAx_QK3tycB_2o60JDYZAHUgbec=fu3i47ZSXrL4nARg@mail.gmail.com>
	<CACHGV4+mNu_KV7JazT-34D++3S2NKhDkOmc_wo0QfrfdqpccoQ@mail.gmail.com>
	<CAHnuAez0rb9PLLEU7sB79x2_w14bJre+4ZbkWKyO+YUF255Czw@mail.gmail.com>
	<53BD658A.9020100@kieser.ca>
	<CAHnuAeyD2RJh+DNbBfRq4XtdsYKHGRv0kEa8yfTb+FX61Ln8kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46489 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaGISTt (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Jul 2014 14:19:49 -0400
Received: by mail-ob0-f178.google.com with SMTP id nu7so802203obb.23
        for <linux-bcache@vger.kernel.org>; Wed, 09 Jul 2014 11:19:49 -0700 (PDT)
In-Reply-To: <CAHnuAeyD2RJh+DNbBfRq4XtdsYKHGRv0kEa8yfTb+FX61Ln8kw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Daniel Smedegaard Buus <danielbuus@gmail.com>
Cc: Peter Kieser <peter@kieser.ca>, linux-bcache@vger.kernel.org

I sent two patches to fix the writeback thread -- if you apply both of
them, everything should work fine.

On Wed, Jul 9, 2014 at 11:02 AM, Daniel Smedegaard Buus
<danielbuus@gmail.com> wrote:
> On Wed, Jul 9, 2014 at 5:53 PM, Peter Kieser <peter@kieser.ca> wrote:
>>
>> What other bugs did it introduce?
>>
>
> Well, the one mentioned in this thread, and the one where losing (or
> disabling? can't remember which) the cache device leaves you with a
> system that won't boot (can't find that message ATM).
>
>> -Peter
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
