From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Mon, 21 Nov 2011 02:26:26 -0800
Message-ID: <CAH+dOxKj_sisbFjKwTFaKQWANLgZumujrJe5LiLoCxg=ShzRkQ@mail.gmail.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
	<CAOzFzEjdhWtS9Q538+rM6LJm0ncx_MZg++3TCag3jr68F2=1uA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEjdhWtS9Q538+rM6LJm0ncx_MZg++3TCag3jr68F2=1uA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Nov 21, 2011 at 2:18 AM, Joseph Glanville
<joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org> wrote:
>
> Hi Kent,
>
> Great news!
>
> Just wondering if the bcache tree has been updated or will apply cleanly against 3.1?

It has, it's been rebased on top of v3.1.

> I will test on some more exotic stuff (iSCSI, md devices, other custom block devices etc) and get back to you if I find bugs.
> Are bugs best reported here on the list or is there another best way of doing so?

Cool! The list and this email are best.

> Willing to help out with some benchmarks on fast equipment that should be able to stress bcache abit.

Benchmarks are definitely welcome, the only benchmarking I've had time
to do has been for specifically working on performance.

Also, I mostly develop and test on 2.6.34 - I've done some stress
testing of the 3.1 version but no performance testing, so it is
possible there's performance bugs in the 3.1 version.

Thanks!
