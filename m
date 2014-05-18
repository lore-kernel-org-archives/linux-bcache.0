From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: bcache_writebac task 100% CPU
Date: Sun, 18 May 2014 10:23:30 +0200
Message-ID: <53786E02.8060300@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:60265 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaERIXe (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 18 May 2014 04:23:34 -0400
Received: by mail-ee0-f52.google.com with SMTP id e53so2650686eek.11
        for <linux-bcache@vger.kernel.org>; Sun, 18 May 2014 01:23:32 -0700 (PDT)
Received: from home07.rolf-en-monique.lan ([31.161.100.138])
        by mx.google.com with ESMTPSA id g8sm32987782eep.0.2014.05.18.01.23.30
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 18 May 2014 01:23:31 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Sometimes bcache_writebac task consumes 100% CPU during normal operation, but after a while (like a minute) this drops to normal.

It can be triggered in a reproducable fashion on my system by:

echo 0 > /sys/block/bcache0/bcache/writeback_percent

After this bcache_writebac starts to burn CPU cycles, and it never seems to stop doing so. changing the writeback_percent value back to 25 doesn't change anything.

Apart from a busy CPU there appear to be no problem (e.g. no "task bcache_writebac:286 blocked for more than 120 seconds" messages).

I filed this issue also on: https://bugzilla.kernel.org/show_bug.cgi?id=76391

[rolf.fokkens@home07 ~]$ bcache-status  -s
--- bcache ---
UUID                        4892b3d5-fd49-4d71-adb6-d7b0a799e913
Block Size                  512 B
Bucket Size                 512.00 KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            30 GiB
Total Cache Used            2 GiB	(6%)
Total Cache Unused          28 GiB	(94%)
Evictable Cache             30 GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  31727	(99%)
Total Misses                76
Total Bypass Hits           3569	(100%)
Total Bypass Misses         0
Total Bypassed              27.5 MiB
--- Backing Device ---
   Device File               /dev/md2 (9:2)
   bcache Device File        /dev/bcache0 (252:0)
   Size                      140 GiB
   Cache Mode                writethrough [writeback] writearound none
   Readahead                 0
   Sequential Cutoff         0 B
   Merge sequential?         False
   State                     dirty
   Writeback?                True
   Dirty Data                6.1 MiB
   Total Hits                31727	(99%)
   Total Misses              76
   Total Bypass Hits         3569	(100%)
   Total Bypass Misses       0
   Total Bypassed            27.5 MiB
--- Cache Device ---
   Device File               /dev/sdd1 (8:49)
   Size                      30 GiB
   Block Size                512 B
   Bucket Size               512.00 KiB
   Replacement Policy        [lru] fifo random
   Discard?                  True
   I/O Errors                0
   Metadata Written          906.00 KiB
   Data Written              52.3 MiB
   Buckets                   61440
   Cache Used                2 GiB	(6%)
   Cache Unused              28 GiB	(94%)
[rolf.fokkens@home07 ~]$
