From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: bcache kernel 3.10 wrong bypassed values
Date: Fri, 12 Jul 2013 13:18:35 +0200
Message-ID: <51DFE60B.6040701@profihost.ag>
References: <51D52EA0.80302@profihost.ag> <20130712015559.GF17799@kmo-pixel> <51DF9E90.8070408@profihost.ag> <20130712082031.GC8339@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130712082031.GC8339@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Am 12.07.2013 10:20, schrieb Kent Overstreet:
> On Fri, Jul 12, 2013 at 08:13:36AM +0200, Stefan Priebe - Profihost AG wrote:
>> Am 12.07.2013 03:55, schrieb Kent Overstreet:
>>> On Thu, Jul 04, 2013 at 10:13:20AM +0200, Stefan Priebe - Profihost AG wrote:
>>>> Hello list,
>>>>
>>>> while testing bcache i noticed that while writing a big 48GB file the
>>>> sequential cutoff works fine i see only I/O on the disk but not on the
>>>> cache. I thought i would afterwards see a bypassed value of around 48GB
>>>> but it is only 1.2GB.
>>>>
>>>> Is this expected? Is bcache in kernel 3.10 stable for production usage?
>>>
>>> That sounds like a bug, but bcache in 3.10 certainly should be stable
>>> for production usage.
>>>
>>> There can be some weirdness due to the way the stats work, there's a ~13
>>> second update interval (and also the intermediate counters are 32 bit
>>> ints so if you manage to wrap that in 13 seconds you'll lose counts, but
>>> it's counting sectors so I doubt that happened here).
>>
>> Mhm i doubt that too. But if i write 40GB shouldn't i see a bypass value
>> near 40GB? It's just very small.
>>
>>> Does that sound like it might explain what you were seeing, or do you
>>> think there's something else going on?
>> No right no i don't believe that.
> 
> Have you noticed any pattern to it? Does it appear to sometimes be right
> and sometimes wrong, or is it always wrong?

It seems that the dirty stats starts with 0 after a reboot but there
might still be some dirty data in it?

> I looked again at the code that updates that value and I'm not coming up
> with any ideas to explain what you're seeing...

Output:
  Rawdisk: /dev/sde1 (rawdisk10) | Cachedisk: /dev/sdb4 (bcachessd2)
      Read MB/s |      Write MB/s |       Read MB/s |      Write MB/s |
Dirty | Bypassed
         (op/s) |          (op/s) |          (op/s) |          (op/s) |
      |

    0.00 (   0) |    18.45 ( 119) |     5.57 (  58) |     6.06 (  60) |
-16.3M | 68.9M
    0.00 (   0) |     0.00 (   7) |     0.01 (   2) |     7.10 (  39) |
-12.5M | 68.9M
    0.00 (   1) |     0.00 (   4) |     0.06 (   8) |    23.29 ( 100) |
-3.1M | 67.9M
    0.00 (   0) |     0.00 (   7) |     0.04 (   8) |    21.43 (  82) |
 9.5M | 67.9M
    0.04 (   8) |     0.00 (   3) |     0.02 (   3) |     4.81 (  73) |
11.0M | 67.9M
    0.00 (   0) |     0.64 (  12) |     0.02 (   5) |    19.68 ( 139) |
26.9M | 67.9M
    0.00 (   0) |     0.00 (   5) |     0.02 (   4) |     4.61 (  36) |
31.4M | 67.9M

Stefan
