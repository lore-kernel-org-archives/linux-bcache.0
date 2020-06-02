From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache
 device
Date: Tue, 2 Jun 2020 18:18:36 +0800
Message-ID: <e73f00de-f5d0-a8f7-e7a6-c3285fbfd368@suse.de>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-3-colyli@suse.de>
 <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
 <825e0e6e-b783-c899-bc25-38a8f2e06385@suse.de>
 <05e3dda28565c85f5beb0055a43ca4f685572431.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <05e3dda28565c85f5beb0055a43ca4f685572431.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>
List-Id: linux-bcache@vger.kernel.org

On 2020/6/2 16:54, Damien Le Moal wrote:
> On Tue, 2020-06-02 at 00:06 +0800, Coly Li wrote:
>>>> +		 * cache device.
>>>> +		 */
>>>> +		if (bio_op(bio) == REQ_OP_ZONE_RESET_ALL)
>>>> +			nr_zones = s->d->disk->queue->nr_zones;
>>>
>>> Not: sending a REQ_OP_ZONE_RESET BIO to a conventional zone will be failed by
>>> the disk... This is not allowed by the ZBC/ZAC specs. So invalidation the cache
>>> for conventional zones is not really necessary. But as an initial support, I
>>> think this is fine. This can be optimized later.
>>>
>> Copied, will think of how to optimized later. So far in my testing,
>> resetting conventional zones may receive error and timeout from
>> underlying drivers and bcache code just forwards such error to upper
>> layer. What I see is the reset command hangs for a quite long time and
>> failed. I will find a way to make the zone reset command on conventional
>> zone fail immediately.
> 
> It is 100% guaranteed that a zone reset issued to a conventional zone
> will fail. That is defined in ZBC/ZAC specifications. Resetting a
> single conventional zone is an error. We know the command will fail and
> the failure is instantaneous from the drive. The scsi layer should not
> retry these failed reset zone command, we have special error handling
> code preventing retries since we know that the command can only fail
> again. So I am not sure why you are seeing hang/long time before the
> failure is signaled... This may need investigation.
> 
> 

Copied. Currently I plan to add a first_seq_zone_nr to bcache on-disk
super block, its value will be set by user space bcache-tools when the
backing device is formatted for bcache. Then the zone reset bio which
has smaller zone number will be rejected immediately by bcache code.

This requires on-disk format change, I will do it later with other
on-disk change stuffs.

Coly Li
