From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache on ubuntu
Date: Sat, 11 May 2013 07:56:41 +0000 (UTC)
Message-ID: <kmktjp$1mp$1@ger.gmane.org>
References: <CAAxY4JmYSri=YJyfmRrUaN3R5KvDx6JKRxOUc6am5vqxUhSh1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Ok thanks,
> I think I will wait for the 3.10 on the link you provided..
> 
> Then, running it on my machine is just like copying the file like
> "linux-image-3.9.1-030901-generic_3.9.1-030901.201305080210_amd64.deb"
> into my existing /boot/ folder and letting grub to boot it, isn't it?
> 
> But what about the initrd image? It is not provided on your link... I
> can take the old one I was booting? What is this image?
> 
> As you suggested, now I will try to build bcache-tools. But shouldn't
> I compile it only when I'm running the new kernel?

I did say:

you'll need bcache-tools installed *before* the kernel so that it gets
picked up for your boot.  So no.  This has to do with initramfs generation.

The wiki page I linked has the command for installing deb files.

If you hit any more snags, it will be a good idea to wait for things to
be properly integrated by Ubuntu.
