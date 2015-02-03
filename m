From: Joshua Schmid <jschmid@suse.de>
Subject: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Tue, 03 Feb 2015 11:37:03 +0100
Message-ID: <54D0A4CF.4040204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbbBCKhF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 3 Feb 2015 05:37:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A9489AB0C
	for <linux-bcache@vger.kernel.org>; Tue,  3 Feb 2015 10:37:03 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,



I tested this patch for some time and it really helps to fix the gc
issue we are running in. Since it might got lost, i will resend it.



Best Regards,
	     Joshua

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJU0KTPAAoJEPUnwXO0u5uWMHYP/j18RLchiWUv2qD1RwNbRYdY
5nood3FekVhZTsTZTqw+0Js89XHLtCHgT9qKSsYKKng512jb8o0VHPWXPwviRiOg
/wo3Pc3f7rq4AKd6Ek1hNeEoBovdkWDRpLlQeJWd4D73OJYl4gWHd/6l+vqVOKH4
RbealXcGaruPYgXCosGiFVXadfpYFFmfSO7sHFNJMJISC5ZezWpAfu51WCAIWiy4
bjwSuccIFtX2UISjm0TfyUX1q3jea+CRL4is8C3xkm/6zXQU8DGmWigK7Wui+czf
OO35/+6qP/iwiZVjMGDac8nEPU4T8szrHigL6avvXwjbZLO05atAlfexm7Hg3UOl
/ITDfhcEL1NSQUAgGfcR1cKn/t0ThFSDUaa+67AxURPMxpaz3MquE+FoDiUpn4fC
kd0S5nGVIQj2Jd+n+E7+3/C8IDUSqq9nc2r9WzrOJk0G61ehnwxex1oH6rLvfaTG
CO+NsEVBk+U3QpXHRXqwm17Pbxs50lXEB/PFixf+e0VN+pwg4w8bGsqWO2646o/y
nxfj8+IyWRC3XW97l5qvMno+YMHH2qTnUgp5Z0QWWVWfbigFnIV8j1eHwc6+e67h
AHHvb9YxA5unHl9b6Rf/nfZuac1G59+vaDUX5YABwim6jmJ/DVJUXwWunlphwTzc
D4F1nLaaMob3cM1vCZPA
=pIKZ
-----END PGP SIGNATURE-----
