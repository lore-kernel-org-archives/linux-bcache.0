From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: bcache and LVM
Date: Tue, 09 Feb 2016 20:09:29 -0800
Message-ID: <87mvr9tddy.fsf@vostro.rath.org>
References: <87k2mgo2rz.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55334 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658AbcBJEJa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 9 Feb 2016 23:09:30 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 7E83221A38
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 23:09:30 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 33BD26801B6
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 23:09:30 -0500 (EST)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id 482E31CF582
	for <linux-bcache@vger.kernel.org>; Wed, 10 Feb 2016 04:09:29 +0000 (UTC)
In-Reply-To: <87k2mgo2rz.fsf@vostro.rath.org> (Nikolaus Rath's message of
	"Sun, 07 Feb 2016 09:20:48 -0800")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Feb 07 2016, Nikolaus Rath <Nikolaus@rath.org> wrote:
> Hello,
>
> The internet claims that using bcache with LVM is not a good idea
> (eg. on https://wiki.archlinux.org/index.php/Bcache )- but I wasn't a=
ble
> to find any substantial information other than this general
> recommendation.
>
> Is this still (or has ever been) correct? If so, what issues can aris=
e?
> And does this happen only when using bcache on top of an LVM LV, or a=
lso
> when using a bcache device as an LVM PV?

I now have the following stack:

btrfs on LUKS on LVM on bcache

The VG contains two bcache PVs with backing devices on different
spinning disks, and a shared cache device on SSD. I'm using Kernel 4.3.

I'm super happy with the performance, boot times increased from 1:30
minutes to X11 and 2:00 to Firefox to roughly 0:10 to X11 and 0:30 to
=46irefox.

Time will tell if it also keeps my data intact, but I hope btrfs would
at least detect any corruption.=20


Best,
-Nikolaus

(No Cc on replies please, I'm reading the list)
--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
