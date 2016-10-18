From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs][tier] INFO: task bch_tier_read:21414 blocked for more
 than 120 seconds.
Date: Tue, 18 Oct 2016 08:07:14 +0200
Message-ID: <f9b01a85-2b08-179b-9b60-3efc85795ae8@mejor.pl>
References: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
 <20161012012600.s2cq5ac37hwwrp3e@kmo-pixel>
 <b96021dc-9eaa-ea03-291f-1612d73f49c4@mejor.pl>
 <20161012121105.ym3sed4tgc2vx3dh@kmo-pixel>
 <8312944b83a28b36f054c7a44d0fcbd8@mejor.pl>
 <CAC7rs0vU1KTsf1KmbCJg3GWLrsKd4aA=j=vCezyBPTuVFxOHQg@mail.gmail.com>
 <856aa94d33dfbd22dbb377b5de22b0cc@mejor.pl>
 <20161018003031.ny2dodab32mhmv3p@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:36380 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755370AbcJRGHg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Oct 2016 02:07:36 -0400
In-Reply-To: <20161018003031.ny2dodab32mhmv3p@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 2016-10-18 o 02:30, Kent Overstreet pisze:
> On Wed, Oct 12, 2016 at 09:51:17PM +0200, Marcin wrote:
>> W dniu 2016-10-12 21:19, Kent Overstreet napisa³(a):
>>> It needs to return true, not false.
>>
>> It's not a bash, ok:)
>>
>> With:
>> --- a/drivers/md/bcache/journal.h
>> +++ b/drivers/md/bcache/journal.h
>> @@ -184,7 +184,8 @@ static inline unsigned jset_u64s(unsigned u64s)
>>
>>  static inline bool journal_flushes_device(struct cache *ca)
>>  {
>> -       return ca->mi.tier == 0;
>> +       /** return ca->mi.tier == 0; **/
>> +       return true;
>
> Chris retested with the latest bcache-dev and it seems to be working for him
> now - can you retest with bcache-dev too?


Hi!
I retested, I can't trigger this bug again. It looks you fixed this. Thanks!
I noticed that umounting filesystem gives me such messages:
[ 4460.050248] bch_write: 7 callbacks suppressed
[ 4460.050261] bcache (53f02c70-608f-48e9-bdb9-53132b44fce4): IO error: 
read only
[ 4460.240296] bcache (53f02c70-608f-48e9-bdb9-53132b44fce4): stopped

Is it something important?
