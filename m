From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Testing sequential cutoff
Date: Thu, 11 Sep 2014 06:44:51 +0200
Message-ID: <541128C3.5000702@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:39998 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaIKEoz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 11 Sep 2014 00:44:55 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,

what is the correct way of testing sequential cutoff?

I've:
- writeback mode
- sequential_cutoff to 1M

I'm doning:
dd if=/dev/zero of=/dev/bcache0 oflag=direct bs=16M count=200

After that dirty value is at 2.3G and bypassed is 29M.

I tested this with 3.17-rc4 and 3.10 kernel same results.

What's wrong here?

Thanks!

Greets,
Stefan
