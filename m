From: Vivek Dasmohapatra <vivek@collabora.co.uk>
Subject: Re: enable bcache in kernel?
Date: Tue, 19 Aug 2014 10:48:39 +0100 (BST)
Message-ID: <alpine.DEB.2.02.1408191044300.10407@noise.cbg.collabora.co.uk>
References: <f0bf813a979381c1eb202655b1c55299@localhost>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-777320272-1408441721=:10407"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42250 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaHSJsn (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 19 Aug 2014 05:48:43 -0400
In-Reply-To: <f0bf813a979381c1eb202655b1c55299@localhost>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-777320272-1408441721=:10407
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 18 Aug 2014, Stan Hoeppner wrote:

>
> Is bcache available in 3.4.103?

I believe it went in around 3.10 but I wouldn't use it for anything
in production until at least 3.12.x

> Regardless of the answer to the above, how is bcache enabled in the
> kernel?  .config?  Doc reference please.  The bcache website simply says
> "now in mainline" without stating the source filename or anything actually
> helpful about including it in a custom kernel.

From `make menuconfig'

   │ Symbol: BCACHE [=m]                                                     │
   │ Type  : tristate                                                        │
   │ Prompt: Block device as cache                                           │
   │   Location:                                                             │
   │     -> Device Drivers                                                   │
   │ (1)   -> Multiple devices driver support (RAID and LVM) (MD [=y])       │
   │   Defined at drivers/md/bcache/Kconfig:2                                │
   │   Depends on: MD [=y]                                                   │


--8323329-777320272-1408441721=:10407--
