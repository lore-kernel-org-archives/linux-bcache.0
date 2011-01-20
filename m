From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: support for physical ramdisk
Date: Wed, 19 Jan 2011 17:27:31 -0800
Message-ID: <AANLkTin+xKeYbxSU6u=h8bfujSpm3fxqurC0nR4+89wX@mail.gmail.com>
References: <4D377D66.5020609@gmail.com>
	<AANLkTik30_V_bWGsvoUQw-5-W7URK1tSTDSfcTa8LayX@mail.gmail.com>
	<4D37890B.3060808@gmail.com>
	<AANLkTinUD1_z3iZ3VgJFh=JkF+6EWDq62==Z9EhBpwBP@mail.gmail.com>
	<4D378C5E.7050309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D378C5E.7050309-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cory Coager <ccoager-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 19, 2011 at 5:14 PM, Cory Coager <ccoager-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I would think even a low end DDR2 module would saturate the SATA interface
> bandwidth.
>
> How would external journal to bcache help?

Well, ram is more expensive per gigabyte than SSDs, particularly if
you've got something with a battery attached - the idea would be to
use your SSD for buffering 80 gb or so of writes, but then buffer all
of bcache's metadata writes in battery backed-up ram, significantly
decreasing the number of write IOPS to the SSD, and making it so
pretty much all the writes to the SSD are big contiguous writes.

>
> On 01/19/2011 08:03 PM, Kent Overstreet wrote:
>>
>> Ahh, that makes sense. I'd be curious what performance you get - it
>> certainly wasn't designed with ram in mind. You'll want to play around
>> with the bucket size and see what works best, too.
>>
>> Also, in the future I'm going to add support for an external journal
>> to bcache - that could be the best of both worlds, for you.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
