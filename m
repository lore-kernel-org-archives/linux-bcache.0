From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: full ssd for bcache or part?
Date: Wed, 23 Oct 2013 20:40:02 -0700 (PDT)
Message-ID: <1382586002.46067.YahooMailNeo@web181505.mail.ne1.yahoo.com>
References: <CACaajQscOOajT2A6MNpstALph8D=jqdvqifynYxxR4gTXrGTGQ@mail.gmail.com> <f46b2a85-6116-4dac-8acd-03007110cf4b@email.android.com> <526884F8.4080000@fnarfbargle.com>
Reply-To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526884F8.4080000-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>, Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org


>I thought (and maybe I'm wrong) that a good chunk of reserved space wa=
s essential to allow the drive to efficiently manage its read-modify-wr=
ite cycles.

Correct. The industry ~standard of 7% (basically the difference between=
 GiB and GB) is woefully inadequate for any kind of steady write load. =
ALL enterprise SSDs use north of 20% and and I've seen as high as 50%.

> It was my understanding that bcache was explicitly designed to fill e=
rase block sized
> chunks sequentially and discard them in whole units,
> negating the requirement for the drive to actually perform RMW cycles


RMW is an essential and inalienable of how an SSD works.=A0Every manufa=
cturer can use different page and erase block sizes. And much of the ti=
me they don't publish the specs publicly. So while Kent may have gone t=
o deliberate length to optimize the way BCache does IO by using aligned=
, suitably large chunks (eg. 128KB-512KB) he has zero control over what=
 the firmware decides to do.

BTW, did you undo the retarded disk label that Linux has used for decad=
es which is guaranteed to cause mis-aligned I/O? I expect BCache will s=
tart it's data area at 1MB offset from where the device starts. But it =
can't do much to remedy the =A0problem if you didn't align the partitio=
n or LV you handed BCache correctly to begin with.
