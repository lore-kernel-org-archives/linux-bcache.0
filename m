From: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Backing/caching ration
Date: Wed, 1 Aug 2012 10:09:18 -0700
Message-ID: <CAHYUNGZXeowGYfuwxG7hQN3+7W=F3W+svuj-KM-bFHb-bVrUfQ@mail.gmail.com>
References: <20120801170143.GA2549@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120801170143.GA2549-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

In our experiements we've seen around 1% flash to disk ratio gives
reasonable performance.  Of course it depends a lot on workload so you
may need a bit more than that.

Adam

On Wed, Aug 1, 2012 at 10:01 AM, Piergiorgio Sartor
<piergiorgio.sartor-i47jiTeKxPI@public.gmane.org> wrote:
> Hi all,
>
> I'm thinking about buying an SSD, I would like to
> know if someone can, more or less, suggest what
> could be a reasonable size, in relationship with
> the backing device.
>
> At the moment, I've 1TB RAID-10, of which /usr is
> 24GiB (10GiB used), /home is 64GiB, and then there
> are two "work area" volumes of 250GiB.
>
> Some other space is spread around /var and similar,
> and there is some backup space, for future use.
>
> Any idea on what could be "minimum" SSD size (due to
> cost, of course).
>
> Thanks,
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
