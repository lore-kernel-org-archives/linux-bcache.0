From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: bcache oops in bch_insert_data with the latest stables fixes
 (3.10.15)
Date: Wed, 09 Oct 2013 00:13:56 +0200
Message-ID: <525483A4.5020607@gmail.com>
References: <52513DBD.80005@excellency.fr> <525186E3.4000905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <525186E3.4000905@gmail.com>
Sender: stable-owner@vger.kernel.org
To: linux stable <stable@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc: cbay@excellency.fr, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

Le 06/10/2013 17:50, Gabriel de Perthuis a =E9crit :
> Le 06/10/2013 12:38, Cyril B. a =E9crit :
>> Hello,
>>
>> I get the following oops immediately after booting on 3.10.15.
>> Everything works fine in 3.10.10. Both the backing and cache devices=
 are
>> on top of mdadm.
>=20
> Reverting c0f04d88e46d14de51f4baebb6efafb7d59e9f96 fixes it; it was o=
ne
> of the few commits that's in 3.12 and -stable but not in
> bcache-for-3.11.  That commit causes bch_insert_data to be called wit=
h
> an unset op.cache_bio.

Pinging stable,
http://git.kernel.org/linus/c0f04d88e46d14de51f4baebb6efafb7d59e9f96
should be reverted.  It was in 3.11.4 and 3.10.15 (and 3.12-rc3).
It breaks bcache's writeback mode by calling bch_writeback_data without
setting cache_bio (it's more visible here[1]).  There's a bit of
indirection through closure calls, but it could never work.

|1]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dc0f04d88e46d14de51f4baebb6efafb7d59e9f96&context=3D8
