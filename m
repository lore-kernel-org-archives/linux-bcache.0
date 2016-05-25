From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4/4] MAINTAINERS: mark bcache as orphan
Date: Wed, 25 May 2016 11:35:28 -0600
Message-ID: <5745E260.5010703@kernel.dk>
References: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
 <alpine.LNX.2.00.1605241636520.31937@cbobk.fhfr.pm>
 <1464101004.1835.14.camel@perches.com>
 <alpine.LNX.2.00.1605250705210.31937@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1605250705210.31937@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>, Joe Perches <joe@perches.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 05/24/2016 11:07 PM, Jiri Kosina wrote:
> On Tue, 24 May 2016, Joe Perches wrote:
>
>>> The submitted patches are not being reacted upon, and Jens is only picking
>>> up stable fixes on an rather ad-hoc basis.
>>>
>>> Link: lkml.kernel.org/r/574462C5.40307@kernel.dk
>>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>>> ---
>>>   MAINTAINERS | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 5f83015..c9906d6 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -2288,7 +2288,7 @@ BCACHE (BLOCK LAYER CACHE)
>>>   M:     Kent Overstreet <kent.overstreet@gmail.com>
>>>   L:     linux-bcache@vger.kernel.org
>>>   W:     http://bcache.evilpiepirate.org
>>> -S:     Maintained
>>> +S:     Orphan
>>>   F:     drivers/md/bcache/
>>
>> Sections marked as Orphan generally
>> don't also have a named maintainer.
>>
>> Should Kent still be listed here?
>
> Thanks for the remark. I'd leave this up to Jens, as apparently at the end
> of the day he's the one relaying stability bugfixes upstream; so it might
> actually make sense to have him listed there eventually (while keeping the
> Orphan status).

Let's leave the entry. Kent is still around, it's just not actively 
being maintained.

-- 
Jens Axboe
