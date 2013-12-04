From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Subject: Using bcache to save power -- safe?
Date: Wed, 4 Dec 2013 15:59:12 +0100
Message-ID: <CAA-O0Xh0p1ERoR_QDrzj3T_5b-G63fnW+ykLqmu8L=_A3m5p8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:63757 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab3LDO7N (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 4 Dec 2013 09:59:13 -0500
Received: by mail-ve0-f180.google.com with SMTP id jz11so12335177veb.11
        for <linux-bcache@vger.kernel.org>; Wed, 04 Dec 2013 06:59:12 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Good afternoon!

My question: Can I leave writeback_running=0, or will it hurt my data?

Background:

I've started using bcache on my NAS array and must say it is working
out quite well. My goals were energy/noise savings and performance.
These appear to be met with my current configuration.

backing device: RAID5 array on 4x WD green drives
cache device: RAID1 array on 2x SanDisk SSDs
LVM on top of bcache0
WD drives set to spin down after 10 minutes idle
linux 3.12

writeback_percent = 25
sequential_cutoff = 0
congested_*_threshold_us = 0
writeback_running = 0

... with these settings my server can happily continue running its
periodic tasks (smartd, cacti, syslog, dvb, samba, ntp, etc) without
spinning up the disks. All periodic data gets stored to the energy
saving (and silent) SSDs. Great!

My concern is what will happen if some huge burst of IO comes and
overwhelms my cache drive. Can bcache still push data to the RAID5
when writeback_running=0? I have a daily cronjob set to re-enable
writeback_running and set cache_mode to writethrough, wait for clean,
then re-enable writeback. So, the dirty_data does not tend to get too
high. However, there could be some day where a ton of data gets
written.

Is near-permanent writeback_running=0 safe?

Thanks!

PS. Obviously I am interested in the progress of RAID5-aware bcache
and multiple SSDs per cache set, since both would directly benefit my
setup. So I am pretty happy with the direction bcache is heading!
