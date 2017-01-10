From: Kai Krakow <kai@kaishome.de>
Subject: Re: [4.9.1] Compiler warnings in bcache
Date: Tue, 10 Jan 2017 21:51:34 +0100
Message-ID: <20170110215134.4d2ea291@jupiter.sol.local>
References: <20170109193422.734b3088@jupiter.sol.kaishome.de>
        <8ca97b22-9888-fa22-5086-46f36eaaa931@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:36399 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751957AbdAJUvi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Jan 2017 15:51:38 -0500
Received: by mail-wj0-f196.google.com with SMTP id dh1so8403223wjb.3
        for <linux-bcache@vger.kernel.org>; Tue, 10 Jan 2017 12:51:37 -0800 (PST)
In-Reply-To: <8ca97b22-9888-fa22-5086-46f36eaaa931@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org, Eric Wheeler <bcache@lists.ewheeler.net>

Am Tue, 10 Jan 2017 13:41:25 +0800
schrieb Coly Li <i@coly.li>:

> On 2017/1/10 =E4=B8=8A=E5=8D=882:34, Kai Krakow wrote:
> > When compiling kernel 4.9.1, I'm seeing the following warnings:
> >=20
> > In file included from ./include/linux/bio.h:23:0,
> >                  from drivers/md/bcache/bcache.h:181,
> >                  from drivers/md/bcache/writeback.c:9:
> > drivers/md/bcache/writeback.c: In Funktion
> > =C2=BBbch_cached_dev_writeback_init=C2=AB: ./include/linux/ioprio.h:15:=
73:
> > Warnung: Klammern um Arithmetik in Operand von =C2=BB|=C2=AB empfohlen
> > [-Wparentheses] #define IOPRIO_PRIO_VALUE(class, data) (((class) <<
> > IOPRIO_CLASS_SHIFT) | data) ^ drivers/md/bcache/writeback.c:515:25:
> > Anmerkung: bei Substitution des Makros =C2=BBIOPRIO_PRIO_VALUE=C2=AB
> > dc->ioprio_bypass    =3D IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
> > IOPRIO_BE_NR-1); ^
> >=20
> > It suggests to put parentheses around the expression with the "|"
> > operand. No other kernel source files show warnings for me, so
> > maybe it should be fixed.
> >=20
> > I would create a patch myself but I'm not sure if it would be
> > correct and sufficient to put parenthesis around "data" like this:
> >=20
> > #define IOPRIO_PRIO_VALUE(class, data) (((class) <<
> > IOPRIO_CLASS_SHIFT) | (data))=20
>=20
> Hi Kai Krakow,
>=20
> This fix is necessary, please send a patch to IOPRIO_PRIO_VALUE().
>=20
> BTW, I don't see dc->ioprio_bypass from upstream kernel source, is it
> from a development tree ?

Ahhh... This is from Erics ioprio bypass patches. I'm still using the
4.8 patchset with 4.9. Maybe it has been updated meanwhile?

--=20
Regards,
Kai

Replies to list-only preferred.
