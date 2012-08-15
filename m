From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache compared to more RAM
Date: Wed, 15 Aug 2012 09:23:40 -0700
Message-ID: <502BCD0C.6080108@intel.com>
References: <201208150630.36861.csights@fastmail.fm> <CAA-P7fUiZFKnfyAEEQtB+23W74VGK-TU4o0WX2RF_gbn5Gaq=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA-P7fUiZFKnfyAEEQtB+23W74VGK-TU4o0WX2RF_gbn5Gaq=Q@mail.gmail.com>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John McCabe-Dansted <gmatht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: C Sights <csights-97jfqw80gc6171pxa8y+qA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 08/15/2012 04:51 AM, John McCabe-Dansted wrote:
> On Wed, Aug 15, 2012 at 7:30 PM, C Sights <csights-97jfqw80gc6171pxa8y+qA@public.gmane.org> wrote:
>> Hi all,
>>    Has anyone tried creating a bcache device in RAM and benchmarking
>> performance of that versus just allowing that RAM to be used as file system
>> buffers?
> I doubt it; bcache is designed to use non-volatile flash memory rather
> than ram.
>
> If the filesystem is readonly, I imagine that using RAM for bcache
> would lead to worse performance as it would just add overhead. If the
> filesystem is read-write then it might lead to better performance but
> would also lead to the file-system being trashed on if unexpected
> power loss occurs.
>
> Under what circumstance would you intend to actually use ram backed bcache?
>

So the Intel Xeon E5-2600 series platforms has this feature called
asynchronous DRAM refresh (ADR). Essentially it's battery backed DRAM on
per DIMM socket basis. I have written a RAM disk driver on top of that
experimentally and played a little bit with it used by bcache instead of
SSD. Writing to the memory region isn't going to be as fast as normal
cached RAM because you have to ensure the data is flushed to the DRAM.
However, read should be the same as cached DRAM. But the writing should
still be faster than SSD. Anyhow, I'm more curious as to how I can
benchmark this to demonstrate if this is a benefit with bcache. i.e.
what benchmarking tool(s) I should use and with what parameters etc.
