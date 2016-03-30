From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: Compilation error: ERROR: "pagecache_add_put"
 [drivers/md/bcache/bcache.ko] undefined!
Date: Wed, 30 Mar 2016 09:56:30 +0200
Message-ID: <56FB86AE.4090300@mejor.pl>
References: <56FA8D3C.60307@mejor.pl> <20160329210139.GA8239@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:53338 "EHLO jowisz.mejor.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbcC3ICq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 30 Mar 2016 04:02:46 -0400
In-Reply-To: <20160329210139.GA8239@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 29.03.2016 o 23:01, Kent Overstreet pisze:
> On Tue, Mar 29, 2016 at 04:12:12PM +0200, Marcin Miros=C5=82aw wrote:
>> Hi again!
>> Since commit 53b6273b131a864947a2c55a18c07e86487e0a87 I'm getting er=
rors:
>> Kernel: arch/x86/boot/bzImage is ready  (#6)
>>   Building modules, stage 2.
>>   MODPOST 538 modules
>> ERROR: "pagecache_add_put" [drivers/md/bcache/bcache.ko] undefined!
>=20
> Thanks, fixed.
>=20
> Also pushed another small patch for the memory allocation failure in =
the lz4
> code - it ought to work reliably in practice now.

I didn't expect such fast fix for lz4:)
BTW, I'd like to ask how should I update my working tree via git. I run
git pull in tree to fetch your fix and (again) I got conflict:
git pull
remote: Counting objects: 251, done.
remote: Compressing objects: 100% (52/52), done.
remote: Total 251 (delta 219), reused 231 (delta 199)
Receiving objects: 100% (251/251), 36.73 KiB | 0 bytes/s, done.
Resolving deltas: 100% (219/219), completed with 63 local objects.
=46rom https://evilpiepirate.org/git/linux-bcache
 + 800353d...97951d0 bcache-dev -> origin/bcache-dev  (forced update)
 + ad59dfd...eda3e8b bcache-dev-wip -> origin/bcache-dev-wip  (forced
update)
Auto-merging mm/filemap.c
CONFLICT (content): Merge conflict in mm/filemap.c
Auto-merging drivers/md/bcache/fs-io.c
CONFLICT (content): Merge conflict in drivers/md/bcache/fs-io.c
Auto-merging drivers/md/bcache/extents.h
CONFLICT (content): Merge conflict in drivers/md/bcache/extents.h
Automatic merge failed; fix conflicts and then commit the result.


How I should update bcache git tree?
Marcin
