From: Giovanni Lenzi <giovanni.lenzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache on ubuntu
Date: Sat, 11 May 2013 08:36:33 +0200
Message-ID: <CAAxY4JmYSri=YJyfmRrUaN3R5KvDx6JKRxOUc6am5vqxUhSh1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Ok thanks,
I think I will wait for the 3.10 on the link you provided..

Then, running it on my machine is just like copying the file like
"linux-image-3.9.1-030901-generic_3.9.1-030901.201305080210_amd64.deb"
into my existing /boot/ folder and letting grub to boot it, isn't it?

But what about the initrd image? It is not provided on your link... I
can take the old one I was booting? What is this image?

As you suggested, now I will try to build bcache-tools. But shouldn't
I compile it only when I'm running the new kernel?


Thanks very much.


On 11 May 2013 00:50, Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi,
>> I want to use bcache on ubuntu.
>>
>> I saw that I have to download it from git with git clone command. Is it right?
>>
>> I never recompiled a kernel. Is it so hard?
>>
>> What kind of steps am I supposed to do, if I have a fresh ubuntu installation?
>
> It's a bit early for this.
>
> Before building a kernel, try your hand at building and installing bcache-tools.
> Building the kernel is more time consuming, and you'll need bcache-tools
> installed before the kernel so that it gets picked up for your boot.
>
> Once that's done, have a look at https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
>
> Experimental 3.10 kernels will also appear sometime next week[1].  Assuming they
> have bcache enabled, you don't really have to built it yourself, you just need to
> deal with experimental releases and the chance of trouble.
>
> That's enough to let you play with bcache.  Converting your installation to
> bcache is not something I'd recommend to someone who has never done this sort of
> hacking, because if the kernel turns out to be unstable you'll be stuck with it
> to access your data.
>
> [1]: http://kernel.ubuntu.com/~kernel-ppa/mainline/?C=M;O=D
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
