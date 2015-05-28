From: jdd <jdd@dodin.org>
Subject: Re: reading an ex linux bcache disk
Date: Thu, 28 May 2015 11:24:34 +0200
Message-ID: <5566DED2.1050103@dodin.org>
References: <5566BEE5.4020108@dodin.org> <322068851.20150528150913@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:20296 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbbE1JYh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 28 May 2015 05:24:37 -0400
Received: from [192.168.0.22] (unknown [82.228.87.93])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 07C40D4808A
	for <linux-bcache@vger.kernel.org>; Thu, 28 May 2015 11:20:09 +0200 (CEST)
In-Reply-To: <322068851.20150528150913@pvgoran.name>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Le 28/05/2015 11:09, Pavel Goran a =E9crit :

> You  can  access  the  contents  of  the  bcache  volume without usin=
g a cache
> partition  at all. All you'll need is a kernel that supports bcache a=
nd one or
> two  commands  from  the  terminal.

good, because I can't ake the install of bcahe work with the old disk :=
-(

  I don't have time to go into details, but
> probably it will be something like:
>
> echo 1 > /sys/block/sda/sda3/bcache/running
>
> (Taken  from https://wiki.archlinux.org/index.php/Bcache, you may wan=
t to look
> there   or  at  https://www.kernel.org/doc/Documentation/bcache.txt  =
for  more
> information.)

I will read this now
thanks
jdd
