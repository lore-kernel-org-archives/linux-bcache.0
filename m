From: Nitin Kshirsagar <nshirsagar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: (unknown)
Date: Wed, 23 Jan 2013 20:37:10 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7D0@MYMBX.MY.STEC-INC.AD>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: 
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, Sanoj Unnikrishnan <sunnikrishnan-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hello Kent,

I have setup bcache and run fio data verification test on write back an=
d write through caches.
The fio tests are passed, however I have found following issues while u=
sing bcache.

Issue1: Cache is not created as per user specified options =20
-----------------------------------------------------------------------=
---------------------------------
Steps:
1.Create cache by specifying mode writeback and cache replacement polic=
y as fifo
[root@annu bcache]# make-bcache --cache  /dev/sdc --bdev /dev/sdd  --wr=
iteback --cache_replacement_policy=3Dfifo=20
UUID:                   e25f2840-f02b-46af-81e7-28948b2737cc
Set UUID:               68da5b89-1e87-457a-80c7-2c822737f969
nbuckets:               2048
block_size:             1
bucket_size:            1024
nr_in_set:              1
nr_this_dev:            0
first_bucket:           1
UUID:                   a3ce52e6-631b-4c74-afa2-9f8b0088c7f4
Set UUID:               68da5b89-1e87-457a-80c7-2c822737f969
nbuckets:               20480
block_size:             1
bucket_size:            1024
nr_in_set:              1
nr_this_dev:            0
first_bucket:           1

[root@annu bcache]# echo /dev/sdc > /sys/fs/bcache/register
[root@annu bcache]# echo /dev/sdd > /sys/fs/bcache/register


2. Cache mode should  be "writeback" instead of "writethrough"
[root@annu bcache]# cat /sys/block/bcache2/bcache/cache_mode
[writethrough] writeback writearound none
[root@annu bcache]# cat /sys/block/bcache2/bcache/writeback_running
1

3. Cache policy should be "fifo" instead of "lru"=20
[root@annu ~]# cat /sys/block/bcache2/bcache/cache/cache0/cache_replace=
ment_policy
[lru] fifo random


Issue2: Cache dirty data value should not be negative.
-----------------------------------------------------------------------=
--------------------------------
Steps:

1.Create cache by specifying mode writeback and cache replacement polic=
y as fifo
2.To make bcache devices known to the kernel
    [root@annu bcache]# echo /dev/sdc > /sys/fs/bcache/register
    [root@annu bcache]# echo /dev/sdd > /sys/fs/bcache/register
3.Create FS on cache  /dev/bcacheN and mount in directory
4.Create Data set by using fio or dd on mount point.
5. Change cache node from "writethrough" to "writeback"   =20
    [root@annu ~]# echo writeback >  /sys/block/bcache2/bcache/cache_mo=
de
    [root@annu ~]# cat /sys/block/bcache2/bcache/cache_mode
    writethrough [writeback] writearound none
6.Check cache dirty data should not be negative value=20
   [root@annu ~]# cat /sys/block/bcache2/bcache/dirty_data
   -9.4M


--=20
Thanks & Regards

Nitin Kshirsagar
Software Engr, QA
Cell 997.566.3985

STEC india private Limited, Pune | The SSD Company TM
NASDAQ STEC =95 Web www.stec-inc.com

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED=0D
=0D
This electronic transmission, and any documents attached hereto, may co=
ntain confidential, proprietary and/or legally privileged information. =
The information is intended only for use by the recipient named above. =
If you received this electronic message in error, please notify the sen=
der and delete the electronic message. Any disclosure, copying, distrib=
ution, or use of the contents of information received in error is stric=
tly prohibited, and violators will be pursued legally.
