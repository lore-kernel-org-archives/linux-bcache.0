From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: kernel 3.10 + applied bcache patches unable to handle kernel
 NULL pointer dereference
Date: Fri, 12 Jul 2013 10:44:44 +0200
Message-ID: <51DFC1FC.6000002@profihost.ag>
References: <51D542EB.7070404@profihost.ag> <51D56066.80106@profihost.ag> <20130712014017.GE17799@kmo-pixel> <51DF9E21.3060601@profihost.ag> <20130712081901.GB8339@kmo-pixel> <51DFBEEF.3020106@profihost.ag> <51DFC087.4080402@profihost.ag> <51DFC16D.60607@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51DFC16D.60607-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

This one was the working commit for 3.10:

=46rom 023d8db36affa2489a83052dbb7c969d0941f06f Mon Sep 17 00:00:00 200=
1
=46rom: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date: Wed, 26 Jun 2013 17:25:38 -0700
Subject: [PATCH 17/17] bcache: FUA fixes

Journal writes need to be marked FUA, not just REQ_FLUSH. And btree nod=
e
writes have... weird ordering requirements.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/md/bcache/btree.c   |   19 +++++++++++++++++--
 drivers/md/bcache/journal.c |    2 +-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 09fb8a2..803af59 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -328,10 +328,25 @@ static void do_btree_node_write(struct btree *b)

        b->bio->bi_end_io       =3D btree_node_write_endio;
        b->bio->bi_private      =3D &b->io.cl;
-       b->bio->bi_rw   =3D REQ_META|WRITE_SYNC;
-       b->bio->bi_size =3D set_blocks(i, b->c) * block_bytes(b->c);
+       b->bio->bi_rw           =3D REQ_META|WRITE_SYNC|REQ_FUA;
+       b->bio->bi_size         =3D set_blocks(i, b->c) * block_bytes(b=
->c);
        bch_bio_map(b->bio, i);

+       /*
+        * If we're appending to a leaf node, we don't technically need
=46UA -
+        * this write just needs to be persisted before the next journa=
l
write,
+        * which will be marked FLUSH|FUA.
+        *
+        * Similarly if we're writing a new btree root - the pointer is
going to
+        * be in the next journal entry.
+        *
+        * But if we're writing a new btree node (that isn't a root) or
+        * appending to a non leaf btree node, we need either FUA or a =
flush
+        * when we write the parent with the new pointer. FUA is cheape=
r
than a
+        * flush, and writes appending to leaf nodes aren't blocking
anything so
+        * just make all btree node writes FUA to keep things sane.
+        */
+
        bkey_copy(&k.key, &b->key);
        SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) + bset_offset(b=
,
i));

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 5ca2214..4b25066 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -620,7 +620,7 @@ static void journal_write_unlocked(struct closure *=
cl)
                bio_reset(bio);
                bio->bi_sector  =3D PTR_OFFSET(k, i);
                bio->bi_bdev    =3D ca->bdev;
-               bio->bi_rw      =3D REQ_WRITE|REQ_SYNC|REQ_META|REQ_FLU=
SH;
+               bio->bi_rw      =3D
REQ_WRITE|REQ_SYNC|REQ_META|REQ_FLUSH|REQ_FUA;
                bio->bi_size    =3D sectors << 9;

                bio->bi_end_io  =3D journal_write_endio;
--=20
1.7.10.4

Stefan

Am 12.07.2013 10:42, schrieb Stefan Priebe - Profihost AG:
> it's this one:
> -               bch_writeback_add(dc, bio_sectors(bio));
> +               bch_writeback_add(dc);
>=20
> from cache: FUA fixes
>=20
> Journal writes need to be marked FUA, not just REQ_FLUSH. And btree n=
ode
> writes have... weird ordering requirements.
>=20
> in 3.10 bch_writeback_add still needs to arguments.
>=20
> Stefan
>=20
> Am 12.07.2013 10:38, schrieb Stefan Priebe - Profihost AG:
>> Does not seem to build:
>>   CC [M]  drivers/md/bcache/request.o
>> drivers/md/bcache/request.c: In function =91request_write=92:
>> drivers/md/bcache/request.c:1057: error: too few arguments to functi=
on
>> =91bch_writeback_add=92
>> make[3]: *** [drivers/md/bcache/request.o] Error 1
>> make[2]: *** [drivers/md/bcache] Error 2
>>
>> Am 12.07.2013 10:31, schrieb Stefan Priebe - Profihost AG:
>>> Am 12.07.2013 10:19, schrieb Kent Overstreet:
>>>> On Fri, Jul 12, 2013 at 08:11:45AM +0200, Stefan Priebe - Profihos=
t AG wrote:
>>>>> Am 12.07.2013 03:40, schrieb Kent Overstreet:
>>>>>> On Thu, Jul 04, 2013 at 01:45:42PM +0200, Stefan Priebe - Profih=
ost AG wrote:
>>>>>>> fix is this one: http://pastebin.com/raw.php?i=3DLBFJRvEt
>>>>>>
>>>>>> Oh I see, the patch that introduced this is an old version of th=
e patch
>>>>>> - the bcache-for-3.11 had this fixed, and I forgot to update tha=
t
>>>>>> branch. Thanks, I'll apply it there.
>>>>>
>>>>> thanks - which commit id is the fix in? i can't find it.
>>>>
>>>> The patch that introduced it wasn't ever destined for 3.10 anyways=
, and
>>>> I just deleted the bcache/bcache-3.9 branches because they'd gotte=
n out
>>>> of sync and weren't getting updated with bcache-dev/bcache-for-3.1=
1.
>>>
>>> Thanks!
>>>
>>>> So just stick with bcache-for-3.10, I just backported all the impo=
rtant
>>>> bugfixes to it - I'll be sending that stuff to Greg K-H for 3.10.1=
 in
>>>> the next couple days too.
>>> Thanks!
>>>
>>> Stefan
>>>
