From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: shutdown and bcache
Date: Tue, 30 Jul 2013 11:43:27 +0200
Message-ID: <CAPBO7TZpOJUO0cNLu6w+QF-aRBm_REWYkN=7MwdL5ja7AxTfRw@mail.gmail.com>
References: <CAPBO7TavO4ptpXk41jyHLsezS4fhQ1+y5Zk7yq4K183jvOeD-g@mail.gmail.com>
	<CAPBO7Ta-EayiYtTjJnFRrCF1Jg-x_bR=YGGwM+yGfAFmEcGjVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPBO7Ta-EayiYtTjJnFRrCF1Jg-x_bR=YGGwM+yGfAFmEcGjVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

Have just checked kernel 3.11.0-rc3 #1 SMP Tue Jul 30 11:06:14 CEST
2013 x86_64 GNU/Linux

and system has shut down!

Josep

On 30 July 2013 11:18, Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello,
>
> My scenario is root partition at /dev/sda3 and /boot at /dev/sda1
>
> I am using a complete mSATA unit (/dev/sdb) as a cache and it works,
> but system is not shutting down.
>
> after
>
> me_me 0000:00:16:0:stop
>
> i get messages giving
>
> failed command: WRITE FPDMA QUEUED
>
> and so.
>
> I have tried kernel 3.10.4 replacing ./drivers/md/bcache content to
> get last version of bcache (even with last shutdown "fix":
> http://evilpiepirate.org/git/linux-bcache.git/commit/?id=7051ed6b28b3770b59cab6fb7872e38e7d3cdb9d
> ) but it is not fixing this case: system is not stopping.
>
> Screenshots here:
>
> http://s9.postimg.org/sveejhewr/mei_me.jpg
>
> http://s9.postimg.org/eq8lho5vf/write_fpdma_queued.jpg
>
>
> Josep
>
> --
> --
> Salutacions...Josep
> --



-- 
--
Salutacions...Josep
--
