From: Matthias Ferdinand <bcache@mfedv.net>
Subject: bad bcache performance - crappy SSD?
Date: Tue, 27 May 2014 00:16:49 +0200
Message-ID: <20140526221649.GI10209@teapot>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:33200 "EHLO sw.mfedv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbaEZWQ4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 26 May 2014 18:16:56 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

so far I have been unable to get an actual performance improvement out
of bcache, and I suspect that my SSD is just crap. Any help or hint
appreciated. What (SATA) SSDs have you been using successfully with
bcache?


My host system: Ubuntu 14.04 x64.
kernels tried: Ubuntu stock (3.13.0-24), 3.14, 3.15-rc{5,6}.

storage structure:
3xSATA (sda,sdb,sdc) => md raid5 (md125) => bcache0 => LVM (dm-1)

benchmark: install linux kernel header package inside kvm guest

        cache device not attached:            0:18 minutes
    SSD cache device attached (writethrough): 3:27 minutes
    SSD cache device attached (writeback):    3:25 minutes

With attached cache device, the ssd seems very busy (iostat %util),
while the raid members are not:

    Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
(5) sdc               0.00    12.33    0.00   57.33     0.00    57.00     1.99     0.06    1.07    0.00    1.07   0.79   4.53
(5) sdb               0.33    12.00    0.33   57.00     2.67    54.33     1.99     0.07    1.19    0.00    1.19   0.84   4.80
(5) sda               0.00    11.33    0.00   57.00     0.00    51.67     1.81     0.06    1.10    0.00    1.10   0.80   4.53
(*) sdf               0.00     0.00    0.00   54.67     0.00    27.17     0.99     0.98   18.05    0.00   18.05  17.95  98.13

    (5) raid 5 member;  (*) SSD


when I replace the SSD with a single SATA disk:
    SATA cache device attached (writethrough): 0:19 minutes
    SATA cache device attached (writeback):    0:13 minutes


The SSD is an Intel 530, has current firmware and plenty of DISCARDed
blocks.  Specs claim >= 13.000 incompressible writes/sec for the 120GB
model, but the above data suggests it can handle just about 60.


    === START OF INFORMATION SECTION ===
    Device Model:     INTEL SSDSC2BW120A4
    Serial Number:    CVDA3393028N1207GN
    LU WWN Device Id: 5 5cd2e4 04b82aa5a
    Firmware Version: DC32
    User Capacity:    120,034,123,776 bytes [120 GB]
    Sector Size:      512 bytes logical/physical
    Rotation Rate:    Solid State Device
    Device is:        Not in smartctl database [for details use: -P showall]
    ATA Version is:   ACS-2 (minor revision not indicated)
    SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
    Local Time is:    Sat May 24 20:37:14 2014 CEST
    SMART support is: Available - device has SMART capability.
    SMART support is: Enabled



Regards
Matthias
