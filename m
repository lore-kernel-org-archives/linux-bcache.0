From: marcin@mejor.pl
Subject: How to create bcachefs?
Date: Fri, 19 Aug 2016 20:07:31 +0200
Message-ID: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:35772 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754103AbcHSSOZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 19 Aug 2016 14:14:25 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
I'm spamming here with simple questions because it looks that 
documentation doesn't follow current state of bcachefs.

I've upgraded bcache-tools to b0f08fc1e30daafb274181234dae3408fb2eb69b 
and linux-bcache to 9c79c00b0d02f0da5e01ad5cd1bf4ae2ce421d5d.
And now...

1. How to create simple bcachefs on one disk, without any cache?
# ./bcache format --meta_replicas=2 /dev/sdd1
Please supply a device

Help displays:
  # ./bcache format --help
Usage: bcache format [OPTION]... <list of devices>
Create a new bcache volume from one or more devices

Options:
   -C, --cache=dev             Format a cache device
   -w, --block=size            block size
   -n, --btree_node=size       Btree node size, default 256k
       --metadata_csum_type=(none|crc32c|crc64)
                               Checksum type
       --data_csum_type=(none|crc32c|crc64)
                               Checksum type
       --compression_type=(none|gzip)
                               Compression type
       --encrypted             enable encryption
       --meta_replicas=#       number of metadata replicas
       --data_replicas=#       number of data replicas
       --error_action=(continue|readonly|panic)
                               Action to take on filesystem error
   -l, --label=label           label
       --uuid=uuid             filesystem UUID
       --fs_size=size          Size of filesystem on device
   -b, --bucket=size           bucket size
   -t, --tier=#                tier of subsequent devices
       --discard               Enable discards
   -q, --quiet                 reduce output to errors only
   -v, --verbose               increase output to include informational 
messages
       --help                  display this help and exit
       --version               output version information and exit

Report bugs to <linux-bcache@vger.kernel.org>

I don't know what is correct syntax to format block device.

2. How to create and mount bcachefs witch cache device?
# ./bcache format --compression_type=lz4  --meta_replicas=2 /dev/sdd1  
-C /dev/sde1
UUID:                   2cd51dcb-6af3-4e92-8b01-64bac27300b2
Set UUID:               fd005c93-26f4-4da3-a991-18630ea37997
version:                6
nbuckets:               20480
block_size:             1
bucket_size:            1024
nr_in_set:              1
nr_this_dev:            0
first_bucket:           3

and what next?
# mount /dev/sdd1 /mnt/test/
# # ls -l  /sys/fs/bcache/33802bf3-abe4-4d85-bd44-380c1fa9c3d0/|grep 
cache
-r--r--r-- 1 root root 4096 sie 19 20:02 btree_cache_size
lrwxrwxrwx 1 root root    0 sie 19 20:02 cache0 -> 
../../../devices/pci0000:00/0000:00:1f.2/ata6/host5/target5:0:0/5:0:0:0/block/sdd/sdd1/bcache
-r--r--r-- 1 root root 4096 sie 19 20:02 cache_available_percent

It looks for me that cache device /dev/sde1 isn't used. How to use 
/dev/sde1 as a cache device?

3. Tiering. Just simple: how to?:)


Thanks in advance for tips.
Marcin
