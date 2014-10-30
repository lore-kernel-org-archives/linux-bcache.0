From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: Is bcache dead?
Date: Thu, 30 Oct 2014 07:15:29 -0700
Message-ID: <CALJ65zkZLYdvLL9eaWzZCsJ0z87LWacKHXiMnMdYZxixPHu64A@mail.gmail.com>
References: <545229F8.8000502@profihost.ag>
	<CACaajQsyLL0CUbPCZ1GKGA58ux6DrpzCYZb2A_31Kz+Nvz9t2w@mail.gmail.com>
	<545247CA.2070101@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:55043 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760266AbaJ3OPa (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 30 Oct 2014 10:15:30 -0400
Received: by mail-vc0-f179.google.com with SMTP id ij19so2766335vcb.38
        for <linux-bcache@vger.kernel.org>; Thu, 30 Oct 2014 07:15:29 -0700 (PDT)
In-Reply-To: <545247CA.2070101@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Vasiliy Tolstov <v.tolstov@selfip.ru>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

since 3.15!? shit, I don't think I saw any reports until 3.17 came out...

On Thu, Oct 30, 2014 at 7:14 AM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
>
> Am 30.10.2014 um 15:09 schrieb Vasiliy Tolstov:
>> 2014-10-30 15:07 GMT+03:00 Stefan Priebe - Profihost AG <s.priebe@profihost.ag>:
>>> Hi,
>>>
>>> this might be a bit aggressive - sorry for that.
>>>
>>> There are a lot of people having deadlocks with bcache_gc and there's no
>>> dev looking into this since month.
>>
>>
>> As i understand devs provide patches only to next versions of linux.
>> Now i'm look at dm-cache.... (with lvm frontend lvmcache)
>
> no problem but this bug exists since 3.15 and is not fixed in 3.18-rc..
>
> Stefan
>
