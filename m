From: =?UTF-8?Q?Jure_Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>
Subject: Re: Cache everything
Date: Sat, 31 Dec 2016 06:20:10 +0100
Message-ID: <CAJ=9zieBA5pKkjaPwibwWjx+3keTbFOqymbdPxRy7b4=K1-x_A@mail.gmail.com>
References: <CAJ=9zif=Lxgcgv0EW8O7hfKDHn5g8acXKnbvygda6LjarL65Xg@mail.gmail.com>
 <586621AB.7040208@megasoft.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33973 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbcLaFUL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Dec 2016 00:20:11 -0500
Received: by mail-yw0-f195.google.com with SMTP id a10so30967098ywa.1
        for <linux-bcache@vger.kernel.org>; Fri, 30 Dec 2016 21:20:10 -0800 (PST)
In-Reply-To: <586621AB.7040208@megasoft.be>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Killian De Volder <killian.de.volder@megasoft.be>
Cc: linux-bcache@vger.kernel.org

This seems to have fixed that, thanks. I keep forgetting there's two
places I have to check for configuration.

LP,
Jure

On Fri, Dec 30, 2016 at 9:58 AM, Killian De Volder
<killian.de.volder@megasoft.be> wrote:
> Also check  congested_write_threshold_us, if the SSD is "congested" it by=
passes it to speedup writes.
>
> Killian De Volder
>
>
> On 30-12-16 09:38, Jure Erzno=C5=BEnik wrote:
>> I have a large array sitting in my server containing a bit of data
>> that is used ofter and a lot of data that is used rarely.
>> My goal is to make the platters spin up as rarely as possible while
>> bcache handles most of the requests to the array.
>>
>> I have set the disks spin-down time to 15 minutes so that during
>> high-activity periods they don't cycle power states too much.
>>
>> I have set bcache parameters such:
>> cache_mode - writeback
>> readahead - 0
>> sequential_cutoff - 0
>> writeback_delay - 3600 (one hour)
>> writeback_percent - 40 (won't go higher)
>>
>> I was hoping that this would make bcache cache everything leaving the
>> array practically untouched for an hour. However, stats_hour/bypassed
>> still shows megabytes of bypassed data and a cache_hit ratio of ~50%
>> even when I'm working ONLY with the frequently accessed data portion
>> (some 20% of total cache capacity). Also tiny writes are being made to
>> the array despite writeback_delay not expiring.
>>
>> What other parameter am I forgetting to achieve what I want?
>>
>> Thanks,
>> Jure
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
