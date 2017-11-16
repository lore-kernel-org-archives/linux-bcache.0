From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Regression in 4.14: wrong data being read from bcache device
Date: Thu, 16 Nov 2017 13:31:31 -0700
Message-ID: <8a3d34b9-c49f-3870-fc7f-d337f7077c32@kernel.dk>
References: <1321800569.20171116152838@pvgoran.name>
 <CAPerZE-KiYVWXtBsu+SR0wCgbSJgzZAufm+3NYdoybjq+6ySbQ@mail.gmail.com>
 <aa11e8f1-5120-9089-c1ad-43ac5057c029@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:45604 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759222AbdKPUbd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Nov 2017 15:31:33 -0500
Received: by mail-it0-f54.google.com with SMTP id l196so1520091itl.4
        for <linux-bcache@vger.kernel.org>; Thu, 16 Nov 2017 12:31:33 -0800 (PST)
In-Reply-To: <aa11e8f1-5120-9089-c1ad-43ac5057c029@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Campbell Steven <casteven@gmail.com>, Pavel Goran <via-bcache@pvgoran.name>
Cc: linux-bcache@vger.kernel.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>

On 11/16/2017 12:48 PM, Michael Lyle wrote:
> Hi Campbell & Pavel---
> 
> On 11/16/2017 11:36 AM, Campbell Steven wrote:
>> On 16 November 2017 at 21:28, Pavel Goran <via-bcache@pvgoran.name> wrote:
>>> Hello list,
>>>
>>> I encountered a severe problem when trying to switch to kernel version 4.14.
>>> In short, reads from the bcache device produce different data in 4.14 and
>>> 4.13.
> 
> Thanks for the report.  I've heard about this once on the #bcache IRC
> channel too, so it seems this is a real problem, though I've not
> encountered it in my testing yet.
> 
> This is just a note to let you all know that I'm looking at this and
> will be seeking a clean repro that's not too painful to bisect to
> determine what's going on.
> 
> Most of the 4.14 work predates my involvement on bcache, so I'm coming
> up to speed on it.  That said, it looks pretty boring/safe within
> bcache--- and where there's functional change it's almost all in the
> write path which wouldn't be relevant here.  So I'm somewhat fearful
> that there is an interaction with something else within the block layer.

The 4.14 block layer changes were pretty boring and uneventful, so that'd
be surprising as well.

I'd suggest just doing a bisect between 4.13 and 4.14, sounds like the
issue is trivially reproducible.

-- 
Jens Axboe
