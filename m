From: bcache@lists.ewheeler.net
Subject: Re: Re: [PATCH] bcache: fix issue of writeback rate at minimum 1
 blockper second
Date: Sat, 17 Jun 2017 00:23:18 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706162158120.17052@mail.ewheeler.net>
References: 1496914493-8460-1-git-send-email-tang.junhui@zte.com.cn,96f83b23-bc36-55a6-2a04-236594a0abd2@coly.li,alpine.LRH.2.11.1706090140250.19359@mail.ewheeler.net <201706091026072913490@zte.com.cn>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-2105245779-1497659002=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:52352 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751845AbdFQAXY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Jun 2017 20:23:24 -0400
In-Reply-To: <201706091026072913490@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: i@coly.li, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-2105245779-1497659002=:17052
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 9 Jun 2017, tang.junhui@zte.com.cn wrote:
> Hello Eric,
> 
> 
> ＞ It would be nice if ZERO_RATE_DELAY_NS was configurable via sysfs, as some 
> ＞ might want a longer delay than 30s.
> 
> How about we reuse the dc-＞writeback_delay configuration for the delay time?

That seems reasonable.

For small writeback caches where the cache could be exhausted while in 
schedule_timeout(), will IOs stall until schedule_timeout() allows 
writeback_thread to proceed?


> ＞ Also, if zero-rate has been hit, why not have a full-writeback of 
> whatever ＞ remains so we only use the ZERO_RATE_DELAY_NS when 
> dirty_data==0?  No ＞ sense in leaving it slightly dirty if there is 
> only a block or two still ＞ remaining.
> 
> I think it's risky, write IO maybe in continue, we should to accumulate 
> more dirty data

ok, agreed---also I note that writeback is still 10% dirty by default, so 
it could be a large amount of data.  The cache is always seeking to hit 
dirty_ratio and this is what the 1-sector writeback fix is targetd for.

> 
> to make writeback sequentially, otherwise, the full-writeback would be 
> inefficient when there
> 
> is only a little dirty, as it is small and random IOs, and the write IO 
> are in continue.
> 
> 
> So, Eric, would you agree to just modify this patch to reuse 
> dc-＞writeback_delay as
> 
> the delay time?

Yes that seems OK, unless someone else says otherwise.

> 
> Acctually, we do many optimizations for writeback in our product, such 
> as the issue that the dirty device never get clean (we start 
> full-writeback when we find there is no more write IOs in comming), 
> these modifications make bcache works better.

I would be interested in seeing other optimization patches if you have 
any.  Thank you for your work on this!

-Eric

