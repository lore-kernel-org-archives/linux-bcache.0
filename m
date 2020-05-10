From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v2] bcache: export zoned information for backing
 device
Date: Mon, 11 May 2020 01:24:11 +0800
Message-ID: <db0b8463-4402-41c9-e15c-76eed585caf1@suse.de>
References: <20200510165232.67500-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200510165232.67500-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-bcache@vger.kernel.org

On 2020/5/11 00:52, Coly Li wrote:
> This is a very basic zoned device support. With this patch, bcache
> device is able to,
> - Export zoned device attribution via sysfs
> - Response report zones request, e.g. by command 'blkzone report'
> But the bcache device is still NOT able to,
> - Response any zoned device management request or IOCTL command
> 
> Here are the testings I have done,
> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'
> - read /sys/block/bcache0/queue/nr_zones, content is number of zones
>   including all zone types.
> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size
>   in sectors.
> - run 'blkzone report /dev/bcache0', all zones information displayed.
> - run 'blkzone reset /dev/bcache0', operation is rejected with error
>   information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:
>   Operation not supported"
> - Sequential writes by dd, I can see some zones' write pointer 'wptr'
>   values updated.
> 
> All of these are very basic testings, if you have better testing
> tools or cases, please offer me hint.
> 
> Thanks in advance for your review and comments.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> CC: Hannes Reinecke <hare@suse.com>
> CC: Damien Le Moal <damien.lemoal@wdc.com>
> CC: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---

Hi Damien and Johannes,

With this patch the bcache device with a SMR drive can export the zone
information and format zonefs on top of it. Writeback mode does not work
at this moment (it requires on-disk format change and on my to-do list),
writethrough and writearound mode can be used on the bcache device to
accelerate random read when hitting.

During my testing, there are 2 things needs to fix.

1, mkzonefs report the first zone size does not match.
   Because bcache occupies the first 8KB of the backing SMR drive, so
the first zone size is 8KB less. By ignoring unmatched zone 0 size,
mkzonefs works and the bcache device is formated.

2, Direct I/O on files under seq/ directory can not be accessed.
   I need help here. It seems direct I/O write fails with -EINVAL. I
found the failure happens in fs/iomap/direct-io.c:iomap_dio_bio_actor(),
211         if ((pos | length | align) & ((1 << blkbits) - 1))
212                 return -EINVAL;

When I write to seq/1 file on offset 0 with 4096 bytes, in the above
line, align is 205427296, and  (pos | length | align) & ((1 << blkbits)
- 1) is non-zero. Then all writes to files under seq/ fail with -EINVAL.

I guess there should be something missing when I do the direct I/O
write. Could you all give me some hint ?

Thanks in advance.

Coly Li
