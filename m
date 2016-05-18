From: Vlad <vovan@vovan.nl>
Subject: block size question
Date: Wed, 18 May 2016 07:50:43 +0200
Message-ID: <573C02B3.5010501@net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp-3.concepts.nl ([213.197.30.127]:33658 "EHLO
	smtp-3.concepts.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbcERFvZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 May 2016 01:51:25 -0400
Received: from [77.174.73.212] (helo=srv2.net.home)
	by smtp-3.concepts.nl with esmtp (Exim 4.80.1)
	(envelope-from <vovan@vovan.nl>)
	id 1b2uO3-0006Pu-Rd
	for linux-bcache@vger.kernel.org; Wed, 18 May 2016 07:51:15 +0200
Received: from localhost (localhost [127.0.0.1])
	by srv2.net.home (Postfix) with ESMTP id D480C755CF7
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 07:50:44 +0200 (CEST)
Received: from srv2.net.home ([127.0.0.1])
	by localhost (webmail.net.home [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id AgexKWn_Mddy for <linux-bcache@vger.kernel.org>;
	Wed, 18 May 2016 07:50:44 +0200 (CEST)
Received: from [192.168.1.2] (vovan.net.home [192.168.1.2])
	(Authenticated sender: vovan)
	by srv2.net.home (Postfix) with ESMTPSA id 6E05E755CF1
	for <linux-bcache@vger.kernel.org>; Wed, 18 May 2016 07:50:44 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hallo,

What would be the optimal block size in case if physical block sizes
different for cache and backing devices? Can I use different block sizes
for cache and backing devices, like:
make-bcache --block 4k -B /dev/sdc
make-bcache --block 512 -C /dev/sda

I have a feeling that the block size should be the same and the biggest
block size should be used, but I'd appreciate any thoughts about that.

Thanks in advance,
Vlad.
