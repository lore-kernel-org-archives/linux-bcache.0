From: Marcin <marcin@mejor.pl>
Subject: [bcachefs] time of mounting filesystem with high number of dirs
Date: Wed, 07 Sep 2016 22:09:58 +0200
Message-ID: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:38736 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754646AbcIGUKy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Sep 2016 16:10:54 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
I'm aware that performance doesn't have high priority, it's something 
for TODO.
I created bcachefs on ~10GB partition, copied some files and next I 
created huge number of directories and files. Problem is in the total 
time needed for mounting filesystem.
# time mount -t bcache /dev/sde1 /mnt/test/

real    12m20.880s
user    0m0.000s
sys     1m18.270s

I looked at iostat, mounting needs to read from disk 10083588 "kB_read". 
Device has size 10485760kB, so it looks that it reads almost the same 
amount of data as partition size. Maybe mount time can be lower? Maybe 
there can be less reads or reads could be more sequential?

Additional informations:
# time find /mnt/test/ -type d |wc -l
10564259

real    10m30.305s
user    1m6.080s
sys     3m43.770s

# time find /mnt/test/ -type f |wc -l
9145093

real    6m28.812s
user    1m3.940s
sys     3m46.210s

RAM: 1GB
CPU: core2duo - 1.86GHz
hdd: old disk SAS 15k
hdd controller: HP P400 with 512MB cache with battery

Marcin
