From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: How to use multiple backing devices
Date: Tue, 09 Feb 2016 08:03:53 -0800
Message-ID: <87pow5euqe.fsf@vostro.rath.org>
References: <87oabq8p81.fsf@vostro.rath.org>
	<20160209083847.0cff87c6@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57686 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756619AbcBIQD6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 9 Feb 2016 11:03:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 05C3C20CC8
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 11:03:57 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id EB740C00023
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 11:03:55 -0500 (EST)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id 3B2361CE4E0
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 16:03:54 +0000 (UTC)
In-Reply-To: <20160209083847.0cff87c6@jupiter.sol.kaishome.de> (Kai Krakow's
	message of "Tue, 9 Feb 2016 08:38:47 +0100")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Feb 09 2016, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Mon, 08 Feb 2016 20:47:10 -0800
> schrieb Nikolaus Rath <Nikolaus@rath.org>:
>
>> Hello,
>>=20
>> If I'm understanding Documentation/bcache.txt correctly, I should be
>> able to use one SSD to cache multiple spinning disks.
>>=20
>> However, I'm at a loss of how to set this up in practice. I believe =
I
>> need to do
>>=20
>>   make-bcache -B /dev/sda  # spinning rust
>>   make-bcache -B /dev/sdb  # spinning rust=20
>>   make-bcache -C /dev/sdc  # ssd
>>=20
>> and then something like
>>=20
>>   echo <CSET-UUID> > /sys/block/bcacheX/bcache/attach
>>=20
>>=20
>> But what do I have to put for X, and what for CSET-UUID? I believe f=
or
>> at least one of those values I will have two options (because there
>> are two backing devices).
>
> Create it in one go:
>
> make-bcache -C /dev/sdc -B /dev/sd{a,b}
>
> It will take away the hassle. Everything should be setup now.

Yeah, but unfortunately I don't have enough space for that. I need to
create one, move the data over from second, create the second, move dat=
a
over from the SSD, and then create the SSD is caching device.


> But if you want to do it manually: you have to run "echo" twice - for
> each X (the backing devices). CSET-UUID comes from /sys/fs/bcache whe=
re
> you will find a UUID per each bcache caching device, which is just on=
e
> for your case.


Ah, ok. Intuitively attaching the same cache device to two different
backing devices sounds dangerous, but I'll  take your word that the cod=
e
is designed for that...

Thanks,
-Nikolaus

(No Cc on replies please, I'm reading the list)
--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
