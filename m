From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel Compilation - As a module
Date: Wed, 1 Feb 2012 17:46:40 -0800
Message-ID: <CAH+dOxK-hBMiWKZwCwesq_3dgNceSZLkP+A_vABw5tKL35rD2A@mail.gmail.com>
References: <4F29582B.4060900@netmindz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F29582B.4060900-eSrJ3h7o4/Lk1uMJSBkQmQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Tatam <will-eSrJ3h7o4/Lk1uMJSBkQmQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Bcache needs a few changes to the generic block code. It does build as
a module, you just wouldn't be able to use the module with a stock
kernel.

On Wed, Feb 1, 2012 at 7:20 AM, Will Tatam <will-eSrJ3h7o4/Lk1uMJSBkQmQ@public.gmane.org> wrote:
> Is it possible to build bcache as a module for your current kernel ? =
The
> code I checked out appeared to be an entire linux kernel tree from wh=
at
> I could see at quick glance
>
> When I've been building other stuff before, drbd, v2l-dvb etc I can j=
ust
> build the extra modules provided I have the kernel headers (and
> sometimes full source) for my running kernel
>
> This is of course much faster, less disruptive and also allows you to=
 do
> things like build kmods
>
> What would need to happen to make this possible, or am I just failing
> into the common trap of not reviewing all the documentation proper to
> asking a possibly simple question ?
>
> --
> Will Tatam
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
