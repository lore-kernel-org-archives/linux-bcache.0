From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: bcache using in case of 5 hdd disks
Date: Tue, 28 Jan 2014 15:25:29 +0100
Message-ID: <CF0D7B16.12929%rolf@rolffokkens.nl>
References: <CACaajQvHG=Y-ZywBYi6sNbxEDb1wXOWYLsLJGyNLSL84PYHgxQ@mail.gmail.com>
 <c25cf68c80584a4a80e6adf3395738b9@navex1.navixia.local>
 <CF0D5CD2.128C0%rolf@rolffokkens.nl>
 <CACaajQuXsapq1Vn1jrGK1qZ8HKgW0mRb5vmEqgwKmUHga=1i6Q@mail.gmail.com>
 <52E7B6F7.2030009@de-leeuw.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64920 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaA1OZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 09:25:38 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so264633eei.26
        for <linux-bcache@vger.kernel.org>; Tue, 28 Jan 2014 06:25:37 -0800 (PST)
In-Reply-To: <52E7B6F7.2030009@de-leeuw.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,

Op 28/01/14 14:56 schreef Thierry De Leeuw <thierry@de-leeuw.org>:

>The documentation at
>http://evilpiepirate.org/git/linux-bcache.git/plain/Documentation/bcac=
he.t
>xt?h=3Dbcache-dev=20
>explains how to do it.
>
>Look at the "Getting started" and "ATTACHING" section.
>
>Bottom line to create one cache (sdc) and 2 backing (sda and sdb)
>devices, use
>
>make-bcache -B /dev/sda /dev/sdb -C /dev/sdc

And (from the same documentation) if you=B9ve created (make-bcache) and
registered the caching and backing devices separately, you can attach t=
hem
like this:

echo <CSET-UUID> > /sys/block/bcache0/bcache/attach

echo <CSET-UUID> > /sys/block/bcache1/bcache/attach


Assuming that /dev/sda and /dev/sdb have shown up as /dev/bcache0 and
/dev/bcache1 as their bcached counterparts after registering, and
<CSET-UUID> being the UUID of the cache device to be found in
/sys/fs/bcache.

Rolf

>
>
>Best regards
>
>Thierry
>
>
>On 01/28/2014 01:31 PM, Vasiliy Tolstov wrote:
>> 2014-01-28 Rolf Fokkens<rolf@rolffokkens.nl>
>>> Op 27/01/14 21:38 schreef Patrick Zwahlen<paz@navixia.com>:
>>>
>>>> My understanding is that a single "cacheset" (in your case, your S=
SD)
>>>>can
>>>> be
>>>> shared between multiple backing devices.
>>>>
>>>> You should be able to attach a single cacheset's UUID to multiple
>>>>devices.
>>>>
>>>> Can anyone else confirm ?
>>> Yep, confirmed!
>>>
>>> Rolf
>> Can you explain for me how can i do that?
>>
>>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-bcache=
" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
