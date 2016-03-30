From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Compilation error: ERROR: "pagecache_add_put"
 [drivers/md/bcache/bcache.ko] undefined!
Date: Wed, 30 Mar 2016 00:20:23 -0800
Message-ID: <20160330082023.GA9561@kmo-pixel>
References: <56FA8D3C.60307@mejor.pl>
 <20160329210139.GA8239@kmo-pixel>
 <56FB86AE.4090300@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35842 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbcC3IU2 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 30 Mar 2016 04:20:28 -0400
Received: by mail-pa0-f46.google.com with SMTP id tt10so34607665pab.3
        for <linux-bcache@vger.kernel.org>; Wed, 30 Mar 2016 01:20:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <56FB86AE.4090300@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Wed, Mar 30, 2016 at 09:56:30AM +0200, Marcin Miros=C5=82aw wrote:
> W dniu 29.03.2016 o 23:01, Kent Overstreet pisze:
> > On Tue, Mar 29, 2016 at 04:12:12PM +0200, Marcin Miros=C5=82aw wrot=
e:
> >> Hi again!
> >> Since commit 53b6273b131a864947a2c55a18c07e86487e0a87 I'm getting =
errors:
> >> Kernel: arch/x86/boot/bzImage is ready  (#6)
> >>   Building modules, stage 2.
> >>   MODPOST 538 modules
> >> ERROR: "pagecache_add_put" [drivers/md/bcache/bcache.ko] undefined=
!
> >=20
> > Thanks, fixed.
> >=20
> > Also pushed another small patch for the memory allocation failure i=
n the lz4
> > code - it ought to work reliably in practice now.
>=20
> I didn't expect such fast fix for lz4:)
> BTW, I'd like to ask how should I update my working tree via git. I r=
un
> git pull in tree to fetch your fix and (again) I got conflict:
> git pull
> remote: Counting objects: 251, done.
> remote: Compressing objects: 100% (52/52), done.
> remote: Total 251 (delta 219), reused 231 (delta 199)
> Receiving objects: 100% (251/251), 36.73 KiB | 0 bytes/s, done.
> Resolving deltas: 100% (219/219), completed with 63 local objects.
> From https://evilpiepirate.org/git/linux-bcache
>  + 800353d...97951d0 bcache-dev -> origin/bcache-dev  (forced update)
>  + ad59dfd...eda3e8b bcache-dev-wip -> origin/bcache-dev-wip  (forced
> update)
> Auto-merging mm/filemap.c
> CONFLICT (content): Merge conflict in mm/filemap.c
> Auto-merging drivers/md/bcache/fs-io.c
> CONFLICT (content): Merge conflict in drivers/md/bcache/fs-io.c
> Auto-merging drivers/md/bcache/extents.h
> CONFLICT (content): Merge conflict in drivers/md/bcache/extents.h
> Automatic merge failed; fix conflicts and then commit the result.
>=20
>=20
> How I should update bcache git tree?

git reset --hard origin/bcache-dev
