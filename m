From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: shutdown and bcache
Date: Tue, 30 Jul 2013 11:18:18 +0200
Message-ID: <CAPBO7Ta-EayiYtTjJnFRrCF1Jg-x_bR=YGGwM+yGfAFmEcGjVQ@mail.gmail.com>
References: <CAPBO7TavO4ptpXk41jyHLsezS4fhQ1+y5Zk7yq4K183jvOeD-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPBO7TavO4ptpXk41jyHLsezS4fhQ1+y5Zk7yq4K183jvOeD-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

My scenario is root partition at /dev/sda3 and /boot at /dev/sda1

I am using a complete mSATA unit (/dev/sdb) as a cache and it works,
but system is not shutting down.

after

me_me 0000:00:16:0:stop

i get messages giving

failed command: WRITE FPDMA QUEUED

and so.

I have tried kernel 3.10.4 replacing ./drivers/md/bcache content to
get last version of bcache (even with last shutdown "fix":
http://evilpiepirate.org/git/linux-bcache.git/commit/?id=7051ed6b28b3770b59cab6fb7872e38e7d3cdb9d
) but it is not fixing this case: system is not stopping.

Screenshots here:

http://s9.postimg.org/sveejhewr/mei_me.jpg

http://s9.postimg.org/eq8lho5vf/write_fpdma_queued.jpg


Josep

--
--
Salutacions...Josep
--
