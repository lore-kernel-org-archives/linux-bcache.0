From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: best way to get the bdev of a bcache block device
Date: Mon, 22 Jan 2018 22:59:44 +0100
Message-ID: <3f40cbd2-46cd-d3d5-f43d-3e305da8ca6b@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:35427 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750892AbeAVV7q (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Jan 2018 16:59:46 -0500
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hello,

what's the best way to get the correct bcache backing device (bdev) form
a known dev (f.e. /dev/bcache2)?

I haven't found an easy reliable way through /sys/block.

Thanks!

Greets,
Stefan
