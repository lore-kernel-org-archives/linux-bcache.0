From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: bcache and LVM
Date: Tue, 09 Feb 2016 08:02:01 -0800
Message-ID: <87si11euti.fsf@vostro.rath.org>
References: <87k2mgo2rz.fsf@vostro.rath.org>
	<20160208144419.Horde.Ci1_2KcBCEnOa-WxsDN90oU@www3.nde.ag>
	<87r3gmrhbn.fsf@thinkpad.rath.org>
	<20160209114452.Horde.0AlUHBhWkB7dDF8j0jmv3SL@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32768 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781AbcBIQCH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 9 Feb 2016 11:02:07 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 87AEB20B6B
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 11:02:06 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 70DB4C00020
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 11:02:04 -0500 (EST)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id 2FDCD1CE40E
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 16:02:02 +0000 (UTC)
In-Reply-To: <20160209114452.Horde.0AlUHBhWkB7dDF8j0jmv3SL@www3.nde.ag>
	(Jens-U. Mozdzen's message of "Tue, 09 Feb 2016 11:44:52 +0100")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Feb 09 2016, "Jens-U. Mozdzen" <jmozdzen@nde.ag> wrote:
> Hi Nikolaus,
>
> Zitat von Nikolaus Rath <Nikolaus@rath.org>:
>> On Feb 08 2016, "Jens-U. Mozdzen" <jmozdzen@nde.ag> wrote:
>>> [...]
>>> The article itself does positively mention sub-dividing bcache devi=
ces
>>> using LVM.
>>
>> Yep, but the talk page then says:
>>
>> | Initially, LVM did not recognize my /dev/bcache0 when I wanted to
>> | create a physical volume on it. For anyone else who has that issue=
,
>> | this may be relevant:
>> | http://www.redhat.com/archives/linux-lvm/2012-March/msg00005.html.
>
> this still holds true even with LVM on OpenSUSE Leap 42.1 (which is
> what we're using ATM) - but that's no "stability issue", but rather a=
n
> installation nuisance. You only need to tell LVM to consider bcache
> devices at all, by extending /etc/lvm/lvm.conf.

Indeed. But it's also yet another slightly worrying tidbit (maybe LVM i=
s
not considering it by default for a good reason).

Also, just now someone on -btrfs advised:

| > Otherwise I'll give bcache a shot. I've avoided it so far because o=
f the
| > need to reformat and because of rumours that it doesn't work well w=
ith
| > LVM or BTRFS. But it sounds as if that's not the case..
|
| It should work fine with _just_ BTRFS, but don't put any other layers
| into the storage system like LVM or dmcrypt or mdraid, it's got some
| pretty pathological interactions with the device mapper and md
| frameworks still.


Best,
-Nikolaus

(No Cc on replies please, I'm reading the list)
--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
