From: Pim van den Berg <pim.vandenberg-IXGSG4U2CCrz+pZb47iToQ@public.gmane.org>
Subject: Re: mkfs crash
Date: Sat, 29 Dec 2012 21:28:47 +0100
Message-ID: <50DF527F.9080003@nethuis.nl>
References: <50DC3977.2080209@nethuis.nl> <20121228043144.GC10411@moria.home.lan> <50DED9A0.40002@nethuis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50DED9A0.40002-IXGSG4U2CCrz+pZb47iToQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 12/29/2012 12:53 PM, Pim van den Berg wrote:
> So it starts with PAX, detecting a refcount overflow, and makes
> mkfs.ext4 crash. The question now is, is it a grsecurity/pax bug, a
> bcache bug, or is it a combination of things?

I got an accidental reply from the PaX Team:

On 12/29/2012 07:33 PM, PaX Team wrote:
> hi,
>
> i just accidentally ran across your report on linux-bcache, and
> wanted to tell you that this is probably a false positive refcount
> overflow detection because the atomic variables in question seem to
> be only statistics that only ever get incremented so an eventual
> overflow is normal (or at least not a security problem, you may still
> want to let Kent know since an overflowing counter means 'false'
> stats for the end user). the 'fix' for this problem could be any of
> the following (with different benefits/drawbacks):
>
> 1. disable REFCOUNT in your .config
> 2. patch these bcache counters to be of the atomic_unchecked_t type
>    and also their accessors to use the _unchecked variants
> 3. make these counters atomic64_t that will probably not overflow
>    (but if they still can, there's atomic64_unchecked_t ;)
>
> cheers and happy new year,
>   PaX Team
