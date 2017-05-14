From: =?utf-8?B?5pyx6I+B?= <zhujing@ecloudtech.com.cn>
Subject: a strange bcache0 100% busy with no IO rw and no cpu consumption
Date: Sun, 14 May 2017 11:20:59 +0800
Message-ID: <002a01d2cc61$1c249820$546dc860$@ecloudtech.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:47136 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754104AbdENDUv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 13 May 2017 23:20:51 -0400
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: qlg@ecloudtech.com.cn

Hi,all

[root@scst-test bcache]# lsblk
NAME                     MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
dfa                      250:0    0   1.1T  0 disk 
└─dfa1                   250:1    0   1.1T  0 part 
  └─bcache0              249:0    0  21.8T  0 disk 
    ├─vg_bcache0-fc_vol3 253:3    0     4T  0 lvm  
    ├─vg_bcache0-fc_vol4 253:4    0     4T  0 lvm  
    ├─vg_bcache0-fc_vol5 253:5    0     4T  0 lvm  
    └─vg_bcache0-fc_vol6 253:6    0     4T  0 lvm  
sda                        8:0    0 557.8G  0 disk 
├─sda1                     8:1    0     1G  0 part /boot
└─sda2                     8:2    0 556.8G  0 part 
  ├─cl-root              253:0    0    50G  0 lvm  /
  ├─cl-swap              253:1    0     4G  0 lvm  [SWAP]
  └─cl-home              253:2    0 502.8G  0 lvm  /home
sdb                        8:16   0  21.8T  0 disk 
└─sdb1                     8:17   0  21.8T  0 part 
  └─bcache0              249:0    0  21.8T  0 disk 
    ├─vg_bcache0-fc_vol3 253:3    0     4T  0 lvm  
    ├─vg_bcache0-fc_vol4 253:4    0     4T  0 lvm  
    ├─vg_bcache0-fc_vol5 253:5    0     4T  0 lvm  
    └─vg_bcache0-fc_vol6 253:6    0     4T  0 lvm  

[root@scst-test bcache]# modinfo  bcache
filename:       /lib/modules/4.4.65-1.el7.elrepo.x86_64/kernel/drivers/md/bcache/bcache.ko
license:        GPL
author:         Kent Overstreet <koverstreet@google.com>
author:         Kent Overstreet <kent.overstreet@gmail.com>
license:        GPL
srcversion:     391A0B3836FE95B29F75289
depends:        
intree:         Y
vermagic:       4.4.65-1.el7.elrepo.x86_64 SMP mod_unload modversions 

my testing case:
node1: stor-node, running scst target with bcache ( 1.2T pcie-ssd  cache device, 21T lsi raid10 lun backing device)
node2: esxi-node, running FIO testing in a VM(rhel6.5)

at first i have done about 100T 128k randwrite benchmarking on bcache0 device

[root@localhost ~]# cat myfio.sh 
i=0
while [ $i -le 99 ]
do
        fio --filename=/dev/sdb --rw=randwrite --bs=128k  --ioengine=libaio --iodepth=16 --randrepeat=0 --refill_buffers --norandommap --size=1024G  -name=test --numjobs=1
        sleep 5
        let i=i+1
done

then stop all application,clean all dirty_data,set cache_mode to none, set writeback_runing to 0.
and then checking sysfs state. 

[root@scst-test bcache]# service scst stop
[root@scst-test bcache]# cat dirty_data 
0
[root@scst-test bcache]# cat state
clean
[root@scst-test bcache]# cat writeback_percent 
0
[root@scst-test bcache]# cat writeback_running 
1
[root@scst-test bcache]# echo 0 > writeback_running 
[root@scst-test bcache]# cat writeback_running 
0
[root@scst-test bcache]# cat cache_mode 
writethrough writeback writearound [none]

<<<At the same time  

[root@scst-test cache0]# cat priority_stats 
Unused:         66%
Clean:          0%
Dirty:          26% <<<<<< im doubt here , as already shown above ,cachedev was clean and no dirty_data 
Metadata:       0%
Average:        267
Sectors per Q:  24295296
Quantiles:      [3 7 7 13 25 36 48 59 71 83 95 106 118 130 142 154 165 177 190 204 217 230 243 261 280 298 324 347 381 426 531]

at last , the iostat shown bcache0 100% busy and too many avgqu-sz 

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
bcache0           0.00     0.00    0.00    0.00     0.00     0.00     0.00 1227360.00    0.00    0.00    0.00   0.00 100.00

vmstat showing there is no cpu consumption,no io wait

[root@scst-test b0bc3e56-530b-4541-b73d-30007d1e6709]# vmstat 1
--------------------------------------+
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
0  0      0 243501152    976 710832    0    0     2 17246    2    2  0  3 97  0  0
0  0      0 243501152    976 710848    0    0     0     0   47  138  0  0 100  0  0
0  0      0 243501296    976 710848    0    0     0     0  107  110  0  0 100  0  0
0  0      0 243501312    976 710848    0    0     1     0   57  109  0  0 100  0  0
0  0      0 243501312    976 710848    0    0     0     0  104  110  0  0 100  0  0
0  0      0 243501312    976 710848    0    0     0     0   31   82  0  0 100  0  0


it's iostat bug or something else im wrong ?

p.s  it will be fine if i reboot system.

Thx for your reply !

Jing.zhu
