From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ANN] Ubuntu PPA for bcache-tools and blocks
Date: Fri, 13 Sep 2013 14:25:34 +0200
Message-ID: <5233043E.3000506@gmail.com>
References: <5232F139.4080508@gmail.com> <CACaajQtmLuA6M2Sj-=GJ6BGLicYi3Wn=qWmK84UA_PEa84MSYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQtmLuA6M2Sj-=GJ6BGLicYi3Wn=qWmK84UA_PEa84MSYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: ubuntu-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> Is that possible to create bcached kernel for raring? I like
> autoapdating and packages created via standard way. So I can install
> source package and headers and can vbuild to it dkms modules.

A backported dkms module isn't feasible, bcache comes with work
on the block layer.  Raring users should the kernels I've linked:

> Backported Ubuntu kernels are available at
> 
> http://kernel.ubuntu.com/~kernel-ppa/mainline/

Latest is this one
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11-saucy/
And there's a bit of docs here:
https://wiki.ubuntu.com/Kernel/MainlineBuilds

Other options for raring users: upgrade to saucy
http://askubuntu.com/questions/12909/
Or build your own kernel
https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
