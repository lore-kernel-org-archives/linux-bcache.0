From: jdd <jdd@dodin.org>
Subject: reading an ex linux bcache disk
Date: Thu, 28 May 2015 09:08:21 +0200
Message-ID: <5566BEE5.4020108@dodin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:42832 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbE1HI0 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 28 May 2015 03:08:26 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 210A5CDBD8D
	for <linux-bcache@vger.kernel.org>; Thu, 28 May 2015 09:08:23 +0200 (CEST)
Received: from [192.168.0.22] (unknown [82.228.87.93])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 12B67D48096
	for <linux-bcache@vger.kernel.org>; Thu, 28 May 2015 09:03:57 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I have the following problem.

I used bcache on a computer with one hard drive and one small ssd.

(openSUSE 13.2)

this computer broke, it do not boot anymore. I could only recover the 
hard drive that seems perfectly working - I can read all the partitions 
but the bcache one.

is there any way to read the bcache partition content? As far as I know, 
the computer was shut down properly (it broke because somebody walked on 
it :-).

right now this is only a theoretical question (the problem is real, but 
there is nothing important on the bcache partition), but what I read on 
the net let me think this is not a trivial thing. If the disk content 
can't be recovered, I wont anymore use bcache :-(.

right now I get a "file system unknown" when I try to mount the bcache 
partition.

thanks for your help
jdd
