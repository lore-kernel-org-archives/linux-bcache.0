From: Thierry De Leeuw <thierry@de-leeuw.org>
Subject: Re: bcache using in case of 5 hdd disks
Date: Tue, 28 Jan 2014 14:56:07 +0100
Message-ID: <52E7B6F7.2030009@de-leeuw.org>
References: <CACaajQvHG=Y-ZywBYi6sNbxEDb1wXOWYLsLJGyNLSL84PYHgxQ@mail.gmail.com> <c25cf68c80584a4a80e6adf3395738b9@navex1.navixia.local> <CF0D5CD2.128C0%rolf@rolffokkens.nl> <CACaajQuXsapq1Vn1jrGK1qZ8HKgW0mRb5vmEqgwKmUHga=1i6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relaygateway02.edpnet.net ([212.71.1.211]:44989 "EHLO
	relaygateway02.edpnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaA1N4K (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 08:56:10 -0500
In-Reply-To: <CACaajQuXsapq1Vn1jrGK1qZ8HKgW0mRb5vmEqgwKmUHga=1i6Q@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,

The documentation at 
http://evilpiepirate.org/git/linux-bcache.git/plain/Documentation/bcache.txt?h=bcache-dev 
explains how to do it.

Look at the "Getting started" and "ATTACHING" section.

Bottom line to create one cache (sdc) and 2 backing (sda and sdb) 
devices, use

make-bcache -B /dev/sda /dev/sdb -C /dev/sdc


Best regards

Thierry


On 01/28/2014 01:31 PM, Vasiliy Tolstov wrote:
> 2014-01-28 Rolf Fokkens<rolf@rolffokkens.nl>
>> Op 27/01/14 21:38 schreef Patrick Zwahlen<paz@navixia.com>:
>>
>>> My understanding is that a single "cacheset" (in your case, your SSD) can
>>> be
>>> shared between multiple backing devices.
>>>
>>> You should be able to attach a single cacheset's UUID to multiple devices.
>>>
>>> Can anyone else confirm ?
>> Yep, confirmed!
>>
>> Rolf
> Can you explain for me how can i do that?
>
>
