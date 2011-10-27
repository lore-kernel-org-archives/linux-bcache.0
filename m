From: Yehuda Sadeh Weinraub <yehudasa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Crash when trying to mount ext4
Date: Thu, 27 Oct 2011 09:25:24 -0700
Message-ID: <CAC-hyiFAv1-HeFiX3MtOJwxbNyAAQp_CMpzDv0A7-Woo3+qKdA@mail.gmail.com>
References: <CAFtEh-dPs+3foczt0Cjs=gWu42as=scALPAfJo+QPK+C3fRUbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFtEh-dPs+3foczt0Cjs=gWu42as=scALPAfJo+QPK+C3fRUbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, Oct 27, 2011 at 5:59 AM, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> I've been testing bcache with the latest sources from the git tree.
> I've been attempting to use a rbd (RADOS block device) as the backing
> device. I can format the bcache0 device with mkfs.ext4, however when I
> mount it, there is a kernel bug when it attempts to initialize the
> filesystem.
>
> I'm unsure if this is a bug in rbd or bcache however, I'm including
> the stack trace outputted by the kernel. The kernel has been based off
> the current Ubuntu Precise kernel (3.1.0) patched with the changes
> from the bcache git repository as well as the changes from the ceph
> repository in for-next (the same thing happened without the changes
> from the ceph repository). bcache does function as expected when using
> a raw disk drive.
>

Can you push a tree somewhere that has the exact kernel that you're
using, patched with the specific bcache version? It'll make it easier
for us to look at the issue.

Thanks,
Yehuda
