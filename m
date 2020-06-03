From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache
 device
Date: Wed, 3 Jun 2020 00:51:45 +0000
Message-ID: <CY4PR04MB375123D5B0E99781D1A3D319E7880@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-3-colyli@suse.de>
 <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
 <825e0e6e-b783-c899-bc25-38a8f2e06385@suse.de>
 <05e3dda28565c85f5beb0055a43ca4f685572431.camel@wdc.com>
 <e73f00de-f5d0-a8f7-e7a6-c3285fbfd368@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>
List-Id: linux-bcache@vger.kernel.org

On 2020/06/02 19:18, Coly Li wrote:=0A=
> On 2020/6/2 16:54, Damien Le Moal wrote:=0A=
>> On Tue, 2020-06-02 at 00:06 +0800, Coly Li wrote:=0A=
>>>>> +		 * cache device.=0A=
>>>>> +		 */=0A=
>>>>> +		if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET_ALL)=0A=
>>>>> +			nr_zones =3D s->d->disk->queue->nr_zones;=0A=
>>>>=0A=
>>>> Not: sending a REQ_OP_ZONE_RESET BIO to a conventional zone will be fa=
iled by=0A=
>>>> the disk... This is not allowed by the ZBC/ZAC specs. So invalidation =
the cache=0A=
>>>> for conventional zones is not really necessary. But as an initial supp=
ort, I=0A=
>>>> think this is fine. This can be optimized later.=0A=
>>>>=0A=
>>> Copied, will think of how to optimized later. So far in my testing,=0A=
>>> resetting conventional zones may receive error and timeout from=0A=
>>> underlying drivers and bcache code just forwards such error to upper=0A=
>>> layer. What I see is the reset command hangs for a quite long time and=
=0A=
>>> failed. I will find a way to make the zone reset command on conventiona=
l=0A=
>>> zone fail immediately.=0A=
>>=0A=
>> It is 100% guaranteed that a zone reset issued to a conventional zone=0A=
>> will fail. That is defined in ZBC/ZAC specifications. Resetting a=0A=
>> single conventional zone is an error. We know the command will fail and=
=0A=
>> the failure is instantaneous from the drive. The scsi layer should not=
=0A=
>> retry these failed reset zone command, we have special error handling=0A=
>> code preventing retries since we know that the command can only fail=0A=
>> again. So I am not sure why you are seeing hang/long time before the=0A=
>> failure is signaled... This may need investigation.=0A=
>>=0A=
>>=0A=
> =0A=
> Copied. Currently I plan to add a first_seq_zone_nr to bcache on-disk=0A=
> super block, its value will be set by user space bcache-tools when the=0A=
> backing device is formatted for bcache. Then the zone reset bio which=0A=
> has smaller zone number will be rejected immediately by bcache code.=0A=
> =0A=
> This requires on-disk format change, I will do it later with other=0A=
> on-disk change stuffs.=0A=
=0A=
I do not think you actually need an on-disk format change for this since th=
at=0A=
information can simply live in memory. Also, it is not entirely correct to=
=0A=
assume that all conventional zones are at LBA 0 onward up to the first=0A=
sequential zone. It just happens that this is what drives on the market loo=
k=0A=
like today, but the standard allows conventional zones to be anywhere in th=
e=0A=
disk address space. The safe way to handle this is to do something like the=
=0A=
block layer does using a bitmap indicating if a zone is sequential or=0A=
conventional. Not that using the bitmap already attached to the device requ=
est=0A=
queue is possible but not safe since the backend device could be a DM targe=
t, so=0A=
a BIO device with a request queue that does not have zone bitmaps. So alloc=
ating=0A=
your own bitmap and doing a report zones to initialize it when the device i=
s=0A=
started is safer and will give you something very solid with no on-disk for=
mat=0A=
change needed.=0A=
=0A=
See fs/f2fs/super.c function init_blkz_info(), that is exactly what is done=
:=0A=
allocation and initialization of a bitmap to identify zone types.=0A=
=0A=
> =0A=
> Coly Li=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
