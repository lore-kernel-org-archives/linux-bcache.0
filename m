From: "Aaron W.  Hsu" <arcfide-5nC73gNclPNzbRFIqnYvSA@public.gmane.org>
Subject: Error building after merging upstream 3.7.7
Date: Wed, 13 Feb 2013 13:30:59 -0500
Message-ID: <kfgm5b$c8k$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I have managed to use bcache rather successfully for a while now, and I=
=20
wanted to try getting the latest changes to the bcache branch into my=20
kernel. At the same time, I wanted to merge in the latest linux stable=20
changes.

I did a merge of linux-stable/linux-3.7.y into the HEAD of the bcache=20
branch, which seems to have worked without issue, however, after I=20
configured the kernel, attempting to build the kernel errors out with t=
he=20
following message:

  LD      init/built-in.o
kernel/built-in.o:(.data+0x8bc8): undefined reference to `bcache_subsys=
'

Is there something I have totally missed here?

--=20
Aaron W. Hsu | arcfide-5nC73gNclPNzbRFIqnYvSA@public.gmane.org | http://www.sacrideo.us
=D7=9C=D6=B5=D6=A4=D7=91 =D7=97=D6=B2=D7=9B=D6=B8=D7=9E=D6=B4=D7=99=D7=9D=
=D6=99 =D7=91=D6=BC=D6=B0=D7=91=D6=B5=D6=A3=D7=99=D7=AA =D7=90=D6=B5=D6=
=94=D7=91=D6=B6=D7=9C =D7=95=D6=B0=D7=9C=D6=B5=D6=A5=D7=91 =D7=9B=D6=BC=
=D6=B0=D7=A1=D6=B4=D7=99=D7=9C=D6=B4=D6=96=D7=99=D7=9D =D7=91=D6=BC=D6=B0=
=D7=91=D6=B5=D6=A5=D7=99=D7=AA =D7=A9=D7=82=D6=B4=D7=9E=D6=B0=D7=97=D6=B8=
=D6=BD=D7=94=D7=83