> 
> 
> Regards,
> 
> Tang Junhui
> 
> 
> 
> 
> 原始邮件
> 发件人： ＜bcache@lists.ewheeler.net＞;
> 收件人： ＜i@coly.li＞;
> 抄送人：唐军辉10074136; ＜kent.overstreet@gmail.com＞; ＜linux-bcache@vger.kernel.org＞;
> 日 期 ：2017年06月09日 09:43
> 主 题 ：Re: [PATCH] bcache: fix issue of writeback rate at minimum 1 blockper second
> 
> 
> On Fri, 9 Jun 2017, Coly Li wrote:
> 
> ＞ On 2017/6/8 下午5:34, tang.junhui@zte.com.cn wrote:
> ＞ ＞ From: Tang Junhui ＜tang.junhui@zte.com.cn＞
> ＞ ＞ 
> ＞ ＞ When there is not enough data in writeback cache, let the writeback rate
> ＞ ＞ to be 0, and delay 30 seconds in read_dirty().
> ＞ ＞ 
> ＞ 
> ＞ I feel uncomfortable to the above idea. Is the purpose of this change is
> ＞ to make writeback more efficient with more dirty data ? Or some other
> ＞ reason that you want to make this change?
> ＞ 
> ＞ When data writing back to the backing device, most of the writes are
> ＞ random. If the backing device is a hard disk, the write back rate will
> ＞ be very slow. Such a longer delay only makes more data accumulated in
> ＞ writeback cache, does not help the writeback rate indeed.
> ＞ 
> ＞ Do you observe performance improvement by this patch ? If yes, I'd like
> ＞ to see the performance number.
> 
> Its not a performance issue, it is a power saving issue.  Laptop users 
> have reported that zero-rate writeback writes 512-bytes every second and 
> never lets the HDD spin down and several users on the list have asked for 
> such a bugfix.
> 
> It would be nice if ZERO_RATE_DELAY_NS was configurable via sysfs, as some 
> might want a longer delay than 30s.
> 
> Also, if zero-rate has been hit, why not have a full-writeback of whatever 
> remains so we only use the ZERO_RATE_DELAY_NS when dirty_data==0?  No 
> sense in leaving it slightly dirty if there is only a block or two still 
> remaining.
> 
> 
> --
> Eric Wheeler
> 
> 
> 
> ＞ 
> ＞ Thanks.
> ＞ 
> ＞ Coly
> ＞ 
> ＞ 
> ＞ ＞ Signed-off-by: Tang Junhui ＜tang.junhui@zte.com.cn＞
> ＞ ＞ ---
> ＞ ＞  drivers/md/bcache/util.c      | 17 ++++++++++++-----
> ＞ ＞  drivers/md/bcache/writeback.c |  2 +-
> ＞ ＞  2 files changed, 13 insertions(+), 6 deletions(-)
> ＞ ＞ 
> ＞ ＞ diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> ＞ ＞ index dde6172..cf750df 100644
> ＞ ＞ --- a/drivers/md/bcache/util.c
> ＞ ＞ +++ b/drivers/md/bcache/util.c
> ＞ ＞ @@ -15,6 +15,8 @@
> ＞ ＞  
> ＞ ＞  #include "util.h"
> ＞ ＞  
> ＞ ＞ +#define ZERO_RATE_DELAY_NS    30*NSEC_PER_SEC
> ＞ ＞ +
> ＞ ＞  #define simple_strtoint(c, end, base)    simple_strtol(c, end, base)
> ＞ ＞  #define simple_strtouint(c, end, base)    simple_strtoul(c, end, base)
> ＞ ＞  
> ＞ ＞ @@ -209,13 +211,18 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
> ＞ ＞  {
> ＞ ＞      uint64_t now = local_clock();
> ＞ ＞  
> ＞ ＞ -    d-＞next += div_u64(done * NSEC_PER_SEC, d-＞rate);
> ＞ ＞ +    if (!d-＞rate) {
> ＞ ＞ +        d-＞next = now + ZERO_RATE_DELAY_NS;
> ＞ ＞ +    }
> ＞ ＞ +    else {
> ＞ ＞ +        d-＞next += div_u64(done * NSEC_PER_SEC, d-＞rate);
> ＞ ＞  
> ＞ ＞ -    if (time_before64(now + NSEC_PER_SEC, d-＞next))
> ＞ ＞ -        d-＞next = now + NSEC_PER_SEC;
> ＞ ＞ +        if (time_before64(now + NSEC_PER_SEC, d-＞next))
> ＞ ＞ +            d-＞next = now + NSEC_PER_SEC;
> ＞ ＞  
> ＞ ＞ -    if (time_after64(now - NSEC_PER_SEC * 2, d-＞next))
> ＞ ＞ -        d-＞next = now - NSEC_PER_SEC * 2;
> ＞ ＞ +        if (time_after64(now - NSEC_PER_SEC * 2, d-＞next))
> ＞ ＞ +            d-＞next = now - NSEC_PER_SEC * 2;
> ＞ ＞ +    }
> ＞ ＞  
> ＞ ＞      return time_after64(d-＞next, now)
> ＞ ＞          ? div_u64(d-＞next - now, NSEC_PER_SEC / HZ)
> ＞ ＞ diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> ＞ ＞ index 69e1ae5..8fac280 100644
> ＞ ＞ --- a/drivers/md/bcache/writeback.c
> ＞ ＞ +++ b/drivers/md/bcache/writeback.c
> ＞ ＞ @@ -60,7 +60,7 @@ static void __update_writeback_rate(struct cached_dev *dc)
> ＞ ＞  
> ＞ ＞      dc-＞writeback_rate.rate =
> ＞ ＞          clamp_t(int64_t, (int64_t) dc-＞writeback_rate.rate + change,
> ＞ ＞ -            1, NSEC_PER_MSEC);
> ＞ ＞ +            0, NSEC_PER_MSEC);
> ＞ ＞  
> ＞ ＞      dc-＞writeback_rate_proportional = proportional;
> ＞ ＞      dc-＞writeback_rate_derivative = derivative;
> ＞ ＞ 
> ＞ --
> ＞ To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> ＞ the body of a message to majordomo@vger.kernel.org
> ＞ More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ＞ 
> 
> 
> 
> 
> 
--1641074820-2105245779-1497659002=:17052--
