From: Cory Coager <ccoager-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: support for physical ramdisk
Date: Wed, 19 Jan 2011 20:14:06 -0500
Message-ID: <4D378C5E.7050309@gmail.com>
References: <4D377D66.5020609@gmail.com>	<AANLkTik30_V_bWGsvoUQw-5-W7URK1tSTDSfcTa8LayX@mail.gmail.com>	<4D37890B.3060808@gmail.com> <AANLkTinUD1_z3iZ3VgJFh=JkF+6EWDq62==Z9EhBpwBP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinUD1_z3iZ3VgJFh=JkF+6EWDq62==Z9EhBpwBP-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I would think even a low end DDR2 module would saturate the SATA 
interface bandwidth.

How would external journal to bcache help?

On 01/19/2011 08:03 PM, Kent Overstreet wrote:
> Ahh, that makes sense. I'd be curious what performance you get - it
> certainly wasn't designed with ram in mind. You'll want to play around
> with the bucket size and see what works best, too.
>
> Also, in the future I'm going to add support for an external journal
> to bcache - that could be the best of both worlds, for you.
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
