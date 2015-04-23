From: "Deyoung Hong (dhong)" <dhong@micron.com>
Subject: Bcache performance results
Date: Thu, 23 Apr 2015 21:56:46 +0000
Message-ID: <4A59B28B702BB945AD3A70E3D7389706629F93F1@NTXBOIMBX06.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:63610 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbbDWV4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 23 Apr 2015 17:56:50 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>

Hello,

I got your contact info on http://bcache.evilpiepirate.org.

I'm an engineer at Micron and I'm doing some basic benchmark testing with a fast SSD using bcache, and I got some performance numbers.  I wonder if these numbers make sense to you.  They seem to be a bit lower than I would expect.

Please let me know if you want more data regarding my bcache setup, or if you don't care to (so I won't bother again).

==============================================================================
System:  Dell T620, 24 cores, 32GB, CentOS 7 (kernel 3.14.37)
Configuration:  HDD partition size 400GG, SSD partition size 100GB (relatively large cache)

# fio 2.1.10, randrw 77/23, qdepth 32, runtime 3600 secs
         HDD        SSD         %diff     bcache    %hit    %gain
         ========   =========   =======   =======   =====   ======
Read:	   877        54,557      6120.87	1,914    5.61    118.24
Write:   292        18,188      6128.77   638              118.49
         (iosp) (iops)              (iops)


# mysql sysbench oltp, 32 threads, database size 250GB, runtime 3600 secs
         HDD        SSD         %diff     bcache    %hit    %gain
         ========   =========   =======   =======   =====   ======
rwps:    2,031.88   34,669.11   1606.26   3,066.26  19.65   50.91
tps:     112.88     1,926.06    1606.29%  170.35            50.91


# mysql sysbench oltp, 32 threads, database size 250GB, runtime 36000 secs (10 hours)
         HDD        SSD         %diff     bcache    %hit    %gain
         ========   =========   =======   ========  =====   ======
rwps:    1,799.54   30,346.50   1586.35   1,862.07  31.50   3.47
tps:     99.97      1,685.92    1586.43   103.45            3.48
=============================================================================

Thank you in advance for any feedback.

Deyoung Hong
Linux Engineer
