From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] unable to handle kernel NULL pointer dereference at 000000000000006c (bch_insert_data)
Date: Tue, 15 Oct 2013 07:53:34 -0700 (PDT)
Message-ID: <1381848814.90106.YahooMailNeo@web181505.mail.ne1.yahoo.com>
References: <1381699461.2306.6.camel@ThinkPad-X230.localdomain> <525BE5B4.6000003@gmail.com> <CACaajQubbRDdewAxXekeTFu-vACRb3QnN2H1cA0XOvCzeFdbcw@mail.gmail.com> <20131014233551.GM28572@kmo>
Reply-To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131014233551.GM28572@kmo>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

>On Tue, Oct 15, 2013 at 12:41:02AM +0400, Vasiliy Tolstov wrote:
>> 2013/10/14 Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > That's the bug mentioned here:
>> > http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2113
>> > http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2109
>> > http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2108
>> >
>> > It's a regression that stops writeback and made 3.11.4.
>> > The fix is in 3.12-rc5 and will be in 3.11.5.
>>=20
>>=20
>> does branche http://evilpiepirate.org/git/linux-bcache.git/log/?h=3D=
bcache-for-3.11
>> has all fixes and stable for use?
>
>No - but 3.11.5 is out and has the fix


color me miffed/mystified. Why should we be chasing Linux kernel releas=
es to get fixed code? Shouldn't the GIT/tarball hosted at the bcache pr=
oject HQ be !!CONSTANTLY!! up to date with appropriate fixes? Linux ker=
nels depend on all kinds of people and is an "unreliable" means to get =
fully fixed code (eg. that last minute fix might not have made the cuto=
ff)

Shouldn't the project's code repository have the utmost priority?=A0
