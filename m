From: Liang Guo <bluestonechina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to check if one disk is SSD drive?
Date: Tue, 12 Jun 2012 23:20:39 +0800
Message-ID: <CAJwrgW4hBO4eVd6jLfpXag7ri_O+Ynn9FM0X1v9CU_mwv78Pxg@mail.gmail.com>
References: <CAEH94LgYWq3G_dhiGVmZ=b6eW9L8j=rqk4GeARiU7pdGtfoVUA@mail.gmail.com>
	<CAJwrgW4kzV_vJ7iMfB-n7VTfEp=EKr+TXHdwzOrtT0EMv58dFQ@mail.gmail.com>
	<CAEH94LgQmXAdRvb4jN+quNip0ZxON8VLQaQmyU5bCZfqB7uS3A@mail.gmail.com>
	<CAJwrgW647uZUDjpEfzRtF+GzNufygJHM_PWXLnZCGWF_3O4YHw@mail.gmail.com>
	<CAEH94Lg1i36VpM3pZXBbUY0dRkxpvERJ9GZUNTamTGDPvHQH0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEH94Lg1i36VpM3pZXBbUY0dRkxpvERJ9GZUNTamTGDPvHQH0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhi Yong Wu <zwu.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, Jun 12, 2012 at 7:04 PM, Zhi Yong Wu <zwu.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> I don't use bcache now. To use bcache, I need rebuild the entire kernel.
>>
>> I use flashcache instead, it can be compiled as a kernel model.
> Sorry, I am bcache newbie, please execute me to ask one more question.
>
> Just search flashcahce, it seems to have similar functions as bcache.
> right? If so, what is the difference between flashcache and bcache? If
> compared to flashcache, what are bcache's advantage and weakness
> separately?
>
As far as I know, both flashcache and bcache can use ssd as a cache device,
flashcache can be compiled a kernel module, but bcache can only be patched
in the kernel tree and be compiled with the entire kernel. If you are using a
vender provided kernel, compiling as kernel module needs less work then
compiling the entire kernel.

Bcache peoples are working hard to merge bcache into upstream kernel, once
it enters to the upstream kernel, it will become a standard feature. and will be
easy to use.

I have not do performance test. I don't know which one is better for
your situation.

BTW: If you want to use ssd as read cache, zfs[1][2] is a option too.

[1] http://zfs-fuse.net/
[2] http://zfsonlinux.org/


-- 
Liang Guo
http://bluestone.cublog.cn
