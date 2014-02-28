From: Vivek Dasmohapatra <vivek@collabora.co.uk>
Subject: Re: bcache deadlock with /dev/ramX + partition
Date: Fri, 28 Feb 2014 19:06:32 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1402281902090.17442@noise.cbg.collabora.co.uk>
References: <alpine.DEB.2.02.1402201818410.14562@noise.cbg.collabora.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48147 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaB1TGh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 28 Feb 2014 14:06:37 -0500
In-Reply-To: <alpine.DEB.2.02.1402201818410.14562@noise.cbg.collabora.co.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Thu, 20 Feb 2014, Vivek Dasmohapatra wrote:

Update: Found an offset for sda11 which does not deadlock:

Deadlocking configurations:

   backing: sda11;  default offset from sda (NOT a multiple of 4 KiB)
   backing: sdb1;   default offset from sdb (!= 4 KiB)
   backing: sda11;  offset from sda is:
                    - a multiple of 4  KiB
                    - a multiple of 4  MiB
                    - a multplie of 16 MiB

Non-deadlocking configurations:

   backing: sdb
   backing: sdb1;   offset from start of sdb is 4096 B
   backing: sda11;  offset from start of sda is 78486397440 B
                    (153293745 sectors)
                    for reference, sda1's offset is 1048576 B (2048 sectors)
