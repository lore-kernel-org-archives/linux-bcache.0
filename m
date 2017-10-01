From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sun, 1 Oct 2017 12:51:44 +0800
Message-ID: <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li>
 <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li>
 <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
 <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li>
 <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
 <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/10/1 上午6:49, Michael Lyle wrote:
> One final attempt to resend, because gmail has been giving me trouble
> sending plain text mail.
> 
> Two instances of this.  Tested as above, with a big set of random I/Os
> that ultimately cover every block in a file (e.g. allowing sequential
> writeback).
> 
> With the 5 patches, samsung 940 SSD cache + crummy 5400 RPM USB hard drive:
> 
> Typical seconds look like:
> 
> Reading 38232K from cache in 4809 IO.  38232/4809=7.95k per cache device IO.
> 
> Writing 38112k to cache in 400 I/O = 95.28k -- or we are combining
> about 11.9 extents to a contiguous writeback.  Tracing, there are
> still contiguous things that are not getting merged well, but it's OK.
> (I'm hoping plugging makes this better).
> 
> sda            4809.00     38232.00       446.00      38232        446
> sdb             400.00         0.00     38112.00          0      38112
> 
> Without the 5 patches, a typical second--
> 
> sda            2509.00     19968.00       316.00      19968        316
> sdb             502.00         0.00     19648.00          0      38112
> 
> or we are combining about 4.9 extents to a contiguous writeback, and
> writing back at about half the rate.  All of these numbers are +/- 10%
> and obtained by eyeballing and grabbing representative seconds.
> 
> Mike
> 
> On Sat, Sep 30, 2017 at 2:02 AM, Michael Lyle <mlyle@lyle.org> wrote:
>>
>> Resent because I can't seem to get gmail to not send HTML mail.  And off to sleep.
>>
>>
>> On Sat, Sep 30, 2017 at 1:57 AM, Michael Lyle <mlyle@lyle.org> wrote:
>>> Two instances of this.
>>>
>>> With the 5 patches, samsung 940 SSD cache + crummy 5400 RPM USB hard drive:
>>>
>>> Typical seconds look like:
>>>
>>> Reading 38232K from cache in 4809 IO.  38232/4809=7.95k per cache device IO.
>>>
>>> Writing 38112k to cache in 400 I/O = 95.28k -- or we are combining about
>>> 11.9 extents to a contiguous writeback.  Tracing, there are still contiguous
>>> things that are not getting merged well, but it's OK.  (I'm hoping plugging
>>> makes this better).
>>>
>>> sda            4809.00     38232.00       446.00      38232        446
>>> sdb             400.00         0.00     38112.00          0      38112
>>>
>>> Without the 5 patches, a typical second--
>>>
>>> sda            2509.00     19968.00       316.00      19968        316
>>> sdb             502.00         0.00     19648.00          0      38112
>>>
>>> or we are combining about 4.9 extents to a contiguous writeback, and writing
>>> back at about half the rate.

Hi Mike,

Get it. Now I am testing your patches (all 5 patches). It has been 12+
hours, should be 12+ hours more. The backing device is a raid0 composed
by 4x1.8T 2.5inch harddisk, cache device is a 3.8T NVMe SSD. Block size
is 512K.

Hope it works as you expected on my server.

-- 
Coly Li
