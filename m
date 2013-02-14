From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Powerdown failure (unmounting / busy problem)
Date: Thu, 14 Feb 2013 15:13:14 -0800
Message-ID: <CAH+dOxLGFYDPs1avtxywSYJ1TmmAMY3jpiD+L5MW4CLsFAQ28A@mail.gmail.com>
References: <kfjp7e$lo9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <kfjp7e$lo9$1@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Aaron W. Hsu" <arcfide-5nC73gNclPNzbRFIqnYvSA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

That doesn't sound like a bcache issue...

On Thu, Feb 14, 2013 at 2:41 PM, Aaron W.  Hsu <arcfide-5nC73gNclPNzbRFIqnYvSA@public.gmane.org> wr=
ote:
> I am getting a strange error when I recently upgraded my bcache to th=
e
> latest HEAD.
>
> Specifically, when shutting down, I am now getting an error when tryi=
ng to
> unmount / (bcache is on the root device) saying that it is busy. This=
 was
> not happening before. Is there something that would have caused this?=
 How
> might I fix it?
>
> --
> Aaron W. Hsu | arcfide-5nC73gNclPNzbRFIqnYvSA@public.gmane.org | http://www.sacrideo.us
> =D7=9C=D6=B5=D6=A4=D7=91 =D7=97=D6=B2=D7=9B=D6=B8=D7=9E=D6=B4=D7=99=D7=
=9D=D6=99 =D7=91=D6=BC=D6=B0=D7=91=D6=B5=D6=A3=D7=99=D7=AA =D7=90=D6=B5=
=D6=94=D7=91=D6=B6=D7=9C =D7=95=D6=B0=D7=9C=D6=B5=D6=A5=D7=91 =D7=9B=D6=
=BC=D6=B0=D7=A1=D6=B4=D7=99=D7=9C=D6=B4=D6=96=D7=99=D7=9D =D7=91=D6=BC=D6=
=B0=D7=91=D6=B5=D6=A5=D7=99=D7=AA =D7=A9=D7=82=D6=B4=D7=9E=D6=B0=D7=97=D6=
=B8=D6=BD=D7=94=D7=83
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
