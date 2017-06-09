From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: fix issue of writeback rate at minimum 1 blockper
 second
Date: Fri, 9 Jun 2017 13:21:40 +0800
Message-ID: <c98a6667-aad2-9b83-6392-a36d0491f986@coly.li>
References: <201706091026072913490@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:44398 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751509AbdFIFVz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Jun 2017 01:21:55 -0400
In-Reply-To: <201706091026072913490@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, bcache@lists.ewheeler.net
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2017/6/9 上午10:26, tang.junhui@zte.com.cn wrote:
> Hello Eric,
> 
> 
> ＞
> It would be nice if ZERO_RATE_DELAY_NS was configurable via sysfs, as some 
> ＞ might want a longer delay than 30s.
> 
> How about we reuse the dc-＞writeback_delay configuration for the delay
> time?
> 
> 
> ＞
> Also, if zero-rate has been hit, why not have a full-writeback of whatever 
> ＞ remains so we only use the ZERO_RATE_DELAY_NS when dirty_data==0?  No 
> ＞ sense in leaving it slightly dirty if there is only a block or two still 
> ＞ remaining.
> 
> I think it's risky, write IO maybe in continue, we should to accumulate
> more dirty data
> 
> to make writeback sequentially, otherwise, the full-writeback would be
> inefficient when there
> 
> is only a little dirty, as it is small and random IOs, and the write IO
> are in continue.
>

Make sense. So what is the expected behavior of ZERO_RATE_DELAY_NS from
your design? Can I guess in this way,

- If I/O goes into cache device, delay is not expired, no writeback.
- If delay expired, dirty data does not reach threshold, no writeback.
- If delay expired, and dirty data reaches threshold, start to writeback.

Thanks.

Coly



> 
> So, Eric, would you agree to just modify this patch to
> reuse dc-＞writeback_delay as
> 
> the delay time?
> 
> 
> Acctually, we do many optimizations for writeback in our product, such
> as the issue that 
> 
> the dirty device never get clean (we start full-writeback when we find
> there is no more write
> 
> IOs in comming), these modifications make bcache works better. 
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
> *发件人：*＜bcache@lists.ewheeler.net＞;
> *收件人：*＜i@coly.li＞;
> *抄送人：*唐军辉10074136;＜kent.overstreet@gmail.com＞;＜linux-
> bcache@vger.kernel.org＞;
> *日 期 ：*2017年06月09日 09:43
> *主 题 ：**Re: [PATCH] bcache: fix issue of writeback rate at minimum 1
> blockper second*
> 
> 
> On Fri, 9 Jun 2017, Coly Li wrote:
> 
> ＞ On 2017/6/8 下午5:34, tang.junhui@zte.com.cn wrote:
> ＞ ＞ From: Tang Junhui ＜tang.junhui@zte.com.cn＞
> ＞ ＞ 
> ＞ ＞ When there is not enough data in writeback cache, let the writeback rate
> ＞ ＞ to be 0, and delay 30 seconds in read_dirty().
> ＞ ＞ 
> ＞ 
> ＞ I feel uncomfortable to the above idea. Is the purpose of this change is
> ＞ to make writeback more efficient with more dirty data ? Or some other
> ＞ reason that you want to make this change?
> ＞ 
> ＞ When data writing back to the backing device, most of the writes are
> ＞ random. If the backing device is a hard disk, the write back rate will
> ＞ be very slow. Such a longer delay only makes more data accumulated in
> ＞ writeback cache, does not help the writeback rate indeed.
> ＞ 
> ＞ Do you observe performance improvement by this patch ? If yes, I'd like
> ＞ to see the performance number.
> 
> Its not a performance issue, it is a power saving issue.  Laptop users 
> have reported that zero-rate writeback writes 512-bytes every second and 
> never lets the HDD spin down and several users on the list have asked for 
> such a bugfix.
> 
> It would be nice if ZERO_RATE_DELAY_NS was configurable via sysfs, as some 
> might want a longer delay than 30s.
> 
> Also, if zero-rate has been hit, why not have a full-writeback of whatever 
> remains so we only use the ZERO_RATE_DELAY_NS when dirty_data==0?  No 
> sense in leaving it slightly dirty if there is only a block or two still 
> remaining.
> 
> 
> --
> Eric Wheeler
[snip]


-- 
Coly Li
