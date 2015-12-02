From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PULL REQUEST]: bcache stability patches
Date: Wed, 02 Dec 2015 13:18:35 +0100
Message-ID: <1449058715.3103.82.camel@suse.de>
References: <alpine.LRH.2.11.1511291750520.5445@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbbLBMSk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 2 Dec 2015 07:18:40 -0500
In-Reply-To: <alpine.LRH.2.11.1511291750520.5445@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, Joshua Schmid <jschmid@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, Takashi Iwai <tiwai@suse.de>, Zheng Liu <gnehzuil.liu@gmail.com>, manover@gmail.com, g2p.code@gmail.com, stefan.bader@canonical.com, linux-kernel@vger.kernel.org

On Sun, 2015-11-29 at 20:13 -0800, Eric Wheeler wrote:
> Hello all,
>=20
> Please pull this bcache branch with stability patches and see if it f=
ixes=20
> any issue that you might have!=C2=A0 If you have stability patches (*=
that you=20
> have tested*) which are not part of this branch, then please forward =
them=20
> so they can be included.
>=20
> We have been using bcache with great performance and stability for ov=
er a=20
> year; it is the best SSD caching mechanism that we have found for our=
=20
> workload.=C2=A0=20
>=20
> I've been collecting these fixes for a while now and just put them up=
 on=20
> github so they can be easily merged.=C2=A0 I continue to see mailing =
list=20
> discussions about problems that users are having which these patches=20
> address, so hopefully we can get these merged:
> =C2=A0
> =C2=A0 https://github.com/ewheelerinc/linux/commits/bcache-patches-fo=
r-3.17
> =C2=A0 git add remote ewheelerinc https://github.com/ewheelerinc/linu=
x.git
> =C2=A0 git fetch ewheelerinc
> =C2=A0 git merge ewheelerinc/bcache-patches-for-3.17
>=20
> This branch is from a clone of Linus's tree circa 3.17-rc so git merg=
e=20
> should bring this in cleanly to any later branch.=C2=A0 This will mer=
ge cleanly=20
> into kernel.org longerm versions v4.1.13 and v3.18.24.=C2=A0 The orig=
inal=20
> author is cited in each commit; you are being Cc'ed in this email if =
you=20
> are an author on any of these patches or are part of a mailing list t=
hread=20
> indicating problems that this pull may fix.

I just did a test merge on the patches against today's master and I had=
 no
merge conflicts. The overall diff looks reasonable as well and it build=
s w/o
any warnings.

Just pulling them straight in won't be a good idea though, as the From:=
 always
points to Eric, that needs to be fixed up (but that's all just mechanic=
s).

>=20
> Each commit includes `Cc: stable@vger.kernel.org` so if they get pull=
ed=20
> into mainline we will see bcache stable on the newer LTS branches of=20
> kernel.org.
>=20
> This git branch includes patches that have been collected and tested =
by=20
> Denis Bychkov from his post on 2015-09-16 with one exception: the=20
> refill_dirty() patch has been updated to the latest stable version wh=
ich=20
> Kent posted the next day.=C2=A0 The refill_dirty patch addresses issu=
es when=20
> bcache is backed by raid5/6 md's causing=20
> queue_limits->partial_stripes_expensive to be nonzero.
>=20
>=20
> Kent,
>=20
> Can this be sent to Jens for a pull into mainline?=C2=A0 If you can g=
ive your=20
> OK on this patchset then I'll approach Jens and see if he can pull th=
is=20
> in.=C2=A0 Maybe Cc him in your response.
>=20
> If there's anything in here that you would like to omit or change fro=
m=20
> this pull then let me know and I'll rebase.
>=20
> Thanks!
>=20
> -Eric
>=20

Kent, can you please merge these patches? There are people out there ac=
tually
using bcache and these patches aren't just cosmetics.

Thanks a lot for collecting these patches Eric.
	Johannes

>=20
>=20
> --
> Eric Wheeler, President=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 eWheeler, Inc. dba Global Linux Security
> 888-LINUX26 (888-546-8926)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
=46ax: 503-716-3878=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 PO Box 25107
> www.GlobalLinuxSecurity.pro=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0; Linu=
x since 1996!=C2=A0=C2=A0=C2=A0=C2=A0 Portland, OR 97298
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
