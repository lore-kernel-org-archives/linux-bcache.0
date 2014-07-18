From: Jianjian Huo <samuel.huo@gmail.com>
Subject: Re: Allow separation of sequential_cutoff
Date: Thu, 17 Jul 2014 23:42:35 -0700
Message-ID: <CAB=cV2TmT44umOJJD7xEKtxk+dR-o-d-xqGxN7O2NYV5LfNZxA@mail.gmail.com>
References: <20140716121929.Horde.UTDswBOXdBbMJiTFap5WRQ1@horde.fragstore.net>
	<53C6A604.6000404@nuclearwinter.com>
	<20140716183028.Horde.Abvsoc5SHIXdLPk8rIDlRQ1@horde.fragstore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46304 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaGRGmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 18 Jul 2014 02:42:37 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so3019223wgh.10
        for <linux-bcache@vger.kernel.org>; Thu, 17 Jul 2014 23:42:35 -0700 (PDT)
In-Reply-To: <20140716183028.Horde.Abvsoc5SHIXdLPk8rIDlRQ1@horde.fragstore.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Hannes Tismer <panni@fragstore.net>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-bcache@vger.kernel.org, mail <mail@arni.name>

I just posted the patch to add an option to disable read caching.
It works with all three cache polices, then you can get write-only.
If you want read-only-operations, you can just use writearound policy.

-Jianjian

On Wed, Jul 16, 2014 at 11:30 AM, Hannes Tismer <panni@fragstore.net> w=
rote:
> I second that.
>
> This would make the whole process even more tunable.
>
> Also a "simple" feature to limit caching to only-write-operations or
> only-read-operations
> would be very nice to have also.
>
>
> Hannes
>
>
>
>
>
> On Wed, 16 Jul 2014 11:19:16 -0500, Larkin Lowrey
> <llowrey@nuclearwinter.com> wrote:
>
>> I am also interested in this use case and also would like to see
>> separate sequential cutoff values for read and write.
>>
>> In addition to that I would like to offer another idea for
>> consideration, high and low watermarks for writeback_percent.
>>
>> The documentation at http://bcache.evilpiepirate.org/Design/ is eith=
er
>> out of date or incomplete... or I don't understand it. Specifically =
the
>> meaning of writeback_percent is not clear to me. That documentation
>> states that write-back will not begin until the writeback_percent
>> threshold has been reached. The definition in bcache.txt states that
>> bcache tries to maintain that percent of the cache dirty. The latter
>> seems to match my observations so I'll go with that.
>>
>> My idea is to have high and low watermarks for writeback_percent whe=
re
>> writeback would not begin until reaching the high watermark and writ=
ing
>> would continue until the low watermark was reached. To match the pre=
sent
>> behavior, as I understand it, both values would be set the same.
>> However, in the use case described here the spread between the two w=
ould
>> define how often the backing store would need to be spun up for writ=
ing.
>>
>> If one writes 10GB a day and the spread between high and low
>> writeback_percent watermarks is set to 10GB then the backing store w=
ould
>> spin up only once per day. Ideally the writeback process would be ab=
le
>> to write at a high rate in order to limit the amount of time the dri=
ves
>> would need to be spinning.
>>
>> I see two competing priorities for writeback. One is to smooth write=
s so
>> they are less bursty and less disruptive and the other is to consoli=
date
>> writes so they can be done in batches (bursty). It would be great if
>> both cases could be supported.
>>
>> --Larkin
>>
>> On 7/16/2014 7:19 AM, Hannes Tismer wrote:
>>>
>>> Dear bcache-developers,
>>>
>>> This is a feature request for a very specific use case:
>>>
>>> Having a caching device in front of an md-raid on a machine which
>>> serves as a low power media server.
>>>
>>> The last writes could be cached on the caching device to reduce the
>>> non-sleep time of the raid (drives in spindown state) while playing
>>> media, together with a huge writeback delay of, let's say, 3 hours,
>>> newest media would always be read from the caching device.
>>>
>>> It's not likely that a recently read (watched) media file will be r=
ead
>>> again after having been read before (very recently), but it's very
>>> likely that it'll be read once after it was written.
>>>
>>> I could disable sequential_cutoff or set it rediculously high. That
>>> would result in every sequential read being cached into the caching
>>> device, too, which in this use case is not wanted.
>>>
>>> Could you split up the sequential_cutoff setting to
>>> sequential_read_cutoff and sequential_write_cutoff?
>>>
>>> That way writes including sequential ones can be cached for later, =
but
>>> sequential reads could be ignored by the cache.
>>>
>>>
>>> Thank you in advance
>>>
>>> Hannes
>
>
>
> --
> Hannes Tismer
> Herzogstr. 4
> 41238 M=C3=B6nchengladbach
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
