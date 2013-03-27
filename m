From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
Date: Wed, 27 Mar 2013 11:27:58 -0700
Message-ID: <51533A2E.2000501@infradead.org>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org> <20130327182150.GB25906@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130327182150.GB25906-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 03/27/13 11:21, Kent Overstreet wrote:
> On Wed, Mar 27, 2013 at 06:56:28PM +0100, Geert Uytterhoeven wrote:
>> m68k/allmodconfig:
>>
>> drivers/md/bcache/bset.c: In function =E2=80=98bset_search_tree=E2=80=
=99:
>> drivers/md/bcache/bset.c:727: error: implicit declaration of functio=
n =E2=80=98prefetch=E2=80=99
>>
>> drivers/md/bcache/btree.c: In function =E2=80=98bch_btree_node_get=E2=
=80=99:
>> drivers/md/bcache/btree.c:933: error: implicit declaration of functi=
on =E2=80=98prefetch=E2=80=99
>=20
> Thanks, applied! The other two I already have a patch queued up for.


On i386 and x86_64, I also see this build problem:

drivers/md/bcache/bset.c:885:4: error: implicit declaration of function=
 '__WARN' [-Werror=3Dimplicit-function-declaration]


Do you also have a patch for it?


thanks,
--=20
~Randy
