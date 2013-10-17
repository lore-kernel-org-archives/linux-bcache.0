From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: bcache not works?
Date: Thu, 17 Oct 2013 07:24:11 +0400
Message-ID: <CACaajQvOkLmyrCyyr+8BA5sU+Z1mJ1o9Z4ss5+M=PNcng8sdxw@mail.gmail.com>
References: <CACaajQueWka6dA3g-Uv7Asz9KhgX9nJ_sjd8bNRo2Y2iU-73jA@mail.gmail.com>
 <525EFFFE.7060901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525EFFFE.7060901-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

2013/10/17 Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Maybe the cache isn't attached to the backing device?
>
> If you initialise both with the same make-bcache call they are
> immediately attached, otherwise you need to connect them:
>
> http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev#n80

As i see its all attached.
[  180.459041] bcache: register_bcache() error opening /dev/md127:
device already registered
[  180.459060] bcache: register_bcache() error opening /dev/sdb:
device already registered


-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
