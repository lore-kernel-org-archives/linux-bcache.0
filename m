From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v4 1/3] bcache: export bcache zone information for
 zoned backing device
Date: Wed, 3 Jun 2020 00:58:49 +0000
Message-ID: <CY4PR04MB3751543D5DA3C799B4C8A196E7880@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-2-colyli@suse.de>
 <CY4PR04MB37519681E8730119C1C74A75E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
 <1c124ebe-3f1c-6715-0c1b-245ae18ec012@suse.de>
 <9ad1e32ddd1d93ad4120723d23446160a0877752.camel@wdc.com>
 <c6492f79-423e-b37c-261c-80e4b26081ab@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>
List-Id: linux-bcache@vger.kernel.org

On 2020/06/02 21:50, Coly Li wrote:=0A=
>>>         /* convert back to LBA of the bcache device*/=0A=
>>>         zone->start -=3D data_offset;=0A=
>>>         if (zone->cond !=3D BLK_ZONE_COND_NOT_WP)=0A=
>>>                 zone->wp -=3D data_offset;=0A=
>>=0A=
>> Since you have the BLK_ZONE_COND_NOT_WP condition in the switch-case,=0A=
>> this is not needed. =0A=
>>=0A=
>>>=0A=
>>>         switch (zone->cond) {=0A=
>>>         case BLK_ZONE_COND_NOT_WP:=0A=
>>>                 /* No write pointer available */=0A=
>>>                 break;=0A=
>>>         case BLK_ZONE_COND_EMPTY:=0A=
>>=0A=
>> zone->wp =3D zone->start;=0A=
>>=0A=
> =0A=
> Correct me if I am wrong. I assume when the zone is in empty condition,=
=0A=
> LBA of zone->wp should be exactly equal to zone->start before bcache=0A=
> does the conversion. Therefore 'zone->wp - data_offset' should still be=
=0A=
> equal to 'zone->start - data_offset'. Therefore explicitly handle it in=
=0A=
> 'case BLK_ZONE_COND_EMPTY:' should be equal to handle it in 'default:' pa=
rt.=0A=
=0A=
Yes, for an empty zone, the zone wp is always equal to the start sector of =
the=0A=
zone. So yes, for an empty zone, wp - data_offset is correct. But it is not=
=0A=
necessary since you already need to do zone->start -=3D data_offset, all yo=
u need=0A=
to do for an empty zone is: zone->wp =3D zone->start. That is less arithmet=
ic (no=0A=
need for the subtraction), so is faster :)=0A=
=0A=
This code you have:=0A=
=0A=
	if (zone->cond !=3D BLK_ZONE_COND_NOT_WP)=0A=
		zone->wp -=3D data_offset;=0A=
=0A=
will indeed lead to the correct result for an empty zone, but as I explaine=
d, it=0A=
will also do the subtraction for zone conditions with an undefined value. N=
o=0A=
need to do all this. A switch case handling all conditions makes things ver=
y clear.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
