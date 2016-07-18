From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] bcache: untagle cache_aolloc
Date: Mon, 18 Jul 2016 12:24:11 +0200
Message-ID: <20160718102411.t5qm3t6hnjcjpbyr@c203.arch.suse.de>
References: <1468836669-1136-1-git-send-email-jthumshirn@suse.de>
 <20160718101333.GA18961@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbcGRKYN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 18 Jul 2016 06:24:13 -0400
Content-Disposition: inline
In-Reply-To: <20160718101333.GA18961@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 18, 2016 at 02:13:33AM -0800, Kent Overstreet wrote:
> On Mon, Jul 18, 2016 at 12:11:09PM +0200, Johannes Thumshirn wrote:
> > bcache's cache_alloc() function currenty has no way freeing memory =
if one of
> > the allocations fails. Untangle the if + allocation statement so we=
 have
> > defined checkpoints to free previous allocations if one fails.
>=20
> nack. The existing error path handles failure midway through just fin=
e.

Come on, the patch improves the readability of the if statement by some=
 orders
of magnitude as well.

Are you OK with it if I change the subject/commit log?

	Johannes

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
