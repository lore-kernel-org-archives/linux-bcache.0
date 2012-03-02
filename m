From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Fwd: bcache and dm targets (specifically lvm)
Date: Fri, 2 Mar 2012 16:49:19 +1100
Message-ID: <CAOzFzEjffLGjYhOznTo1F3moHLq+nvKYZFoy7mkU-q8RPDd9oQ@mail.gmail.com>
References: <CAOzFzEjKapphA5NKCWbEyx4nvjWw+e_dxr+fOLr8f5j586jiyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEjKapphA5NKCWbEyx4nvjWw+e_dxr+fOLr8f5j586jiyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I can't use bcache devices as members of lvm volume groups because
dmsetup can't find the devices.
It provides the ever useful feedback of:
# pvcreate /dev/bcache0
=A0 Device /dev/bcache0 not found (or ignored by filtering).

My LVM.conf is only filtering out nbd devices:
filter =3D [ "r|/dev/nbd.*|", "a/.*/" ]

Any insight would be greatly appreciated. :)

I also noted that bcache devices don't appear in iostat..

Joseph.

--
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846


--=20
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846
