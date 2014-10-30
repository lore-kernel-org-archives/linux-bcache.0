From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: Is bcache dead?
Date: Thu, 30 Oct 2014 15:18:54 +0100
Message-ID: <545248CE.60202@profihost.ag>
References: <545229F8.8000502@profihost.ag>	<CACaajQsyLL0CUbPCZ1GKGA58ux6DrpzCYZb2A_31Kz+Nvz9t2w@mail.gmail.com>	<545247CA.2070101@profihost.ag> <CALJ65zkZLYdvLL9eaWzZCsJ0z87LWacKHXiMnMdYZxixPHu64A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:33668 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947AbaJ3OS4 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 30 Oct 2014 10:18:56 -0400
In-Reply-To: <CALJ65zkZLYdvLL9eaWzZCsJ0z87LWacKHXiMnMdYZxixPHu64A@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Vasiliy Tolstov <v.tolstov@selfip.ru>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>


Am 30.10.2014 um 15:15 schrieb Kent Overstreet:
> since 3.15!? shit, I don't think I saw any reports until 3.17 came out...

maybe i'm wrong. Can't guarantee but i already saw it on 3.16.X too.

> On Thu, Oct 30, 2014 at 7:14 AM, Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
>>
>> Am 30.10.2014 um 15:09 schrieb Vasiliy Tolstov:
>>> 2014-10-30 15:07 GMT+03:00 Stefan Priebe - Profihost AG <s.priebe@profihost.ag>:
>>>> Hi,
>>>>
>>>> this might be a bit aggressive - sorry for that.
>>>>
>>>> There are a lot of people having deadlocks with bcache_gc and there's no
>>>> dev looking into this since month.
>>>
>>>
>>> As i understand devs provide patches only to next versions of linux.
>>> Now i'm look at dm-cache.... (with lvm frontend lvmcache)
>>
>> no problem but this bug exists since 3.15 and is not fixed in 3.18-rc..
>>
>> Stefan
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
