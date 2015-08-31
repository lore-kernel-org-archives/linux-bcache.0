From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 31 Aug 2015 16:39:37 +0200
Message-ID: <20150831163937.00ca3f7a@harpe.intellique.com>
References: <20150830085442.GA31722@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:41773 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbbHaOjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Aug 2015 10:39:33 -0400
In-Reply-To: <20150830085442.GA31722@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: kmo@daterainc.com, linux-bcache@vger.kernel.org

Le Sun, 30 Aug 2015 10:54:42 +0200
Vojtech Pavlik <vojtech@suse.cz> =C3=A9crivait:

> Then I noticed that during those situations where the system was
> slow, and processes stuck in D, bcache_writeback CPU usage was
> soaring all the way to saturating a core,

In my experience, bcache_writeback stays in Wait state, therefore
always saturate a core: any machine I'm running bcache on has a
constant load of 1.00 even when completely idle.

> showing this backtrace,
> spending time in refill_keybuf_fn():
 <snip>
> Changing the configuration to writeback_percent=3D40 helped. For some
> time at least.
>=20
> When the issue returned, without any further changes to the system, I
> started investigating deeper. Since writeback_percent was large, also
> the amount of dirty data was large.

In my case, when dirty data reaches the upper limit (i.e. when the
amount of dirty data equals the writeback_percent * backing device
size ), and it occurs regularly, the system just freezes...

> Before poking deeper, I decided I
> want to clear the dirty data entierly. So I set the system to
> cache_mode=3Dwritethrough and watched the dirty data trickle to the
> backing device.
>=20
> But then it stopped at 2.8G and didn't progress any further. The
> bcache_writeback thread was at 100% CPU usage again and system was
> near unusable. Reverting to writeback made the system responsive
> again.

The bcache_writeback stays at 100% _even_ when in writethrough mode,
alas. So this looks normal. However dirty_data definitely should drop
to zero...

 <snip>=20
> I consider this a rather serious bug, even though it is most likely
> caused by the cache device being corrupted. Any hints?

Did you check what "smartctl -a" has to say about your backing device,
and maybe your spinning drives too? Just in case...

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
