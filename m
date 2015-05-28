From: jdd <jdd@dodin.org>
Subject: Re: reading an ex linux bcache disk
Date: Thu, 28 May 2015 12:01:42 +0200
Message-ID: <5566E786.2000805@dodin.org>
References: <5566BEE5.4020108@dodin.org> <322068851.20150528150913@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:20733 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbbE1KBq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 28 May 2015 06:01:46 -0400
Received: from [192.168.0.22] (unknown [82.228.87.93])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 5AD8CD48054
	for <linux-bcache@vger.kernel.org>; Thu, 28 May 2015 11:57:18 +0200 (CEST)
In-Reply-To: <322068851.20150528150913@pvgoran.name>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Le 28/05/2015 11:09, Pavel Goran a =E9crit :

got it!

> echo 1 > /sys/block/sda/sda3/bcache/running

was the key :-)! thanks!

the manual says:

"make-bcache has the ability to format multiple devices at the same tim=
e"

but then:

To get started:

   mkfs.ext4 /dev/bcache0

so the word "format" is not used always with the same meaning (for me,=20
formatting is creating a file system).

gladfully, make-bcache do *not* format the partition :-)

What I did:

* install a new system elsewhere (same distro I used with bcache).=20
kernel 3.16.7
install bcache-tools

make-bcache -B /dev/sda8 (the old bcache backing)

tried to find /sys/block/sda/bcache, but it do not exist. Your example=20
made me think the manual lacked a level, it have to be=20
sys/block/sda/sda8/bcache

echo 1 > /sys/block/sda/sda3/bcache/running

and then /dev/bcache0 shows up!

mount /dev/bcache0 /mnt allows me to access the files on the partition

so good, thanks!
jdd
