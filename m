From: Emmanuel Florac <eflorac@intellique.com>
Subject: realiably reproducible system freeze
Date: Tue, 18 Aug 2015 13:01:58 +0200
Message-ID: <20150818130158.683b681c@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:43912 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbbHRLKN (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 18 Aug 2015 07:10:13 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 3F537D24E0E
	for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2015 13:01:56 +0200 (CEST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp5-g21.free.fr (Postfix) with ESMTP id DB9F0D48082
	for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2015 13:01:54 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>


Hi all, I have a machine running 4.1.0-2-amd64 Debian (Stretch) and it
reliably freezes every time bcacke dirty data reaches the
writeback_percent limit (10%).

root@/sys/block/bcache0/bcache# cat writeback_percent 
10
/sys/block/bcache0/bcache# cat dirty_data 
4.7G
/sys/block/bcache0/bcache# cat writeback_percent 
10
/sys/block/bcache0/bcache# cat writeback_rate
512

The cache device is a Supertalent 64 GB SATA SSD. I had no problem with
this particular model in various configurations.

Any hints?

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------
