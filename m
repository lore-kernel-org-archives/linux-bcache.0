From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: kernel hangs and crashes with 4.15 (also 4.13, 4.14)
Date: Mon, 12 Feb 2018 10:41:05 +0100
Message-ID: <20180212094105.gm5x7njjlaqsnrmi@xoff>
References: <1518425872-1779-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41561 "EHLO sw.mfedv.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753849AbeBLJlK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Feb 2018 04:41:10 -0500
Content-Disposition: inline
In-Reply-To: <1518425872-1779-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org

On Mon, Feb 12, 2018 at 04:57:52PM +0800, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> 
> Hello Matthias,
> 
> What kind of caching mode do you use? Writeback or Writethrough?

Hi, thanks for looking into this.

This is with writeback caching (haven't tried writethrough yet).

Some more info about the disk drives used:

# ls -l /dev/disk/by-id  | grep -v -- -part | grep -v wwn-
total 0
lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-INTEL_SSDSC2BA200G4_BTHV7374017P200MGN -> ../../sdf
lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K0SHRT -> ../../sdc
lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K2KNK4 -> ../../sda
lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K5KHNS -> ../../sdb
lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K7212Z -> ../../sde
lrwxrwxrwx 1 root root  9 Feb  8 00:48 usb-Samsung_Flash_Drive_0352315110002396-0:0 -> ../../sdd


with drive writeback cache disabled (hdparm -W 0 /dev/sdx).

The flash drive only contains the OS (Ubuntu 14.04) and is not otherwise
involved in the benchmark (it is a really slow device:-)

Caching device is a 15GB partition on the SSD (/dev/sdf1), backing
device is an md raid built from a 32GB partition on each of the HDDs.

Regards
Matthias Ferdinand
