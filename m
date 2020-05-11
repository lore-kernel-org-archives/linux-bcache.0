From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2] bcache: export zoned information for backing
 device
Date: Mon, 11 May 2020 07:05:45 +0000
Message-ID: <BY5PR04MB6900FDDF5B6281B10B940986E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200510165232.67500-1-colyli@suse.de>
 <db0b8463-4402-41c9-e15c-76eed585caf1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24294 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgEKHFt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 11 May 2020 03:05:49 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

Hi Coli,=0A=
=0A=
On 2020/05/11 2:24, Coly Li wrote:=0A=
> On 2020/5/11 00:52, Coly Li wrote:=0A=
>> This is a very basic zoned device support. With this patch, bcache=0A=
>> device is able to,=0A=
>> - Export zoned device attribution via sysfs=0A=
>> - Response report zones request, e.g. by command 'blkzone report'=0A=
>> But the bcache device is still NOT able to,=0A=
>> - Response any zoned device management request or IOCTL command=0A=
>>=0A=
>> Here are the testings I have done,=0A=
>> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'=0A=
>> - read /sys/block/bcache0/queue/nr_zones, content is number of zones=0A=
>>   including all zone types.=0A=
>> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size=0A=
>>   in sectors.=0A=
>> - run 'blkzone report /dev/bcache0', all zones information displayed.=0A=
>> - run 'blkzone reset /dev/bcache0', operation is rejected with error=0A=
>>   information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:=0A=
>>   Operation not supported"=0A=
>> - Sequential writes by dd, I can see some zones' write pointer 'wptr'=0A=
>>   values updated.=0A=
>>=0A=
>> All of these are very basic testings, if you have better testing=0A=
>> tools or cases, please offer me hint.=0A=
>>=0A=
>> Thanks in advance for your review and comments.=0A=
>>=0A=
>> Signed-off-by: Coly Li <colyli@suse.de>=0A=
>> CC: Hannes Reinecke <hare@suse.com>=0A=
>> CC: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> CC: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
>> ---=0A=
> =0A=
> Hi Damien and Johannes,=0A=
> =0A=
> With this patch the bcache device with a SMR drive can export the zone=0A=
> information and format zonefs on top of it. Writeback mode does not work=
=0A=
> at this moment (it requires on-disk format change and on my to-do list),=
=0A=
> writethrough and writearound mode can be used on the bcache device to=0A=
> accelerate random read when hitting.=0A=
> =0A=
> During my testing, there are 2 things needs to fix.=0A=
> =0A=
> 1, mkzonefs report the first zone size does not match.=0A=
>    Because bcache occupies the first 8KB of the backing SMR drive, so=0A=
> the first zone size is 8KB less. By ignoring unmatched zone 0 size,=0A=
> mkzonefs works and the bcache device is formated.=0A=
=0A=
Hannes was faster than me to comment on this. I can only repeat: this will =
not=0A=
work as there is the assumptions that all zones are the same size, except=
=0A=
eventually for the last one. I am even surprised that mkzonefs worked... Lo=
oks I=0A=
have some patching to do :)=0A=
=0A=
The simplest solution is as Hannes pointed out: use the first zone in its=
=0A=
entirety for bcache super block and nothing else. And do not show this zone=
 in=0A=
the zone report so that the bcache device user cannot reset or overwrite it=
.=0A=
That will mean as Hannes pointed out that the report zones device method fo=
r=0A=
bcache will need to remap zone start and wp sectors to start from sector 0.=
=0A=
Basically, substracting zone size to all zone start and to zone wp for non-=
full=0A=
zones will do.=0A=
=0A=
> 2, Direct I/O on files under seq/ directory can not be accessed.=0A=
>    I need help here. It seems direct I/O write fails with -EINVAL. I=0A=
> found the failure happens in fs/iomap/direct-io.c:iomap_dio_bio_actor(),=
=0A=
> 211         if ((pos | length | align) & ((1 << blkbits) - 1))=0A=
> 212                 return -EINVAL;=0A=
> =0A=
> When I write to seq/1 file on offset 0 with 4096 bytes, in the above=0A=
> line, align is 205427296, and  (pos | length | align) & ((1 << blkbits)=
=0A=
> - 1) is non-zero. Then all writes to files under seq/ fail with -EINVAL.=
=0A=
=0A=
205427296 is 195MB, so offset 0 in file seq/1 does not align to zone 1 star=
t=0A=
sector. This is why you see the  error (unaligned write). This is due to th=
e=0A=
first zone not being the same size, which zonefs assumes.=0A=
=0A=
If you could do all that, it probably also mean that you forgot to call=0A=
blk_revalidate_disk_zones() when setting up the bcache device. That is nece=
ssary=0A=
to set all queue limits and check the zone sizes are equal.=0A=
=0A=
I will check your patch shortly.=0A=
=0A=
> I guess there should be something missing when I do the direct I/O=0A=
> write. Could you all give me some hint ?=0A=
> =0A=
> Thanks in advance.=0A=
> =0A=
> Coly Li=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
