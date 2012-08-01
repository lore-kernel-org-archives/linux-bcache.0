From: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel schedule
Date: Wed, 1 Aug 2012 10:09:34 -0700
Message-ID: <CAHYUNGYKE4oNEnmTMjWfcRBsWk15AtpTunQc_0kAxe=1=FFr-Q@mail.gmail.com>
References: <20120801165718.GA2534@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120801165718.GA2534-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

There are a few patches (regarding closures) that have sparked a lot
of debate and it's not clear if those will be accepted.  If those are
not accepted then some of bcache's thread synchronization will need to
be re-written.  My guess is it will likely take from 1-6 months, but
there's lots of factors here.

Adam

On Wed, Aug 1, 2012 at 9:57 AM, Piergiorgio Sartor
<piergiorgio.sartor-i47jiTeKxPI@public.gmane.org> wrote:
> Hi all,
>
> just out of curiosity, when is expected the
> inclusion of bcache in mainline kernel?
>
> I know many patches were underway back and
> forth, so I was wondering if an agreement
> was achieved or there is still discussion.
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
