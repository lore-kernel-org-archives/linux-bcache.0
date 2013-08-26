From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools: minor change for bcache-register
Date: Tue, 27 Aug 2013 00:16:32 +0200
Message-ID: <521BD3C0.9070209@gmail.com>
References: <521B1C5E.2090007@rolffokkens.nl> <20130826161758.GA4780@blackbox.djwong.org> <kvfvst$j12$2@ger.gmane.org> <20130826214848.GC2798@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130826214848.GC2798@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

>> I'll just send a patch to change "device already registered"
>> to a low-priority pr_debug message rather than something that
>> looks like an error.
>
> register_quiet isn't supposed to suppress legit errors - if it does
> that's a bug

It does suppress all the err =3D "=E2=80=A6" messages in register_bcach=
e from super.c;
I don't know how often they come up in practice.  From the read_super c=
all
on, errors get reported by the called functions.
