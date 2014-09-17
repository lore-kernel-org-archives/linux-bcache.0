From: Robie Basak <robie.basak@ubuntu.com>
Subject: Re: bcache-tools ITP
Date: Wed, 17 Sep 2014 14:08:05 +0100
Message-ID: <20140917130805.GX29881@mal.justgohome.co.uk>
References: <20140530155757.GU2893@mal.justgohome.co.uk>
 <175f4ae1c88f5506984eb3a1673829a5@de.mcbf.net>
 <20140715111552.GA17765@mal.justgohome.co.uk>
 <20140917115538.GW29881@mal.justgohome.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="i0LFOk513GRb+T2w"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaIQNIK (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 17 Sep 2014 09:08:10 -0400
Received: from mal.justgohome.co.uk ([217.169.28.211] helo=localhost)
	by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <robie.basak@ubuntu.com>)
	id 1XUExs-00016L-Bu
	for linux-bcache@vger.kernel.org; Wed, 17 Sep 2014 13:08:08 +0000
Content-Disposition: inline
In-Reply-To: <20140917115538.GW29881@mal.justgohome.co.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org


--i0LFOk513GRb+T2w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 17, 2014 at 12:55:38PM +0100, Robie Basak wrote:
> Can we define which the canonical upstream source tree is, please, and
> where the canonical Debian packaging branch should be? Then we can work
> on pushing the changes back to the right places, rather than having
> scattered branches all over the place. I noticed some changes to the
> upstream source that don't appear to be in branch 1, for example.

I've looked again and I see that 1.0.7 is tagged in the Github repos,
but not in evilpiepirate.org/git/bcache-tools.git.

Does this mean that the Github repos are now the canonical upstream?
Should the page at http://bcache.evilpiepirate.org/ be changed?

--i0LFOk513GRb+T2w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUGYe1AAoJEOVkucJ1vdUuw78P/1sF8P9kp7ssiz8q6HSzA8r+
x3w3FuS/6jAS0vVcgcauwwkrEs5OD0KQ6iqt4QUxsKmxCxAIw0BU0hX0b3N+K5gB
Lz9PJNNcRgH5eS8RJnLEv0Ozqtp3kdODk/38XtRDfTKUC7IvyOF13XdFgDS+9Kww
8TDcV60NnFfiR+i9VlE0VH0xkKmFa3e9FJbIgsDcpXrd4lOoqmExGc+Rhc0zNiR3
4LV6xb6IKUWnYQ4840yu9VohBEPr/gMV/4hl+Zx97s3+X11W57GK0p2WF6xRBrnu
FA/yl2yfpF+EJ7QkHAgPhvs8RmzdWvebtKZTa+kxnE80wPHYRt9TDHDyBkE7bmce
SJ+kMFsT8ZSOFt/jxCK2NRXiuHyTQsWp4CQcvQN3jqf0Io/V6OYfKmLQmdEYTMUP
/xxxo814RibfdfMMs5EmUKly51Ah37bKNo5aGGEYfS966bvHhsKeg3vueFR3Bp1H
pkbba4Bv50BZaCbPwCnQ6jWk7z1uH4mSWc7eqSJEf3qBf72LGSZhR/QSHmlVmZPH
/bn08UE+YgHMLq6wzSTPf9HYStLOI+xAZj3sEefDE0YxPupyyk3hmttqR2d/q2ow
Kp9VDMBSkwFldsc2x2ADt6rSbSnkNqdz8vxcc12yD1uEQ1TDqNq26/2oNq/Xatyl
cUP3WxVKZZPNJXSByhid
=HYRw
-----END PGP SIGNATURE-----

--i0LFOk513GRb+T2w--
