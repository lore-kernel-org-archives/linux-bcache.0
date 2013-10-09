From: Alfredo Sola <alfredo-18Wkm6LDWQfUHAh7w3TmpA@public.gmane.org>
Subject: Re: bcache oops in bch_insert_data with the latest stables fixes (3.10.15)
Date: Wed, 9 Oct 2013 09:41:59 +0200
Message-ID: <6C45A461-6CF3-4F48-BF42-9941CF7DC577@tecnocratica.net>
References: <52513DBD.80005@excellency.fr> <525186E3.4000905@gmail.com> <525483A4.5020607@gmail.com> <1381271982.70536.YahooMailNeo@web181505.mail.ne1.yahoo.com> <52548BBD.9060601@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52548BBD.9060601-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org


Hi,

I have been using Bcache on a rts box as an iSCSI target. So far, so good. I am however a bit worried about this:

> 3.11.4 minus the patch I mentioned is fine in my experience; I've been
> running it for a while along with other people (through the
> bcache-for-3.11 branch).  I'm not sure what corruption that patch was
> meant to prevent; I haven't encountered it as far as I know.

I am running 3.11.4 mainline with write back and am worried about the chance of corruption. Is it safe as far as that particular bug is concerned to use 3.11.4 in write through?

It looks to me that upgrading to 3.12 is very recommended, but for this box it means moving around a ton of virtual machines and takes some time, hence my question.

Thanks.

-- 
Enviado desde mi VT100
