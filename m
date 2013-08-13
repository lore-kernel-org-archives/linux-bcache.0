From: =?UTF-8?B?RnLDqWTDqXJpYyBWQU5OScOIUkU=?=
	<f.vanniere-RVWVJRqVLmoxnA8XTFIEbw@public.gmane.org>
Subject: Re: Silent data corruption (3.11-rc4) in writethrough mode
Date: Tue, 13 Aug 2013 10:22:08 +0200
Message-ID: <5209ECB0.80806@planet-work.com>
References: <52089B57.8000104@planet-work.com> <20130812175725.GA7662@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130812175725.GA7662-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Le 12/08/2013 19:57, Kent Overstreet a =C3=A9crit :
> Ouch... This wasn't occuring on 3.10?=20

I don't know, I didn't use 3.10 long enough in production to see this a=
ppen. I'll revert to vanilla 3.10.6 and see if the issue is still prese=
nt after my vacation.
