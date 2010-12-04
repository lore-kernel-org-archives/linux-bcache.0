From: John Drescher <drescherjm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache version 9
Date: Sat, 4 Dec 2010 00:41:20 -0500
Message-ID: <AANLkTikHhkK8WaFxOL+HkaCY97PCvFfON8cQV0xU_-0u@mail.gmail.com>
References: <20101121140808.GA6429@moria>
	<AANLkTim7_Lm3U+jHe7KG8Ha9rqe=jg2yffb8NA8RLiGM@mail.gmail.com>
	<4CECAFD1.10506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CECAFD1.10506-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: =?ISO-8859-1?Q?C=E9dric_Villemain?= <cedric.villemain.debian-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

>> Is it its main diff with flashcache ?
>> https://github.com/facebook/flashcache/blob/master/doc/flashcache-doc.txt
>
> Yeah. It's a more complex approach, but it's capable of significantly higher
> performance. Performance has regressed some lately (I've been concentrating
> on other things and don't really have the hardware for performance work),
> but a month or so ago it was benchmarking around 50% higher than flashcache,
> with mysql on an X25-E.

BTW, Thanks for releasing this..
I am just in the middle of evaluating using flashcache to speed up
slow IO in kvm clients when storing the VMs on hard disks. I will when
I get a chance try your patch..

John
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
