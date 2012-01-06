From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: Write-only Caching Without Backing
Date: Fri, 06 Jan 2012 11:57:42 +0000
Message-ID: <4F06E1B6.5020304@bobich.net>
References: <4F06C3E8.3040001@bobich.net> <CAH+dOxKZs7HRqXtvgfO4M3GQTUS078OOwf0jtTM1Gefp05XCRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxKZs7HRqXtvgfO4M3GQTUS078OOwf0jtTM1Gefp05XCRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

In the case of non-persistent data like swap, that sounds about right.

But is that also applicable to the persistent data use-case? In that 
case what is really needed is a selective write-cache, with no 
read-cache. I say selective because small non-sequential writes should 
get cached, but sequential writes should go straight to the backing store.

In the particular use-case I'm looking at, the time cost of randomly 
writing 4KB blocks is virtually the same as the cost of writing 8KB 
blocks (unless you are straddling erase block boundaries, in which case 
it is 2x), so even setting the threshold "small" at 1 block would boost 
the speed by 2x in the average case. But this will vary with different 
media so should be adjustable for optimal results.

Or were you suggesting that we don't use the separate backing storage at 
all even for persistent data, and just make the full size of the media 
into a persistent cache that we store the actual data in? In effect 
making it into something similar to nilfs, only on block level rather 
than fs level and with cleverer garbage collection that causes less 
write-amplification? The main problem with nilfs is that it's garbage 
collector isn't particularly clever and causes a lot of unnecessary 
flash wear because it will reclaim and re-write an entire block (8MB by 
default IIRC) even if only a few KB are dirty, and I'm not even 
convinced it does GC in the order of dirtiest block first.

Gordan

Kent Overstreet wrote:
> What you're describing would be best served not by using bcache as a
> cache, but by using it only store data in the "cache device" - using
> it as a better ftl, really.
> 
> That feature's on the roadmap, mostly just need to implement a moving
> garbage collector - shouldn't be that much work.
> 
> On Fri, Jan 6, 2012 at 1:50 AM, Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org> wrote:
>> Hi,
>>
>> I'm looking at whether Bcache can be used (or easily modified to be used)
>> for rectifying the poor random write performance of cheap flash media.
>>
>> I am aware of the following projects that provide similar functionality to
>> what I require:
>>
>> Managed Flash (MFT) (not OSS, purely commercial, requires a substantial
>> amount of RAM for mapping)
>> ReSSD (research paper, requires less RAM than MFT, no code available)
>>
>> Unfortunately, I am specifically interested in this for ARM machines that
>> frequently don't have SATA ports but only SD card ports. Most SD cards have
>> exceptionally poor random-write performance, and since the only
>> semi-solution (MFT requires a substantial amount of RAM which is also an
>> issue on a 256MB ARM machine) doesn't support ARM, I'm looking for
>> alternatives.
>>
>> So what I envisage (hope for?) is using Bcache in a way that does
>> random-write caching by linearizing writes into sequential writes. My
>> performance tests indicate that even with small blocks (4KB) and even on
>> some of the best SD cards, sequential writes are still at least 3-4x faster
>> than random writes. On the worst SD cards, the difference can be as much as
>> 100x.
>>
>> Note that this would involve having a "cache" partition on the same SD card.
>>
>> However, the random read performance on these is very good (as good as any
>> flash), and typical measurements are 500-1500 IOPS on random reads.
>> Therefore, there is no point in caching data for reading, since the read
>> performance from the cache partition would be the same as the read
>> performance off the real data source.
>>
>> The other use case I envisage is for things like swap that don't need to be
>> persisted across reboots, and thus don't need to be committed back to
>> backing storage from cache (i.e. it is OK for them to disappear on reboot).
>> In this use-case, I would like to use Bcache without the backing storage -
>> simply use it in write-back caching mode without committing anything back,
>> and re-using blocks as and when they get over-written (or perhaps use a
>> discard feature for early pruning?).
>>
>> So to summarize:
>> 1) Can Bcache be configured or relatively easily modified to only do
>> random-write caching with no read caching (except in cases where there is a
>> request for written data that hasn't yet been committed to the backing
>> storage)?
>> 2) Can Bcache be used in full write-back-only mode without backing data
>> store for non-persistent data?
>>
>> Thanks.
>>
>> Gordan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
