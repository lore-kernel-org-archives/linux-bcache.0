From: Denis Bychkov <manover@gmail.com>
Subject: Re: [PATCH] bcache: Fix writeback_thread never writing back
 incomplete stripes.
Date: Thu, 17 Sep 2015 11:30:17 -0400
Message-ID: <CAO2mnowurDEfqaZZk6MLmCtTFJ4MkgGEG9DKYytwkDSv1W4dnQ@mail.gmail.com>
References: <20150905111012.GA17180@suse.com>
	<20150916113206.GA16164@kmo-pixel>
	<CAO2mnozhTeuWwxsmQZor93xmyS5_r34YpGXy0ec=9vFCBGbO1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAO2mnozhTeuWwxsmQZor93xmyS5_r34YpGXy0ec=9vFCBGbO1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Emmanuel Florac <eflorac@intellique.com>, Jiri Kosina <jkosina@suse.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-bcache@vger.kernel.org

Well, it turns out my celebration was a bit premature.

PLEASE, DO NOT APPLY THE PATCH POSTED BY KENT (not the one Vojtech
posted) ON A PRODUCTION SYSTEM, IT CAUSES DATA CORRUPTION.

The interesting thing is that it somehow damaged the partition that
was not supposed to receive any writes (the file system was mounted
read-only), so my guess is that the patch causes the blocks residing
in the write-back cache to flush to the wrong blocks on the backing
device.
Everything was going great until I rebooted and saw this in the log:

[   19.639082] attempt to access beyond end of device
[   19.643984] md1p2: rw=1, want=75497520, limit=62914560
[   19.659033] attempt to access beyond end of device
[   19.663929] md1p2: rw=1, want=75497624, limit=62914560
[   19.669447] attempt to access beyond end of device
[   19.674338] md1p2: rw=1, want=75497752, limit=62914560
[   19.679195] attempt to access beyond end of device
[   19.679199] md1p2: rw=1, want=75498080, limit=62914560
[   19.689007] attempt to access beyond end of device
[   19.689011] md1p2: rw=1, want=75563376, limit=62914560
[   19.699055] attempt to access beyond end of device
[   19.699059] md1p2: rw=1, want=79691816, limit=62914560
[   19.719246] attempt to access beyond end of device
[   19.724144] md1p2: rw=1, want=79691928, limit=62914560
......
(it's a small example, the list was much longer)
And the next thing I found out the super block on my 10-Tb XFS RAID was gone. :)
Oh well, it's a good thing I have backups.
I knew what I was doing when trying the untested patches. I should
have made the RAID md partition read-only, not the file system. I kind
of expected that something could have gone wrong with the file system
I was testing, just did not expect it would fire nukes at the innocent
bystanders.


