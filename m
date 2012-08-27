From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Mon, 27 Aug 2012 12:17:28 -0700
Message-ID: <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com>
References: <503BC71A.6050207@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503BC71A.6050207-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Aug 27, 2012 at 12:14 PM, Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org> wrote:
> Hi Everyone,
>
> I'm running bcache on my md raid device for use with my xen machine (via
> LVM). It works very well for Linux DomUs. However, I'm having some trouble
> installing Windows. When I enter the WIndows 2008 setup, it refuses to
> install to the LV volume. Reading the mailing lists, I feel this may have
> something to do with the block size that bcache is using.
>
> Assuming that my cache is md0, and my spindles are md1, it is my
> understanding that to change the block size I would have to do:
>
> make-bcache --block 512 --cache /dev/md0
> and
> make-bcache --block 512 --bdev /dev/md1
>
> However, this doesn't appear to work is both of the above devices are
> already set for bcache (The block size seems to still be '1' according to
> the output that make-bcache gives).

That's the output you want - it's displaying in units of 512 byte sectors
