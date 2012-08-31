From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Expected Behavior
Date: Thu, 30 Aug 2012 18:10:58 -0700
Message-ID: <CAH+dOx+XNydDtAN9c1LN0OjY7xcvdP2AsbiPQb=HuuW-Swrt0Q@mail.gmail.com>
References: <503F132E.6060305@abpni.co.uk>
	<503F147A.10101@abpni.co.uk>
	<239802233aa1dabc37f60b293d2941c9@abpni.co.uk>
	<20120830212841.GB14247@google.com>
	<503FF05B.1040506@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503FF05B.1040506-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Aug 30, 2012 at 3:59 PM, Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org> wrote:
> I'm going to try and reproduce it myself as well. I just used IOMeter in a
> Windows DomU with 30 workers, each having an io depth of 256. A *very* heavy
> workload indeed, but my point was to see if I could break something. Unless
> the issue is specific to windows causing problems (NTFS or whatever), I'm
> guessing running fio with 30 jobs and an iodepth of 256 would probably
> produce a similar load.
>
> BTW, do you have access to a Xen node for testing?

No, I don't... and from what I remember, Xen was a _pain_ to set up...
