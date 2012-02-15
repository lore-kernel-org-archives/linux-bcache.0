From: Franco <franco-uJ2R6605E/fKnmoGZ802fQ@public.gmane.org>
Subject: Can't resgister cache
Date: Wed, 15 Feb 2012 13:26:28 +0800
Message-ID: <1329283588.3289.294.camel@ipcus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi

I was in the process of testing linux-bcache but was seeing some strange
behaviour so I thought I would remount my cached filesystem. I then
noticed that the performance results started looking like the cache just
wasn't there, so I unregistered it:

bcache: Cache set be008612-38aa-4082-9f42-1bada25cb002 unregistered
bcache: Caching disabled for sdc

but now when I try to register it again, I get bcache: error
opening /dev/sdb: device busy.

I haven't tried rebooting yet but probably will do after I've sent this
message.

These were the strange results I was getting that prompted me to unmount
and remount the filesystems.

Setup: hardware RAID 5 16 disk array with 2 partitions, 1 Intel 40GB SSD
for bcache.

Filesystem            Size  Used Avail Use% Mounted on
/dev/bcache0          1.9T   26G  1.8T   2% /data33
/dev/sdd              1.9T   23G  1.8T   2% /data34

Wrote an 8GB file to each filesystem, then tried reading it back.
Machine has 8GB RAM.

Speed for random reads from identical SSD = 181.766523 MB/Sec, random
read test done in the following order with measured speed in MB/Sec. The
random IO is actually just reading with a 4GB stride, wrapping around at
the end of the file.

/data33 49
/data34 114
/data33 114
/data33 and /data44 simultaneously 78 and 59 respectively
/data33 76
/data33 68
/data34 114
/data34 96
/data34 69
/data34 74
/data33 118
/data33 40
/data34 91

After remounting both filesystems:

/data34 148
/data33 120
/data34 120
/data33 82


After unregistering the cache

/data33 65
/data34 83
/data33 99
/data34 113

Cheers,
Franco
