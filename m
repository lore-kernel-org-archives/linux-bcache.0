From: Denis Bychkov <manover@gmail.com>
Subject: Re: [PATCH] bcache: Fix writeback_thread never writing back
 incomplete stripes.
Date: Thu, 17 Sep 2015 16:54:20 -0400
Message-ID: <CAO2mnoyeEbzGR2fkPP-6XNbxg073nN8qmb34dp4e_XOqd8tyKQ@mail.gmail.com>
References: <20150905111012.GA17180@suse.com>
	<20150916113206.GA16164@kmo-pixel>
	<CAO2mnozhTeuWwxsmQZor93xmyS5_r34YpGXy0ec=9vFCBGbO1w@mail.gmail.com>
	<CAO2mnowurDEfqaZZk6MLmCtTFJ4MkgGEG9DKYytwkDSv1W4dnQ@mail.gmail.com>
	<20150917164054.GA28032@kmo-pixel>
	<20150917183154.GB28032@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:36414 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbbIQUyW (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 17 Sep 2015 16:54:22 -0400
In-Reply-To: <20150917183154.GB28032@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Emmanuel Florac <eflorac@intellique.com>, Jiri Kosina <jkosina@suse.com>, Jens Axboe <axboe@kernel.dk>

Yes, sure, I'll try it.
And yes, this was exactly my setup - several backing devices sharing
the same cache set, all in write back mode.
When I decided to try your patch yesterday, I created a few more and
attached them to the same cache set. Did not want to experiment with
the live ones - so just remounted them RO to make sure they won't send
any writes. Instead of switching the md array into RO mode - I am an
idiot.
And today, after I detached the botched XFS partition from the cache
(to make sure, there are no more dirty data left) and looked at the
area where there used to be an XFS super block, I found a super block
belonging to one of the new devices I created. So there is no mistake
here, this is exactly what happened, I think you pinned it.
The only thing I don't understand is how those writes ended up on a
different device. I'd understand it if it was the same device,
different partition, we would write to the sectors that belong to a
different partition on the same disk. But this is not the case, it is
a different md device that received the unwanted writes. Unless ...
unless, of course, the addresses of the write requests that are stored
in bcache cache set have already been translated into a physical
interface (ATA/SCSI) address. Have they? If that is the case, they
share the same address space, because they are the same SATA drives.
But, that can't be true, right? Bcache can not and does not store
physical drive addresses in the cache, does it?

On Thu, Sep 17, 2015 at 2:31 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> On Thu, Sep 17, 2015 at 08:40:54AM -0800, Kent Overstreet wrote:
>> On Thu, Sep 17, 2015 at 11:30:17AM -0400, Denis Bychkov wrote:
>> > Well, it turns out my celebration was a bit premature.
>> >
>> > PLEASE, DO NOT APPLY THE PATCH POSTED BY KENT (not the one Vojtech
>> > posted) ON A PRODUCTION SYSTEM, IT CAUSES DATA CORRUPTION.
>> >
>> > The interesting thing is that it somehow damaged the partition that
>> > was not supposed to receive any writes (the file system was mounted
>> > read-only), so my guess is that the patch causes the blocks residing
>> > in the write-back cache to flush to the wrong blocks on the backing
>> > device.
>> > Everything was going great until I rebooted and saw this in the log:
>> >
>> > [   19.639082] attempt to access beyond end of device
>> > [   19.643984] md1p2: rw=1, want=75497520, limit=62914560
>> > [   19.659033] attempt to access beyond end of device
>> > [   19.663929] md1p2: rw=1, want=75497624, limit=62914560
>> > [   19.669447] attempt to access beyond end of device
>> > [   19.674338] md1p2: rw=1, want=75497752, limit=62914560
>> > [   19.679195] attempt to access beyond end of device
>> > [   19.679199] md1p2: rw=1, want=75498080, limit=62914560
>> > [   19.689007] attempt to access beyond end of device
>> > [   19.689011] md1p2: rw=1, want=75563376, limit=62914560
>> > [   19.699055] attempt to access beyond end of device
>> > [   19.699059] md1p2: rw=1, want=79691816, limit=62914560
>> > [   19.719246] attempt to access beyond end of device
>> > [   19.724144] md1p2: rw=1, want=79691928, limit=62914560
>> > ......
>> > (it's a small example, the list was much longer)
>> > And the next thing I found out the super block on my 10-Tb XFS RAID was gone. :)
>> > Oh well, it's a good thing I have backups.
>> > I knew what I was doing when trying the untested patches. I should
>> > have made the RAID md partition read-only, not the file system. I kind
>> > of expected that something could have gone wrong with the file system
>> > I was testing, just did not expect it would fire nukes at the innocent
>> > bystanders.
>>
>> Aw, shit. That's just _bizzare_.
>>
>> I have a theory - it appears that last_scanned isn't getting initialized before
>> it's used, so it's going to be all 0s the very first time... which it appears
>> could cause it to slurp up keys from the wrong device (and if that device was
>> bigger than the correct device, that could explain the accesses beyond the end
>> of the device).
>>
>> Currently just a theory though, and I have no clue why it would only be exposed
>> with my patch.
>
> Here's an updated patch that has a fix for _that_ theory, and also a new
> BUG_ON(). Any chance you could test it?
>
> Oh - I didn't ask - _do_ you have multiple backing devices attached to the same
> cache set? Because if you don't, this isn't it at all...
>
> -- >8 --
> Subject: [PATCH] bcache: Change refill_dirty() to always scan entire disk if necessary
>
> Previously, it would only scan the entire disk if it was starting from the very
> start of the disk - i.e. if the previous scan got to the end.
>
> This was broken by refill_full_stripes(), which updates last_scanned so that
> refill_dirty was never triggering the searched_from_start path.
>
> But if we change refill_dirty() to always scan the entire disk if necessary,
> regardless of what last_scanned was, the code gets cleaner and we fix that bug
> too.
>
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  drivers/md/bcache/writeback.c | 37 ++++++++++++++++++++++++++++++-------
>  1 file changed, 30 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index cdde0f32f0..d383024247 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -310,6 +310,10 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned inode,
>
>  static bool dirty_pred(struct keybuf *buf, struct bkey *k)
>  {
> +       struct cached_dev *dc = container_of(buf, struct cached_dev, writeback_keys);
> +
> +       BUG_ON(KEY_INODE(k) != dc->disk.id);
> +
>         return KEY_DIRTY(k);
>  }
>
> @@ -359,11 +363,24 @@ next:
>         }
>  }
>
> +/*
> + * Returns true if we scanned the entire disk
> + */
>  static bool refill_dirty(struct cached_dev *dc)
>  {
>         struct keybuf *buf = &dc->writeback_keys;
> +       struct bkey start = KEY(dc->disk.id, 0, 0);
>         struct bkey end = KEY(dc->disk.id, MAX_KEY_OFFSET, 0);
> -       bool searched_from_start = false;
> +       struct bkey start_pos;
> +
> +       /*
> +        * make sure keybuf pos is inside the range for this disk - at bringup
> +        * we might not be attached yet so this disk's inode nr isn't
> +        * initialized then
> +        */
> +       if (bkey_cmp(&buf->last_scanned, &start) < 0 ||
> +           bkey_cmp(&buf->last_scanned, &end) > 0)
> +               buf->last_scanned = start;
>
>         if (dc->partial_stripes_expensive) {
>                 refill_full_stripes(dc);
> @@ -371,14 +388,20 @@ static bool refill_dirty(struct cached_dev *dc)
>                         return false;
>         }
>
> -       if (bkey_cmp(&buf->last_scanned, &end) >= 0) {
> -               buf->last_scanned = KEY(dc->disk.id, 0, 0);
> -               searched_from_start = true;
> -       }
> -
> +       start_pos = buf->last_scanned;
>         bch_refill_keybuf(dc->disk.c, buf, &end, dirty_pred);
>
> -       return bkey_cmp(&buf->last_scanned, &end) >= 0 && searched_from_start;
> +       if (bkey_cmp(&buf->last_scanned, &end) < 0)
> +               return false;
> +
> +       /*
> +        * If we get to the end start scanning again from the beginning, and
> +        * only scan up to where we initially started scanning from:
> +        */
> +       buf->last_scanned = start;
> +       bch_refill_keybuf(dc->disk.c, buf, &start_pos, dirty_pred);
> +
> +       return bkey_cmp(&buf->last_scanned, &start_pos) >= 0;
>  }
>
>  static void bch_writeback(struct cached_dev *dc)
> --
> 2.5.1
>



-- 

Denis
