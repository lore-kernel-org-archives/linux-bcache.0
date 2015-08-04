From: "A. James Lewis" <james@fsck.co.uk>
Subject: layering question.
Date: Tue, 04 Aug 2015 17:20:15 +0100
Message-ID: <55C0E63F.2030007@fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dozer.fsck.co.uk ([77.246.163.77]:45478 "EHLO dozer.fsck.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbbHDQ3j (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 4 Aug 2015 12:29:39 -0400
Received: from dozer.fsck.co.uk (localhost.localdomain [127.0.0.1])
	by dozer.fsck.co.uk (Postfix) with ESMTP id 31D53610014
	for <linux-bcache@vger.kernel.org>; Tue,  4 Aug 2015 17:33:19 +0100 (BST)
Received: from [192.168.0.20] (80-46-130-192.static.dsl.as9105.com [80.46.130.192])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by dozer.fsck.co.uk (Postfix) with ESMTPSA id 03BEB610001
	for <linux-bcache@vger.kernel.org>; Tue,  4 Aug 2015 17:33:18 +0100 (BST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all...

I've heard rumours that layering bcache with other block device drivers 
might not be recommended... I wonder what the truth really is... perhaps 
someone can advise.

I was planning to use 2 SSD's... combined with 4 large spinning drives 
to create a large filesystem with BTRFS...  my questions are as follows.

1. Is there a way to use 2 SSD's directly, or would it be OK to use MD 
to stripe them?... then used the MD array as the cache device?

2. I would be using BTRFS, so would it be better to create 4 separate 
bcache devices each attached to the single cache device, and then use 
BTRFS to raid 4 bcache devices... obviously this would be more flexible, 
or would I need to make an MD raid of the 4 devices, and then use that 
to create a single bcache device and build a BTRFS filesystem on top of 
that.

Hope that's clear, any clarification would be appreciated...

Also, there's talk about a pending on-disk cache format change some time 
around 3.19, but no details... is this over with, or still pending?

James
