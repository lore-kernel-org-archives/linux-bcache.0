From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: bcache and load average
Date: Mon, 18 May 2015 13:35:40 +0200
Message-ID: <20150518133540.3676636b@harpe.intellique.com>
References: <20150515185032.6b129595@harpe.intellique.com>
	<alpine.DEB.2.02.1505151053020.8760@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:59029 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbbERLfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 18 May 2015 07:35:44 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id AA883CA9C36
	for <linux-bcache@vger.kernel.org>; Mon, 18 May 2015 13:35:41 +0200 (CEST)
In-Reply-To: <alpine.DEB.2.02.1505151053020.8760@ware.dreamhost.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Le Fri, 15 May 2015 10:55:32 -0700 (PDT)
Eric Wheeler <bcache@lists.ewheeler.net> =C3=A9crivait:

> Try the attached patches that I've been collecting over the past year
> or two. I do not believe they have been merged into mainline (BUT
> SOMEONE NEEDS TO).
>=20
> I am not sure that these address the load bug, but if the load is
> being increased by a large amount of dmesg output caused by rcu
> traces, then the patches will help.
>=20

No, there aren't any traces in dmesg. It's only some quirk of the
normal bcache behaviour... I suppose from some point of view it
even doesn't qualify as a bug, except in documentation.


--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
