From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: can't attach
Date: Fri, 03 Oct 2014 15:50:01 -0500
Message-ID: <542F0BF9.8040401@hardwarefreak.com>
References: <542F0547.3060805@hardwarefreak.com> <CACHGV4+T0fc3Na=6yrne+NxW+wzd=mxSUqYWGscpuBZwSc9q9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:18589 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaJCUtp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 3 Oct 2014 16:49:45 -0400
In-Reply-To: <CACHGV4+T0fc3Na=6yrne+NxW+wzd=mxSUqYWGscpuBZwSc9q9g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: linux-bcache@vger.kernel.org


On 10/03/2014 03:37 PM, Slava Pestov wrote:
> Please include any bcache messages printed in dmesg when this happens.

[87579.418945] bcache: bch_cached_dev_attach() Can't attach dm-4: already attached
[87579.418947] bcache: __cached_dev_store() Can't attach 8246b830-95d4-420d-aff8-894efc348801
[87579.418947] : cache set not found

For completeness, these are the steps are performed, soup to nuts:

# wipefs -a /dev/dm-4
4 bytes [58 46 53 42] erased at offset 0x0 (xfs)
# wipefs -a /dev/dm-7
4 bytes [58 46 53 42] erased at offset 0x0 (xfs)
# wipefs -a /dev/sdc
# ./make-bcache -B /dev/dm-4 /dev/dm-7 -C /dev/sdc
Already a bcache device on /dev/sdc, overwrite with --wipe-bcache
# ./make-bcache -B /dev/dm-4 /dev/dm-7 -C /dev/sdc --wipe-bcache
UUID:			501486ea-d614-4a32-a137-bc8e004fcb85
Set UUID:		8246b830-95d4-420d-aff8-894efc348801
version:		0
nbuckets:		761856
block_size:		1
bucket_size:		1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
UUID:			261cf532-ca93-45b7-a8fb-1eff57078953
Set UUID:		8246b830-95d4-420d-aff8-894efc348801
version:		1
block_size:		1
data_offset:		16
UUID:			eeca31ab-a632-4d7b-94f6-35e9b878344f
Set UUID:		8246b830-95d4-420d-aff8-894efc348801
version:		1
block_size:		1
data_offset:		16
# echo /dev/dm-4 > /sys/fs/bcache/register
# echo /dev/dm-7 > /sys/fs/bcache/register
# echo /dev/sdc > /sys/fs/bcache/register

# ls -la /dev/b*
brw-rw---- 1 root disk 253, 0 Oct  3 14:39 /dev/bcache0
brw-rw---- 1 root disk 253, 1 Oct  3 14:39 /dev/bcache1

# mkfs.xfs /dev/bcache0
meta-data=/dev/bcache0           isize=256    agcount=44, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=11709285374, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mkfs.xfs /dev/bcache1
meta-data=/dev/bcache1           isize=256    agcount=44, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=11709285374, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount -o inode64,nobarrier,noatime,nodiratime /dev/bcache0 /mnt/V1A
# mount -o inode64,nobarrier,noatime,nodiratime /dev/bcache1 /mnt/V2A

# ls -la /sys/fs/bcache
total 0
drwxr-xr-x 3 root root    0 Oct  3 14:39 .
drwxr-xr-x 6 root root    0 Oct  2 16:32 ..
drwxr-xr-x 7 root root    0 Oct  3 14:50 8246b830-95d4-420d-aff8-894efc348801
--w------- 1 root root 4096 Oct  3 14:39 register
--w------- 1 root root 4096 Oct  3 14:50 register_quiet

# echo 8246b830-95d4-420d-aff8-894efc348801 > /sys/block/bcache0/bcache/attach
bash: echo: write error: Invalid argument


> On Fri, Oct 3, 2014 at 1:21 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> # ls -la /sys/fs/bcache
>> total 0
>> drwxr-xr-x 3 root root    0 Oct  3 14:39 .
>> drwxr-xr-x 6 root root    0 Oct  2 16:32 ..
>> drwxr-xr-x 7 root root    0 Oct  3 14:50 8246b830-95d4-420d-aff8-894efc348801
>> --w------- 1 root root 4096 Oct  3 14:39 register
>> --w------- 1 root root 4096 Oct  3 14:50 register_quiet
>>
>>
>> # echo 8246b830-95d4-420d-aff8-894efc348801 > /sys/block/bcache0/bcache/attach
>> bash: echo: write error: Invalid argument
>>
>>
>> What's the problem here?
>>
>> Thanks,
>> Stan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
