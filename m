From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache strange behaviour in write back mode
Date: Mon, 22 Apr 2013 13:26:53 -0700
Message-ID: <CAC7rs0tSuxKQ_VoykeVNo=HetGG9qOY8wPHsFw=N1kOLcK4o-A@mail.gmail.com>
References: <51758C42.4040708@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51758C42.4040708-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

So you can easily reproduce this? If so, that's _awesome_ news - would
you be willing to try out a debug kernel with some tracing stuff
added? Maybe we can finally nail this.

On Mon, Apr 22, 2013 at 12:15 PM, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> Hi all,
>
> We've seen strange behaviour in bcache mode in current bcache-testing
> branch with Possible allocator fix:
>
> Once I start writing data with "dd if=/dev/zero of=/dev/bcache0 bs=4k
> count=10000 oflag=sync", all SSDs in the Pool go close to 100% util and
> I see about 3600 writes/second in iostat for each disk in the pool, BUT
> no data written in means of throughput.
>
> Then after some seconds (the flush interval of bcache) I see the flush
> of the writeback and also data written to the pool SSDs which looks
> pretty much like reordering and merging happened for that data.
>
> bcache-3.2 does not have such problem.
> only bcache(master) and bcache-testing have such problem.
>
> What's the possible reason?
>
> Regards,
> Jack
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