On Wed, Sep 16, 2015 at 5:08 PM, Denis Bychkov <manover@gmail.com> wrote:
> Hi Kent, Vojtech, list
>
> Your fix works perfectly, I can finally remove my patch that disables
> the partial_stripes_expensive branch and unleash the full bcache
> performance on my RAID-6 array. I was aware of this problem for some
> time now, but never got to learning the bcache codebase enough to find
> out why this happens with partial stripes write-back enabled, so I
> just disabled it to avoid CPU spinning. Thanks a lot to Vojtech for
> finding the reason and to you for the patch. I have quite a collection
> of stability patches for the mainline bcache. Would you please be kind
> to review them when convenient and merge upstream the ones you think
> are worth merging. It will be 4.4 merge window, I believe.
> Please find all the patches attached. All of them are rebased on
> mainline 4.2 kernel. If somebody needs the 4.1.x versions, please let
> me know.
>
>
> On Wed, Sep 16, 2015 at 7:32 AM, Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
>> On Sat, Sep 05, 2015 at 01:10:12PM +0200, Vojtech Pavlik wrote:
>>> Fix writeback_thread never finishing writing back all dirty data in bcache when
>>> partial_stripes_expensive is set, and spinning, consuming 100% of CPU instead.
>>>
>>> Signed-off-by: Vojtech Pavlik <vojtech@suse.com>
>>> ---
>>>
>>> This is a fix for the current upstream bcache, not the devel branch.
>>>
>>> If partial_stripes_expensive is set for a cache set, then writeback_thread
>>> always attempts to write full stripes out back to the backing device first.
>>> However, since it does that based on a bitmap and not a simple linear
>>> search, like the rest of the code of refill_dirty(), it changes the
>>> last_scanned pointer so that never points to 'end'. refill_dirty() then
>>> never tries to scan from 'start', resulting in the writeback_thread
>>> looping, consuming 100% of CPU, but never making progress in writing out
>>> the incomplete dirty stripes in the cache.
>>>
>>> Scanning the tree after not finding enough full stripes fixes the issue.
>>>
>>> Incomplete dirty stripes are written to the backing device, the device
>>> eventually reaches a clean state if there is nothing dirtying data and
>>> writeback_thread sleeps. This also fixes the problem of the cache device
>>> not being possible to detach in the partial_stripes_expensive scenario.
>>
>> Good catch!
>>
>>> It may be more efficient to separate the last_scanned field for normal and
>>> stripe scans instead.
>>
>> Actually, I think I like your approach - I think it gives us the behaviour we
>> want, although it took some thinking to figure out why.
>>
>> One of the reasons for last_scanned is just to do writeback in LBA order and
>> avoid making the disks seek around - so, if refill_full_stripes() did just queue
>> up some IO at last_scanned, we do want to keep scanning from that position for
>> non full stripes.
>>
>> But since (as you noted) last_scanned is never going to be >= end after calling
>> refill_full_strips() (if there were any full stripes) - really the correct thing
>> to do is loop around to the start if necessary so that we can successfully scan
>> everything.
>>
>> The only inefficiency I see with your approach is that on the second scan, after
>> we've looped, we don't need to scan to the end of the disk - we only need to
>> scan up to where we initially started.
>>
>> But, another observation - if we change refill_dirty() so that it always scans
>> the entire keyspace if necessary, regardless of where last_scanned was - well,
>> that really isn't specific to the refill_full_stripes() case - we can just
>> always do that.
>>
>> Can you give this patch a try?
>>
>> -- >8 --
>> Subject: [PATCH] bcache: Change refill_dirty() to always scan entire disk if necessary
>>
>> Previously, it would only scan the entire disk if it was starting from the very
>> start of the disk - i.e. if the previous scan got to the end.
>>
>> This was broken by refill_full_stripes(), which updates last_scanned so that
>> refill_dirty was never triggering the searched_from_start path.
>>
>> But if we change refill_dirty() to always scan the entire disk if necessary,
>> regardless of what last_scanned was, the code gets cleaner and we fix that bug
>> too.
>>
>> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>> ---
>>  drivers/md/bcache/writeback.c | 24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index cdde0f32f0..08a52db38b 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -359,11 +359,13 @@ next:
>>         }
>>  }
>>
>> +/*
>> + * Returns true if we scanned the entire disk
>> + */
>>  static bool refill_dirty(struct cached_dev *dc)
>>  {
>>         struct keybuf *buf = &dc->writeback_keys;
>> -       struct bkey end = KEY(dc->disk.id, MAX_KEY_OFFSET, 0);
>> -       bool searched_from_start = false;
>> +       struct bkey start_pos, end = KEY(dc->disk.id, MAX_KEY_OFFSET, 0);
>>
>>         if (dc->partial_stripes_expensive) {
>>                 refill_full_stripes(dc);
>> @@ -371,14 +373,20 @@ static bool refill_dirty(struct cached_dev *dc)
>>                         return false;
>>         }
>>
>> -       if (bkey_cmp(&buf->last_scanned, &end) >= 0) {
>> -               buf->last_scanned = KEY(dc->disk.id, 0, 0);
>> -               searched_from_start = true;
>> -       }
>> -
>> +       start_pos = buf->last_scanned;
>>         bch_refill_keybuf(dc->disk.c, buf, &end, dirty_pred);
>>
>> -       return bkey_cmp(&buf->last_scanned, &end) >= 0 && searched_from_start;
>> +       if (bkey_cmp(&buf->last_scanned, &end) < 0)
>> +               return false;
>> +
>> +       /*
>> +        * If we get to the end start scanning again from the beginning, and
>> +        * only scan up to where we initially started scanning from:
>> +        */
>> +       buf->last_scanned = KEY(dc->disk.id, 0, 0);
>> +       bch_refill_keybuf(dc->disk.c, buf, &start_pos, dirty_pred);
>> +
>> +       return bkey_cmp(&buf->last_scanned, &start_pos) >= 0;
>>  }
>>
>>  static void bch_writeback(struct cached_dev *dc)
>> --
>> 2.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
>
> Denis



-- 

Denis
