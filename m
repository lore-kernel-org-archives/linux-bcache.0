From: tang.junhui@zte.com.cn
Subject: Re: kernel hangs and crashes with 4.15 (also 4.13, 4.14)
Date: Mon, 12 Feb 2018 19:29:03 +0800
Message-ID: <1518434943-6895-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:59726 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933898AbeBLL0a (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Feb 2018 06:26:30 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: bcache@mfedv.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>


Hello Matthias,

Thanks for your detail information, I will try to reproduce this issue
in my machine, but I am sorry that It would be 10 days later because the
Spring Festival holiday is comming. I also hope somebody would resolve
this problem before I am back.


> > On Mon, Feb 12, 2018 at 04:57:52PM +0800, tang.junhui@zte.com.cn wrote:
> > > From: Tang Junhui <tang.junhui@zte.com.cn>
> > > 
> > > 
> > > Hello Matthias,
> > > 
> > > What kind of caching mode do you use? Writeback or Writethrough?
> > 
> > Hi, thanks for looking into this.
> > 
> > This is with writeback caching (haven't tried writethrough yet).
> > 
> > Some more info about the disk drives used:
> > 
> > # ls -l /dev/disk/by-id  | grep -v -- -part | grep -v wwn-
> > total 0
> > lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-INTEL_SSDSC2BA200G4_BTHV7374017P200MGN -> ../../sdf
> > lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K0SHRT -> ../../sdc
> > lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K2KNK4 -> ../../sda
> > lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K5KHNS -> ../../sdb
> > lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K7212Z -> ../../sde
> > lrwxrwxrwx 1 root root  9 Feb  8 00:48 usb-Samsung_Flash_Drive_0352315110002396-0:0 -> ../../sdd
> 
> More de-obfuscation:
>    - Intel SSD DC S3710 SATA 200GB for caching
>    - WD Gold SATA 2TB for backing device
> 
> I now also tested with alternatives writethrough and with "hdparm -W 1",
> they also crash.
> 
> Perhaps more relevant: fio is started immediately after setup of md
> raid and bcache, while md sync speed is set very low:
> 
>     echo "1" >/sys/block/md127/md/sync_speed_min
>     echo "1" >/sys/block/md127/md/sync_speed_max
> 
> 
> I attached the script I use for producing the crashes, hope this helps.

Thanks.
Tang Junhui
