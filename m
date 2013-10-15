From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: good bcache use case?
Date: Tue, 15 Oct 2013 23:12:03 +0200
Message-ID: <525DAFA3.4060709@gmail.com>
References: <1005c01cec92f$b61b2040$225160c0$@acm.org> <1381849203.67736.YahooMailNeo@web181503.mail.ne1.yahoo.com> <038e01cec9da$8a19e750$9e4db5f0$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <038e01cec9da$8a19e750$9e4db5f0$@acm.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Le 15/10/2013 21:12, Paul B. Henson a =E9crit :
>> From: matthew patton [mailto:pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org] Sent: Tuesday,=20
>> October 15, 2013 8:00 AM
>>=20
>> Anything shy of the official linux 3.11.5 kernel release has=20
>> several time-bomb bugs.
>=20
> Hmm, given 3.10 is an LTS kernel presumably these bug fixes would be=20
> back ported? I suppose it would just be a matter of making sure for
> a given 3.10.x that they had been.

3.10.x and 3.11.y stable kernels have been getting bcache backports
whenever necessary.  3.11.4 had a regrettable crasher in writeback mode=
,
but no time-bomb.  The confusion may come from the fact that the patch
that introduced the crash was fixing a more serious bug.  Stopping here
because the mailing list is starting to feel like Groundhog day.

>> personally would be a bit circumspect in calling it fully=20
>> production ready. I don't believe there are any known significant
>> bugs but with the recent flurry of fixes I'd liken it's solidity as
>> more pudding rather than cake.
>=20
> Well, that's not exactly a ringing endorsement :). I suppose I could=20
> always stick with plan A and migrate to bcache later, it should be=20
> easy enough to pvmove everything off of the SSD raid1, pvremove it,=20
> and then with a little downtime convert the raid10 to a backing
> store and the SSD raid1 to a cache.
>=20
> Thanks for the opinions.

Right now I have in-place conversion for LVs, but not for PVs (details
on the bcache wiki).  The block layout would work for PV conversions,
but since LVM can do raid and a single cache can cache multiple devices=
,
I've assumed putting bcache on top is preferable.  Maybe for people who
do a lot of snapshotting the other option is better.  (Do as you prefer=
,
just thinking out loud)
