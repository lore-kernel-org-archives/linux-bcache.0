From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache on ubuntu
Date: Sat, 11 May 2013 00:50:56 +0200
Message-ID: <518D79D0.5030702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Giovanni Lenzi <public-giovanni.lenzi-Re5JQEeQqe8AvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Hi,
> I want to use bcache on ubuntu.
> 
> I saw that I have to download it from git with git clone command. Is it right?
> 
> I never recompiled a kernel. Is it so hard?
> 
> What kind of steps am I supposed to do, if I have a fresh ubuntu installation?

It's a bit early for this.

Before building a kernel, try your hand at building and installing bcache-tools.
Building the kernel is more time consuming, and you'll need bcache-tools
installed before the kernel so that it gets picked up for your boot.

Once that's done, have a look at https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

Experimental 3.10 kernels will also appear sometime next week[1].  Assuming they
have bcache enabled, you don't really have to built it yourself, you just need to
deal with experimental releases and the chance of trouble.

That's enough to let you play with bcache.  Converting your installation to
bcache is not something I'd recommend to someone who has never done this sort of
hacking, because if the kernel turns out to be unstable you'll be stuck with it
to access your data.

[1]: http://kernel.ubuntu.com/~kernel-ppa/mainline/?C=M;O=D
