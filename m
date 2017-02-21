From: shiva rkreddy <shiva.rkreddy@gmail.com>
Subject: Drop in Iops with fsync when using NVMe as cache
Date: Tue, 21 Feb 2017 10:48:06 -0600
Message-ID: <CAPntomBf8c6TFBLM5iBuX=OWmfQ-uGCUiDdJnXEn1+-gS7KJaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34227 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753551AbdBUQsH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Feb 2017 11:48:07 -0500
Received: by mail-yw0-f174.google.com with SMTP id w75so66879293ywg.1
        for <linux-bcache@vger.kernel.org>; Tue, 21 Feb 2017 08:48:07 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Kernel version: 4.4.0-62

Backing Devices: Segate Enterprise 7.2K rpm 2TB SAS (ST2000NX0433)

Cache Device: Intel DC P3700 NVMe 1.6TB

bcache cache mode: writeback

# make-bcache --block 4k  --bucket 2M  -B /dev/sdb  -C /dev/nvme0n1p2


Created backing and cache devices with above command. I was expecting
very high number of iops with and without fsync option of fio.


fio command without fsync:

# fio -filename=/dev/bcache0 -direct=1 -ioengine=libaio -rw=randwrite
-bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based

iops : 35k

fio command with fsync:

fio -filename=/dev/bcache0 -direct=1 -ioengine=libaio -rw=randwrite
-bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based -fsync=1

iops: 8.1k

Attempted following combinations and saw same results:

1. block size 512,4k bucket, 512k, 2M, 4M for bcache devices
2. fio -rw option of write also showed similar results.
3. bcache writeback_percent 10 or 50; sequential_cutoff: 64M ; read_ahead_kb: 4k
4. Captured blktrace for a single io and that didn't show anything interes

I'm quite surprised by the drop in iops with fsync turned on. Is this
expected or am I missing some basic setting?
Appreciate any help !.
Thanks,
Shiva
