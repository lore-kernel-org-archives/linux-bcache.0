From: Hannes Tismer <panni@fragstore.net>
Subject: Re: Allow separation of sequential_cutoff
Date: Wed, 16 Jul 2014 18:30:28 +0000
Message-ID: <20140716183028.Horde.Abvsoc5SHIXdLPk8rIDlRQ1@horde.fragstore.net>
References: <20140716121929.Horde.UTDswBOXdBbMJiTFap5WRQ1@horde.fragstore.net>
 <53C6A604.6000404@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from fragstore.net ([5.199.133.96]:45097 "EHLO fragstore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934637AbaGPSae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 16 Jul 2014 14:30:34 -0400
In-Reply-To: <53C6A604.6000404@nuclearwinter.com>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-bcache@vger.kernel.org, mail <mail@arni.name>

I second that.

This would make the whole process even more tunable.

Also a "simple" feature to limit caching to only-write-operations or =20
only-read-operations
would be very nice to have also.


Hannes




On Wed, 16 Jul 2014 11:19:16 -0500, Larkin Lowrey =20
<llowrey@nuclearwinter.com> wrote:

> I am also interested in this use case and also would like to see
> separate sequential cutoff values for read and write.
>
> In addition to that I would like to offer another idea for
> consideration, high and low watermarks for writeback_percent.
>
> The documentation at http://bcache.evilpiepirate.org/Design/ is eithe=
r
> out of date or incomplete... or I don't understand it. Specifically t=
he
> meaning of writeback_percent is not clear to me. That documentation
> states that write-back will not begin until the writeback_percent
> threshold has been reached. The definition in bcache.txt states that
> bcache tries to maintain that percent of the cache dirty. The latter
> seems to match my observations so I'll go with that.
>
> My idea is to have high and low watermarks for writeback_percent wher=
e
> writeback would not begin until reaching the high watermark and writi=
ng
> would continue until the low watermark was reached. To match the pres=
ent
> behavior, as I understand it, both values would be set the same.
> However, in the use case described here the spread between the two wo=
uld
> define how often the backing store would need to be spun up for writi=
ng.
>
> If one writes 10GB a day and the spread between high and low
> writeback_percent watermarks is set to 10GB then the backing store wo=
uld
> spin up only once per day. Ideally the writeback process would be abl=
e
> to write at a high rate in order to limit the amount of time the driv=
es
> would need to be spinning.
>
> I see two competing priorities for writeback. One is to smooth writes=
 so
> they are less bursty and less disruptive and the other is to consolid=
ate
> writes so they can be done in batches (bursty). It would be great if
> both cases could be supported.
>
> --Larkin
>
> On 7/16/2014 7:19 AM, Hannes Tismer wrote:
>> Dear bcache-developers,
>>
>> This is a feature request for a very specific use case:
>>
>> Having a caching device in front of an md-raid on a machine which
>> serves as a low power media server.
>>
>> The last writes could be cached on the caching device to reduce the
>> non-sleep time of the raid (drives in spindown state) while playing
>> media, together with a huge writeback delay of, let's say, 3 hours,
>> newest media would always be read from the caching device.
>>
>> It's not likely that a recently read (watched) media file will be re=
ad
>> again after having been read before (very recently), but it's very
>> likely that it'll be read once after it was written.
>>
>> I could disable sequential_cutoff or set it rediculously high. That
>> would result in every sequential read being cached into the caching
>> device, too, which in this use case is not wanted.
>>
>> Could you split up the sequential_cutoff setting to
>> sequential_read_cutoff and sequential_write_cutoff?
>>
>> That way writes including sequential ones can be cached for later, b=
ut
>> sequential reads could be ignored by the cache.
>>
>>
>> Thank you in advance
>>
>> Hannes


--=20
Hannes Tismer
Herzogstr. 4
41238 M=C3=B6nchengladbach
