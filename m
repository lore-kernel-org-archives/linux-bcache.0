From: Thomas Klaube <thomas@klaube.net>
Subject: Re: bcache bug / fs freeze on heavy IO
Date: Tue, 2 Sep 2014 09:37:38 +0200 (CEST)
Message-ID: <1858501439.6823577.1409643458898.JavaMail.zimbra@klaube.net>
References: <318258231.4483994.1408694008758.JavaMail.zimbra@klaube.net> <58978953.4484590.1408694179180.JavaMail.zimbra@klaube.net> <CALJ65zn9yWeRLPZd8EMJSW_+ff1VeN159VBexwgCHRbfENHNCw@mail.gmail.com> <CALJ65z=ky_rC_A7-DP0mqWVBiC3RqUFYR02vju4FUfizOuXhXg@mail.gmail.com> <2025796026.5376048.1409035095370.JavaMail.zimbra@klaube.net> <CACHGV4J6YA0gin=srs4frRMOpmW23+b_gVzWN_pLH5NviO6Zpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from orion.efm.de ([195.190.148.230]:58531 "EHLO orion.efm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaIBHhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 2 Sep 2014 03:37:41 -0400
In-Reply-To: <CACHGV4J6YA0gin=srs4frRMOpmW23+b_gVzWN_pLH5NviO6Zpg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-bcache@vger.kernel.org

----- Urspr=C3=BCngliche Mail -----
> Von: "Slava Pestov" <sp@datera.io>
> An: "Thomas Klaube" <thomas@klaube.net>
> CC: "Kent Overstreet" <kmo@daterainc.com>, linux-bcache@vger.kernel.o=
rg
> Gesendet: Sonntag, 31. August 2014 22:34:52
> Betreff: Re: bcache bug / fs freeze on heavy IO
>=20
> Hi Thomas,

Hi Slava,

> > Aug 26 01:52:06 ubuntu kernel: [18378.656038] BUG: unable to handle=
 kernel
> > NULL pointer dereference at 0000000000000099
>=20
> I believe this is fixed in 3.17:
>=20
> http://evilpiepirate.org/git/linux-bcache.git/commit/?h=3Dbcache-dev&=
id=3D2452cc89063a2a6890368f185c4b6d7d8802179e
>=20
> Can you either try upgrading your kernel, or as a workaround try
> increasing your bucket size. This will lower the btree depth (depth 2
> trees won't hit this problem).

I upgraded to 3.17.0-rc3 and rerun the fio tests for 10 hours without a=
ny=20
problems (no suspect messages in dmesg, no fs errors and no hanging tas=
ks=20
or other problems). So it seems I am unable to trigger the problem in=20
3.17.0-rc3 but I will perform some more tests....

Thanx and regards
Thomas Klaube
