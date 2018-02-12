From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: kernel hangs and crashes with 4.15 (also 4.13, 4.14)
Date: Mon, 12 Feb 2018 11:55:05 +0100
Message-ID: <20180212105505.yjslxpfdhm5bnh2r@xoff>
References: <1518425872-1779-1-git-send-email-tang.junhui@zte.com.cn>
 <20180212094105.gm5x7njjlaqsnrmi@xoff>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rf6pcmdzmwvh7vcl"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41562 "EHLO sw.mfedv.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754022AbeBLKzK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Feb 2018 05:55:10 -0500
Content-Disposition: inline
In-Reply-To: <20180212094105.gm5x7njjlaqsnrmi@xoff>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org


--rf6pcmdzmwvh7vcl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Feb 12, 2018 at 10:41:05AM +0100, Matthias Ferdinand wrote:
> On Mon, Feb 12, 2018 at 04:57:52PM +0800, tang.junhui@zte.com.cn wrote:
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> > 
> > 
> > Hello Matthias,
> > 
> > What kind of caching mode do you use? Writeback or Writethrough?
> 
> Hi, thanks for looking into this.
> 
> This is with writeback caching (haven't tried writethrough yet).
> 
> Some more info about the disk drives used:
> 
> # ls -l /dev/disk/by-id  | grep -v -- -part | grep -v wwn-
> total 0
> lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-INTEL_SSDSC2BA200G4_BTHV7374017P200MGN -> ../../sdf
> lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K0SHRT -> ../../sdc
> lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K2KNK4 -> ../../sda
> lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K5KHNS -> ../../sdb
> lrwxrwxrwx 1 root root  9 Feb  8 00:48 ata-WDC_WD2005FBYZ-01YCBB2_WD-WMC6N0K7212Z -> ../../sde
> lrwxrwxrwx 1 root root  9 Feb  8 00:48 usb-Samsung_Flash_Drive_0352315110002396-0:0 -> ../../sdd

More de-obfuscation:
   - Intel SSD DC S3710 SATA 200GB for caching
   - WD Gold SATA 2TB for backing device

I now also tested with alternatives writethrough and with "hdparm -W 1",
they also crash.

Perhaps more relevant: fio is started immediately after setup of md
raid and bcache, while md sync speed is set very low:

    echo "1" >/sys/block/md127/md/sync_speed_min
    echo "1" >/sys/block/md127/md/sync_speed_max


I attached the script I use for producing the crashes, hope this helps.

Regards
Matthias Ferdinand

--rf6pcmdzmwvh7vcl
Content-Type: application/x-sh
Content-Disposition: attachment; filename="crash-with-fio.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh -x=0A=0Acache_dev=3D`lsblk | awk '$4=3D=3D"186.3G" { print "/dev/=
"$1"1"; }'`=0Aecho "# cache_dev=3D${cache_dev}"=0Araid_members=3D`lsblk | a=
wk '$4=3D=3D"1.8T" { print "/dev/"$1"1"; }'`=0Aecho "# raid_members=3D${rai=
d_members}"=0Adisks=3D`lsblk | awk '$4=3D=3D"186.3G" || $4=3D=3D"1.8T" { pr=
int "/dev/"$1; }'`=0Aecho "# disks=3D${disks}"=0A=0Aread -p "RETURN to cont=
inue:" bla=0A=0Afor d in ${disks}; do hdparm -W 0 $d; done=0A#for d in ${di=
sks}; do hdparm -W 1 $d; done=0A=0Amdadm --create /dev/md127 --level=3Draid=
5 --chunk=3D512 --raid-devices=3D4 ${raid_members}=0A#mdadm --create /dev/m=
d127 --level=3Draid10 --chunk=3D512 --raid-devices=3D4 ${raid_members}=0Asl=
eep 3; udevadm settle=0Aecho "1" >/sys/block/md127/md/sync_speed_min=0Aecho=
 "1" >/sys/block/md127/md/sync_speed_max=0Asleep 1; udevadm settle=0A=0A#ma=
ke-bcache --data_offset 2048 --wipe-bcache -w 4k -C ${cache_dev} -B /dev/md=
127=0A#make-bcache --data_offset 2048 --wipe-bcache -w 2k -C ${cache_dev} -=
B /dev/md127=0A#make-bcache --data_offset 2048 --wipe-bcache -w 1k -C ${cac=
he_dev} -B /dev/md127=0A#make-bcache --data_offset 2048 --wipe-bcache -w 51=
2 -C ${cache_dev} -B /dev/md127=0A#make-bcache --data_offset 2048 --wipe-bc=
ache -C ${cache_dev} -B /dev/md127=0Amake-bcache --wipe-bcache -C ${cache_d=
ev} -B /dev/md127=0A=0Asleep 3; udevadm settle=0Aecho "${cache_dev}" >/sys/=
fs/bcache/register  # sometimes needs explicit register=0Asleep 3; udevadm =
settle=0Aecho 'writeback' > /sys/block/md127/bcache/cache_mode=0A#echo 'wri=
tethrough' > /sys/block/md127/bcache/cache_mode=0Asleep 3; udevadm settle=
=0A=0A=0Afor n in $(seq 1 8); do=0A    fio --filename=3D/dev/bcache0 --dire=
ct=3D1 --sync=3D1 --rw=3Dwrite --bs=3D4k --numjobs=3D${n} --iodepth=3D1 --r=
untime=3D30 --time_based --group_reporting --name=3Djournal-test=0Adone=0A
--rf6pcmdzmwvh7vcl--
