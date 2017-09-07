From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: implement PI controller for writeback rate
Date: Thu, 7 Sep 2017 13:27:32 +0800
Message-ID: <fbf97a92-14fe-79f0-60fb-6dd595d670ae@coly.li>
References: <20170906075642.12888-1-mlyle@lyle.org>
 <CAJ+L6qc6OHoDvyKAsKRoD0-JCmZsUjpi8AObEjKjkQ-KqGCg_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:36400 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752525AbdIGF1h (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Sep 2017 01:27:37 -0400
In-Reply-To: <CAJ+L6qc6OHoDvyKAsKRoD0-JCmZsUjpi8AObEjKjkQ-KqGCg_w@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/9/7 上午9:54, Michael Lyle wrote:
> Hey everyone---
> 
> I'd appreciate any feedback you all can lend on this changeset.  I
> know it's a bit of an awkward time with the opening of the merge
> window to have a new functional change show up.  I also would
> appreciate any comments on process / how to go about submitting work,
> as I have not been active in the Linux kernel community in quite some
> time.
> 
> This change makes a pretty substantial difference in the smoothness of
> IO rates on my cached VM environment.  I see a couple of problems with
> further review: I have an incorrect comment about the default p term
> value, and there is a small bit of conflict with the patches that have
> just gone out.  I can fix both of these quickly in a subsequent
> revision.
> 
> It's also helpful for intermittent workloads to be able to write at a
> somewhat higher rate out to disk.  Spending a few percent of disk
> bandwidth on flushing dirty data-- to leave room to deal with new
> bursts of workload-- is very helpful.

Hi Michael,

One thing I care about is I/O latency of regular read/write requests.
For current PD controller, I observe the writeback rate can decrease
very fast to 1 sector/second to give almost all bandwidth to frond end
I/O requests. This behavior is good for data base users.

For this PI controller, I need to do more testing, and observe how it
works and behaves with different work loads. Before I am confident with
it for most of workloads I know, I am not able to response you very
fast. It will take time.

If you may provide more performance data (e.g. requests latency
distribution) comparing to current PD controller, that will be very
helpful for people to response this patch. For now, I need to understand
and test this patch.

Thanks.

Coly Li

> 
> 
> On Wed, Sep 6, 2017 at 12:56 AM, Michael Lyle <mlyle@lyle.org> wrote:
>> bcache uses a control system to attempt to keep the amount of dirty data
>> in cache at a user-configured level, while not responding excessively to
>> transients and variations in write rate.  Previously, the system was a
>> PD controller; but the output from it was integrated, turning the
>> Proportional term into an Integral term, and turning the Derivative term
>> into a crude Proportional term.  Performance of the controller has been
>> uneven in production, and it has tended to respond slowly, oscillate,
>> and overshoot.
>>
>> This patch set replaces the current control system with an explicit PI
>> controller and tuning that should be correct for most hardware.  By
>> default, it attempts to write at a rate that would retire 1/40th of the
>> current excess blocks per second.  An integral term in turn works to
>> remove steady state errors.
>>
>> IMO, this yields benefits in simplicity (removing weighted average
>> filtering, etc) and system performance.
>>
>> Another small change is a tunable parameter is introduced to allow the
>> user to specify a minimum rate at which dirty blocks are retired.
>> Ideally one would set this writeback_rate_minimum to a small percentage
>> of disk bandwidth, allowing the dirty data to be slowly cleaned out when
>> the system is inactive.  The old behavior would try and retire 1
>> sector/second, and the new default is 5 sectors/second.
>>
>> Signed-off-by: Michael Lyle <mlyle@lyle.org>
>> ---
>>  drivers/md/bcache/bcache.h    |  9 +++--
>>  drivers/md/bcache/sysfs.c     | 19 +++++-----
>>  drivers/md/bcache/writeback.c | 84 +++++++++++++++++++++++--------------------
>>  3 files changed, 60 insertions(+), 52 deletions(-)
>>
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index dee542fff68e..f1cdf92e7399 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -265,9 +265,6 @@ struct bcache_device {
>>         atomic_t                *stripe_sectors_dirty;
>>         unsigned long           *full_dirty_stripes;
>>
>> -       unsigned long           sectors_dirty_last;
>> -       long                    sectors_dirty_derivative;
>> -
>>         struct bio_set          *bio_split;
>>
>>         unsigned                data_csum:1;
>> @@ -361,12 +358,14 @@ struct cached_dev {
>>
>>         uint64_t                writeback_rate_target;
>>         int64_t                 writeback_rate_proportional;
>> -       int64_t                 writeback_rate_derivative;
>> +       int64_t                 writeback_rate_integral;
>> +       int64_t                 writeback_rate_integral_scaled;
>>         int64_t                 writeback_rate_change;
>>
>>         unsigned                writeback_rate_update_seconds;
>> -       unsigned                writeback_rate_d_term;
>> +       unsigned                writeback_rate_i_term_inverse;
>>         unsigned                writeback_rate_p_term_inverse;
>> +       unsigned                writeback_rate_minimum;
>>  };
>>
>>  enum alloc_reserve {
>> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
>> index f90f13616980..66a716d5f111 100644
>> --- a/drivers/md/bcache/sysfs.c
>> +++ b/drivers/md/bcache/sysfs.c
>> @@ -81,8 +81,9 @@ rw_attribute(writeback_delay);
>>  rw_attribute(writeback_rate);
>>
>>  rw_attribute(writeback_rate_update_seconds);
>> -rw_attribute(writeback_rate_d_term);
>> +rw_attribute(writeback_rate_i_term_inverse);
>>  rw_attribute(writeback_rate_p_term_inverse);
>> +rw_attribute(writeback_rate_minimum);
>>  read_attribute(writeback_rate_debug);
>>
>>  read_attribute(stripe_size);
>> @@ -130,15 +131,16 @@ SHOW(__bch_cached_dev)
>>         sysfs_hprint(writeback_rate,    dc->writeback_rate.rate << 9);
>>
>>         var_print(writeback_rate_update_seconds);
>> -       var_print(writeback_rate_d_term);
>> +       var_print(writeback_rate_i_term_inverse);
>>         var_print(writeback_rate_p_term_inverse);
>> +       var_print(writeback_rate_minimum);
>>
>>         if (attr == &sysfs_writeback_rate_debug) {
>>                 char rate[20];
>>                 char dirty[20];
>>                 char target[20];
>>                 char proportional[20];
>> -               char derivative[20];
>> +               char integral[20];
>>                 char change[20];
>>                 s64 next_io;
>>
>> @@ -146,7 +148,7 @@ SHOW(__bch_cached_dev)
>>                 bch_hprint(dirty,       bcache_dev_sectors_dirty(&dc->disk) << 9);
>>                 bch_hprint(target,      dc->writeback_rate_target << 9);
>>                 bch_hprint(proportional,dc->writeback_rate_proportional << 9);
>> -               bch_hprint(derivative,  dc->writeback_rate_derivative << 9);
>> +               bch_hprint(integral,    dc->writeback_rate_integral_scaled << 9);
>>                 bch_hprint(change,      dc->writeback_rate_change << 9);
>>
>>                 next_io = div64_s64(dc->writeback_rate.next - local_clock(),
>> @@ -157,11 +159,11 @@ SHOW(__bch_cached_dev)
>>                                "dirty:\t\t%s\n"
>>                                "target:\t\t%s\n"
>>                                "proportional:\t%s\n"
>> -                              "derivative:\t%s\n"
>> +                              "integral:\t%s\n"
>>                                "change:\t\t%s/sec\n"
>>                                "next io:\t%llims\n",
>>                                rate, dirty, target, proportional,
>> -                              derivative, change, next_io);
>> +                              integral, change, next_io);
>>         }
>>
>>         sysfs_hprint(dirty_data,
>> @@ -213,7 +215,7 @@ STORE(__cached_dev)
>>                             dc->writeback_rate.rate, 1, INT_MAX);
>>
>>         d_strtoul_nonzero(writeback_rate_update_seconds);
>> -       d_strtoul(writeback_rate_d_term);
>> +       d_strtoul(writeback_rate_i_term_inverse);
>>         d_strtoul_nonzero(writeback_rate_p_term_inverse);
>>
>>         d_strtoi_h(sequential_cutoff);
>> @@ -319,8 +321,9 @@ static struct attribute *bch_cached_dev_files[] = {
>>         &sysfs_writeback_percent,
>>         &sysfs_writeback_rate,
>>         &sysfs_writeback_rate_update_seconds,
>> -       &sysfs_writeback_rate_d_term,
>> +       &sysfs_writeback_rate_i_term_inverse,
>>         &sysfs_writeback_rate_p_term_inverse,
>> +       &sysfs_writeback_rate_minimum,
>>         &sysfs_writeback_rate_debug,
>>         &sysfs_dirty_data,
>>         &sysfs_stripe_size,
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index 42c66e76f05e..76e71e8ef356 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -24,48 +24,55 @@ static void __update_writeback_rate(struct cached_dev *dc)
>>         uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size;
>>         uint64_t cache_dirty_target =
>>                 div_u64(cache_sectors * dc->writeback_percent, 100);
>> -
>>         int64_t target = div64_u64(cache_dirty_target * bdev_sectors(dc->bdev),
>>                                    c->cached_dev_sectors);
>>
>> -       /* PD controller */
>> -
>> +       /* PI controller:
>> +        * Figures out the amount that should be written per second.
>> +        *
>> +        * First, the error (number of sectors that are dirty beyond our
>> +        * target) is calculated.  The error is accumulated (numerically
>> +        * integrated).
>> +        *
>> +        * Then, the proportional value and integral value are scaled
>> +        * based on configured values.  These are stored as inverses to
>> +        * avoid fixed point math and to make configuration easy-- e.g.
>> +        * the default value of 100 for writeback_rate_p_term_inverse
>> +        * attempts to write at a rate that would retire all the dirty
>> +        * blocks in 100 seconds.
>> +        */
>>         int64_t dirty = bcache_dev_sectors_dirty(&dc->disk);
>> -       int64_t derivative = dirty - dc->disk.sectors_dirty_last;
>> -       int64_t proportional = dirty - target;
>> -       int64_t change;
>> -
>> -       dc->disk.sectors_dirty_last = dirty;
>> -
>> -       /* Scale to sectors per second */
>> -
>> -       proportional *= dc->writeback_rate_update_seconds;
>> -       proportional = div_s64(proportional, dc->writeback_rate_p_term_inverse);
>> -
>> -       derivative = div_s64(derivative, dc->writeback_rate_update_seconds);
>> -
>> -       derivative = ewma_add(dc->disk.sectors_dirty_derivative, derivative,
>> -                             (dc->writeback_rate_d_term /
>> -                              dc->writeback_rate_update_seconds) ?: 1, 0);
>> -
>> -       derivative *= dc->writeback_rate_d_term;
>> -       derivative = div_s64(derivative, dc->writeback_rate_p_term_inverse);
>> -
>> -       change = proportional + derivative;
>> +       int64_t error = dirty - target;
>> +       int64_t proportional_scaled =
>> +               div_s64(error, dc->writeback_rate_p_term_inverse);
>> +       int64_t integral_scaled, new_rate;
>> +
>> +       if ((error < 0 && dc->writeback_rate_integral > 0) ||
>> +           (error > 0 && time_before64(local_clock(),
>> +                        dc->writeback_rate.next + NSEC_PER_MSEC))) {
>> +               /* Only decrease the integral term if it's more than
>> +                * zero.  Only increase the integral term if the device
>> +                * is keeping up.  (Don't wind up the integral
>> +                * ineffectively in either case).
>> +                *
>> +                * It's necessary to scale this by
>> +                * writeback_rate_update_seconds to keep the integral
>> +                * term dimensioned properly.
>> +                */
>> +               dc->writeback_rate_integral += error *
>> +                       dc->writeback_rate_update_seconds;
>> +       }
>>
>> -       /* Don't increase writeback rate if the device isn't keeping up */
>> -       if (change > 0 &&
>> -           time_after64(local_clock(),
>> -                        dc->writeback_rate.next + NSEC_PER_MSEC))
>> -               change = 0;
>> +       integral_scaled = div_s64(dc->writeback_rate_integral,
>> +                       dc->writeback_rate_i_term_inverse);
>>
>> -       dc->writeback_rate.rate =
>> -               clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
>> -                       1, NSEC_PER_MSEC);
>> +       new_rate = clamp_t(int64_t, (proportional_scaled + integral_scaled),
>> +                       dc->writeback_rate_minimum, NSEC_PER_MSEC);
>>
>> -       dc->writeback_rate_proportional = proportional;
>> -       dc->writeback_rate_derivative = derivative;
>> -       dc->writeback_rate_change = change;
>> +       dc->writeback_rate_proportional = proportional_scaled;
>> +       dc->writeback_rate_integral_scaled = integral_scaled;
>> +       dc->writeback_rate_change = new_rate - dc->writeback_rate.rate;
>> +       dc->writeback_rate.rate = new_rate;
>>         dc->writeback_rate_target = target;
>>  }
>>
>> @@ -491,8 +498,6 @@ void bch_sectors_dirty_init(struct cached_dev *dc)
>>
>>         bch_btree_map_keys(&op.op, dc->disk.c, &KEY(op.inode, 0, 0),
>>                            sectors_dirty_init_fn, 0);
>> -
>> -       dc->disk.sectors_dirty_last = bcache_dev_sectors_dirty(&dc->disk);
>>  }
>>
>>  void bch_cached_dev_writeback_init(struct cached_dev *dc)
>> @@ -506,10 +511,11 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>>         dc->writeback_percent           = 10;
>>         dc->writeback_delay             = 30;
>>         dc->writeback_rate.rate         = 1024;
>> +       dc->writeback_rate_minimum      = 5;
>>
>>         dc->writeback_rate_update_seconds = 5;
>> -       dc->writeback_rate_d_term       = 30;
>> -       dc->writeback_rate_p_term_inverse = 6000;
>> +       dc->writeback_rate_p_term_inverse = 40;
>> +       dc->writeback_rate_i_term_inverse = 10000;
>>
>>         INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
>>  }
>> --
>> 2.11.0
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
