From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: bcache strange behaviour in write back mode
Date: Mon, 22 Apr 2013 22:27:03 +0200
Message-ID: <51759D17.5040204@profitbricks.com>
References: <51758C42.4040708@profitbricks.com> <CAC7rs0u=epPv0c_swBSifi_fDRC0k9WpZ+34OmFdgxjR3-8WcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0u=epPv0c_swBSifi_fDRC0k9WpZ+34OmFdgxjR3-8WcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 2013=E5=B9=B404=E6=9C=8822=E6=97=A5 22:19, Kent Overstreet wrote:
> So you can easily reproduce this? If so, that's _awesome_ news - woul=
d
> you be willing to try out a debug kernel with some tracing stuff adde=
d?
> Maybe we can finally nail this.
>=20
>=20
Thanks for reply, Kent, two of my colleagues saw this behaviour, so I
think we can reproduce this.
If you could give me more detailed guide to narrow it down, I can try i=
t
on my side.

Regards,
Jack
> On Mon, Apr 22, 2013 at 12:15 PM, Jack Wang <jinpu.wang@profitbricks.=
com
> <mailto:jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>> wrote:
>=20
>     Hi all,
>=20
>     We've seen strange behaviour in bcache mode in current bcache-tes=
ting
>     branch with Possible allocator fix:
>=20
>     Once I start writing data with "dd if=3D/dev/zero of=3D/dev/bcach=
e0 bs=3D4k
>     count=3D10000 oflag=3Dsync", all SSDs in the Pool go close to 100=
% util and
>     I see about 3600 writes/second in iostat for each disk in the poo=
l, BUT
>     no data written in means of throughput.
>=20
>     Then after some seconds (the flush interval of bcache) I see the =
flush
>     of the writeback and also data written to the pool SSDs which loo=
ks
>     pretty much like reordering and merging happened for that data.
>=20
>     bcache-3.2 does not have such problem.
>     only bcache(master) and bcache-testing have such problem.
>=20
>     What's the possible reason?
>=20
>     Regards,
>     Jack
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-bcache" in
>     the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>     <mailto:majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>=20
>=20
