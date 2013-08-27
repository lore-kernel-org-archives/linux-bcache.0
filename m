From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools: changes to make the udev rules work
Date: Mon, 26 Aug 2013 17:17:11 -0700 (PDT)
Message-ID: <1377562631.31720.YahooMailNeo@web181503.mail.ne1.yahoo.com>
References: <1377516018.51534.YahooMailAndroidMobile@web181503.mail.ne1.yahoo.com> <95A9778F-C617-4455-BBEC-23F0DB06072C@rolffokkens.nl>
Reply-To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <95A9778F-C617-4455-BBEC-23F0DB06072C-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org


>The rationale is here:
>
>
>http://fedoraproject.org/wiki/Features/UsrMove


<quote>But, advanced features in today's systems can not really bootup =
with an empty /usr anymore. More and more fails in subtle ways in such =
setups.</quote>


What a crock of (#$@. "We broke the rules and now we're going to perpet=
uate the mistake because we can't be bothered to go fix our past screwu=
ps." Damn kids!! No one says it has to boot to network-aware multi user=
 (init=3D3 or higher) without /usr but it damn well better post to sing=
le-user and be able to mount all "local" (ie non-network dependent) blo=
ck devices without /usr. I swear, the work product out of RedHat gets w=
orse every year.

>Might be very Fedora specific, so I can make a non-Fedora diff. And ev=
en on Fedora /sbin is a symlink to /usr/sbin so I might not have to ass=
ume the tools are =A0in /usr



Definitely do NOT assume they put stuff in /usr/sbin. Always use /sbin =
and if RedHat forgot something, make them fix their symlink abomination=
 (what is this, Fedora aspires to be fscking Slowaris with /etc/init ->=
 /sbin/init and holy hell breaks if you don't have the /etc/init link?)=
=2E
