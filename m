From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: Is bcache dead?
Date: Thu, 30 Oct 2014 15:14:34 +0100
Message-ID: <545247CA.2070101@profihost.ag>
References: <545229F8.8000502@profihost.ag> <CACaajQsyLL0CUbPCZ1GKGA58ux6DrpzCYZb2A_31Kz+Nvz9t2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:33692 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbaJ3OOg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 30 Oct 2014 10:14:36 -0400
In-Reply-To: <CACaajQsyLL0CUbPCZ1GKGA58ux6DrpzCYZb2A_31Kz+Nvz9t2w@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>


Am 30.10.2014 um 15:09 schrieb Vasiliy Tolstov:
> 2014-10-30 15:07 GMT+03:00 Stefan Priebe - Profihost AG <s.priebe@profihost.ag>:
>> Hi,
>>
>> this might be a bit aggressive - sorry for that.
>>
>> There are a lot of people having deadlocks with bcache_gc and there's no
>> dev looking into this since month.
> 
> 
> As i understand devs provide patches only to next versions of linux.
> Now i'm look at dm-cache.... (with lvm frontend lvmcache)

no problem but this bug exists since 3.15 and is not fixed in 3.18-rc..

Stefan
