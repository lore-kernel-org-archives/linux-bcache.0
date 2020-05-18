From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Mon, 18 May 2020 06:56:36 +0000
Message-ID: <BY5PR04MB6900419B7FBB5913904B3AF1E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de> <20200516123801.GB13448@lst.de>
 <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
 <20200516125027.GA13730@lst.de>
 <f57da1e7-1563-db1e-8730-8daca219cbe7@suse.de>
 <20200516153649.GB16693@lst.de>
 <c50be737-da25-1e48-3e26-aa15df175110@suse.de>
 <19eea726-590c-bf55-2dbf-35b71c9d1600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26324 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgERG4j (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 May 2020 02:56:39 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

On 2020/05/18 15:53, Hannes Reinecke wrote:=0A=
> On 5/17/20 7:30 AM, Coly Li wrote:=0A=
>> On 2020/5/16 23:36, Christoph Hellwig wrote:=0A=
>>> On Sat, May 16, 2020 at 09:05:39PM +0800, Coly Li wrote:=0A=
>>>> On 2020/5/16 20:50, Christoph Hellwig wrote:=0A=
>>>>> On Sat, May 16, 2020 at 08:44:45PM +0800, Coly Li wrote:=0A=
>>>>>> Yes you are right, just like REQ_OP_DISCARD which does not transfer =
any=0A=
>>>>>> data but changes the data on device. If the request changes the stor=
ed=0A=
>>>>>> data, it does transfer data.=0A=
>>>>>=0A=
>>>>> REQ_OP_DISCARD is a special case, because most implementation end up=
=0A=
>>>>> transferring data, it just gets attached in the low-level driver.=0A=
>>>>>=0A=
>>>>=0A=
>>>> Yes, REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are quite similar to=
=0A=
>>>> REQ_OP_DISCARD. Data read from the LBA range of reset zone is not=0A=
>>>> suggested and the content is undefined.=0A=
>>>>=0A=
>>>> For bcache, similar to REQ_OP_DISCARD, REQ_OP_ZONE_RESET and=0A=
>>>> REQ_OP_ZONE_RESET_ALL are handled in same way: If the backing device=
=0A=
>>>> supports discard/zone_reset, and the operation successes, then cached=
=0A=
>>>> data on SSD covered by the LBA range should be invalid, otherwise user=
s=0A=
>>>> will read outdated and garbage data.=0A=
>>>>=0A=
>>>> We should treat REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL being in=
=0A=
>>>> WRITE direction.=0A=
>>>=0A=
>>> No, the difference is that the underlying SCSI/ATA/NVMe command tend to=
=0A=
>>> usually actually transfer data.  Take a look at the special_vec field=
=0A=
>>> in struct request and the RQF_SPECIAL_PAYLOAD flag.=0A=
>>>=0A=
>>=0A=
>> Then bio_data_dir() will be problematic, as it is defined,=0A=
>>   52 /*=0A=
>>   53  * Return the data direction, READ or WRITE.=0A=
>>   54  */=0A=
>>   55 #define bio_data_dir(bio) \=0A=
>>   56         (op_is_write(bio_op(bio)) ? WRITE : READ)=0A=
>>=0A=
>> For the REQ_OP_ZONE_RESET bio, bio_data_dir() will report it as READ.=0A=
>>=0A=
>> Since the author is you, how to fix this ?=0A=
>>=0A=
> =0A=
> Well, but I do think that Coly is right in that bio_data_dir() is very =
=0A=
> unconvincing, or at least improperly documented.=0A=
> =0A=
> I can't quite follow Christoph's argument in that bio_data_dir() =0A=
> reflects whether data is _actually_ transferred (if so, why would =0A=
> REQ_OP_ZONE_CLOSE() be marked as WRITE?)=0A=
> However, in most cases bio_data_dir() will only come into effect if =0A=
> there are attached bvecs.=0A=
> =0A=
> So the _correct_ usage for bio_data_dir() would be to check if there is =
=0A=
> data attached to the bio (eg by using bio_has_data()), and only call =0A=
> bio_data_dir() if that returns true. For false you'd need to add a =0A=
> switch evaluating the individual commands.=0A=
> =0A=
> And, btw, bio_has_data() needs updating, too; all the zone commands are =
=0A=
> missing from there, too.=0A=
=0A=
Not really. They all have 0 size, so bio_has_data() always return false for=
 zone=0A=
management ops. It will return true only for report zones.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
