From: =?UTF-8?Q?Erik_Hjelm=C3=A5s?= <erik.hjelmas@gmail.com>
Subject: congestion mechanism and reloading bcache
Date: Fri, 12 Dec 2014 09:38:25 +0100
Message-ID: <CAPgH3iHH6v3EeG0Gm3aCdT9556SdC6ECyR_bKqPnaPeOhfPA4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:53941 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbaLLIi0 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 12 Dec 2014 03:38:26 -0500
Received: by mail-ig0-f170.google.com with SMTP id r2so2197207igi.1
        for <linux-bcache@vger.kernel.org>; Fri, 12 Dec 2014 00:38:25 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache <linux-bcache@vger.kernel.org>

Sorry to bother you developers again, but Ive been working on this for
about a week now, and Im close to putting bcache into production but
there is one showstopper:

Im using Ubuntu 14.04 with mainline kernel 3.18 to have the most
recent bcache, and bcache0 has a 100GB Intel S3700 SSD as cache, and a
slow HDD-RAID as backing device.

Im fio-testing /dev/bcache0 with random writes with 16 jobs and IO
queue depth 32.

This gives me as expected ca 30K iops for about 10 minutes (filling
the cache device with 60-70GB of dirty_data) then caching suddenly
disables and iops drops to 100-200 iops (in other words writes are
going directly to the backend raid)

1. I monitor /sys/fs/bcache/<cache set>/congested and it looks like
caching disables when there is congestion (congested > 0), so Ive
tried to disable
congestion by echo 0 to the read and write thresholds but it does not
change anything (congested is then always 0 so I guess that means that
the congestion mechanism is really disabled?). Ive also tried
increasing congested_write_threshold_us but does not make a difference
either. Ive also tried to see if IOerrors are the reason (the
io_error_limit is 8), but io_errors are always 0.

2. The only way I have found of re-enabling the caching device is to
echo 1 > /sys/block/bcache0/bcache/stop
echo 1 > /sys/fs/bcache/493a2492-f900-4168-80be-f402407c2aa4/stop
modprobe -r bcache
modprobe bcache
echo /dev/sdc > /sys/fs/bcache/register
echo /dev/sdb > /sys/fs/bcache/register
As soon as I do this Im back up to 30K iops for a little while (10-50
seconds before it disables again) even if the cache device has 60-70GB
of dirty_data

I have tried to just leave it over night so that almost all dirty_data
has been written to the backing device, but writes are still only
hitting the backing device. My only fix is as mentioned in 2.

If I put this into production stopping the bcache device to fix this
is not a good option, but I really like bcache and want to use it so
any input greatly appreciated :)

/Erik

(btw, another interesting observation: enabling write-caching in the
raid-controller (P410i with 512mb cache), causes iops to drop from 30k
to ca 1k, setting the cacheratio back to 100% reads in the raid
controller brings iops back to 30k)
