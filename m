From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: Kernel panic with current bcache-3.2 branch.
Date: Fri, 17 Aug 2012 14:07:11 +1000
Message-ID: <CAOzFzEjvyPdv63-a_PMKZTQrvgOHpu6aVyxv8EFZY71Rb3DHJg@mail.gmail.com>
References: <CAOzFzEiS3MWe39C+XinBP3fN-Kw8Hs6n3oyqixrMVZpsuMhLcw@mail.gmail.com>
	<CAOzFzEim7Q7eDr2z=BNsgnUuYH-XJaCPYpeVt5zkE1kvxZn+RQ@mail.gmail.com>
	<CAOzFzEhJ1PtpbKTbkh=8XTNDdFnjgWP6qBCwQHzXhO8C9s-eyw@mail.gmail.com>
	<20120816233600.GB26564@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120816233600.GB26564-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 17 August 2012 09:36, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Aug 16, 2012 at 10:07:29PM +1000, Joseph Glanville wrote:
>> There also seems to have been pretty severe performance regressions in
>> cache bypassed sequential I/O.
>> The newer code barely does 70mb/s sequential writes when
>> sequential_cuttoff is set to 4M however it does around 300mb/s when
>> set to 0 (no bypass) with dd and 1M block size.
>> When using the older codebase the cache bypass is actually slightly
>> faster than going to cache at around 360mb/s but this is still much
>> slower than the underlying block devices (as previously discussed).
>
> Ouch. Can you try profiling it with perf while running dd?
>
> perf record -afg dd etc. etc.
> perf report
>
> should do it

Sure can.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
