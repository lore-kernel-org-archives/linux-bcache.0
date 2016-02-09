From: Nikolaus Rath <Nikolaus@rath.org>
Subject: How to use multiple backing devices
Date: Mon, 08 Feb 2016 20:47:10 -0800
Message-ID: <87oabq8p81.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42872 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054AbcBIErM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 8 Feb 2016 23:47:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id D017720BF0
	for <linux-bcache@vger.kernel.org>; Mon,  8 Feb 2016 23:47:11 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 82CDB6800D6
	for <linux-bcache@vger.kernel.org>; Mon,  8 Feb 2016 23:47:11 -0500 (EST)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id B1D1B1CD0B4
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 04:47:10 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

If I'm understanding Documentation/bcache.txt correctly, I should be
able to use one SSD to cache multiple spinning disks.

However, I'm at a loss of how to set this up in practice. I believe I
need to do

  make-bcache -B /dev/sda  # spinning rust
  make-bcache -B /dev/sdb  # spinning rust=20
  make-bcache -C /dev/sdc  # ssd

and then something like

  echo <CSET-UUID> > /sys/block/bcacheX/bcache/attach


But what do I have to put for X, and what for CSET-UUID? I believe for
at least one of those values I will have two options (because there are
two backing devices).


Thanks,
-Nikolaus

(No Cc on replies please, I'm reading the list)
--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
