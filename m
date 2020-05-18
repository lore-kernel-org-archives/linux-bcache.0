From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Date: Mon, 18 May 2020 01:07:13 +0000
Message-ID: <BY5PR04MB6900CEAF2B5C87BDF6101711E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-4-colyli@suse.de> <20200516124020.GC13448@lst.de>
 <d3fe49f1-d37b-689e-ae0e-078b1254d7e7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:21728 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgERBHP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 21:07:15 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>

On 2020/05/16 22:14, Coly Li wrote:=0A=
> On 2020/5/16 20:40, Christoph Hellwig wrote:=0A=
>> On Sat, May 16, 2020 at 11:54:33AM +0800, Coly Li wrote:=0A=
>>> The bcache driver is bio based and NOT request based multiqueued driver=
,=0A=
>>> if a zoned SMR hard drive is used as backing device of a bcache device,=
=0A=
>>> calling blk_revalidate_disk_zones() for the bcache device will fail due=
=0A=
>>> to the following check in blk_revalidate_disk_zones(),=0A=
>>> 478       if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
>>> 479             return -EIO;=0A=
>>>=0A=
>>> Now bcache is able to export the zoned information from the underlying=
=0A=
>>> zoned SMR drives and format zonefs on top of a bcache device, the=0A=
>>> resitriction that a zoned device should be multiqueued is unnecessary=
=0A=
>>> for now.=0A=
>>>=0A=
>>> Although in commit ae58954d8734c ("block: don't handle bio based driver=
s=0A=
>>> in blk_revalidate_disk_zones") it is said that bio based drivers should=
=0A=
>>> not call blk_revalidate_disk_zones() and just manually update their own=
=0A=
>>> q->nr_zones, but this is inaccurate. The bio based drivers also need to=
=0A=
>>> set their zone size and initialize bitmaps for cnv and seq zones, it is=
=0A=
>>> necessary to call blk_revalidate_disk_zones() for bio based drivers.=0A=
>>=0A=
>> Why would you need these bitmaps for bcache?  There is no reason to=0A=
>> serialize requests for stacking drivers, and you can already derive=0A=
>> if a zone is sequential or not from whatever internal information=0A=
>> you use.=0A=
>>=0A=
>> So without a user that actually makes sense: NAK.=0A=
>>=0A=
> =0A=
> It is OK for me to set the zone_nr and zone size without calling=0A=
> blk_revalidate_disk_zones().=0A=
=0A=
Yes, no problem with that.=0A=
=0A=
This is how device mapper BIO based targets handle zoned devices. See=0A=
dm_set_device_limits() which uses bdev_stack_limits() for handling chunk_se=
ctors=0A=
(zone size) and directly set q->limits.zoned to blk_queue_zoned_model(q) of=
 the=0A=
the underlying device. For the number of zones, see dm_table_set_restrictio=
ns()=0A=
which uses blkdev_nr_zones(t->md->disk) to set q->nr_zones. Note that=0A=
blkdev_nr_zones() uses the gendisk capacity of the logical device (the bcac=
he=0A=
device in your case) and the zone size, so both must be set first before ca=
lling=0A=
blkdev_nr_zones().=0A=
=0A=
=0A=
> =0A=
> Coly Li=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
