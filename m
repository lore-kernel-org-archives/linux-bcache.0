From: Liang Guo <bluestonechina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to check if one disk is SSD drive?
Date: Tue, 12 Jun 2012 14:09:41 +0800
Message-ID: <CAJwrgW4kzV_vJ7iMfB-n7VTfEp=EKr+TXHdwzOrtT0EMv58dFQ@mail.gmail.com>
References: <CAEH94LgYWq3G_dhiGVmZ=b6eW9L8j=rqk4GeARiU7pdGtfoVUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEH94LgYWq3G_dhiGVmZ=b6eW9L8j=rqk4GeARiU7pdGtfoVUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhi Yong Wu <zwu.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, Jun 12, 2012 at 1:16 PM, Zhi Yong Wu <zwu.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> HI,
>
> Can anyone let me know how to check if one disk is SSD drive? which
> linux command? any help is appreciated, thanks.
>
you may use hdparm, eg:

# hdparm -I /dev/sda |grep Media
        Nominal Media Rotation Rate: 7200
# hdparm -I /dev/sdb |grep Media
        Nominal Media Rotation Rate: Solid State Device


-- 
Liang Guo
http://bluestone.cublog.cn
