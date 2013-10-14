From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: [BUG] unable to handle kernel NULL pointer dereference at
 000000000000006c (bch_insert_data)
Date: Tue, 15 Oct 2013 00:41:02 +0400
Message-ID: <CACaajQubbRDdewAxXekeTFu-vACRb3QnN2H1cA0XOvCzeFdbcw@mail.gmail.com>
References: <1381699461.2306.6.camel@ThinkPad-X230.localdomain> <525BE5B4.6000003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525BE5B4.6000003-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Igor Gnatenko <i.gnatenko.brain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

2013/10/14 Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> That's the bug mentioned here:
> http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2113
> http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2109
> http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2108
>
> It's a regression that stops writeback and made 3.11.4.
> The fix is in 3.12-rc5 and will be in 3.11.5.


does branche http://evilpiepirate.org/git/linux-bcache.git/log/?h=bcache-for-3.11
has all fixes and stable for use?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
