From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: kernel 3.10 + applied bcache patches unable to handle kernel
 NULL pointer dereference
Date: Fri, 12 Jul 2013 10:38:31 +0200
Message-ID: <51DFC087.4080402@profihost.ag>
References: <51D542EB.7070404@profihost.ag> <51D56066.80106@profihost.ag> <20130712014017.GE17799@kmo-pixel> <51DF9E21.3060601@profihost.ag> <20130712081901.GB8339@kmo-pixel> <51DFBEEF.3020106@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51DFBEEF.3020106-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Does not seem to build:
  CC [M]  drivers/md/bcache/request.o
drivers/md/bcache/request.c: In function =91request_write=92:
drivers/md/bcache/request.c:1057: error: too few arguments to function
=91bch_writeback_add=92
make[3]: *** [drivers/md/bcache/request.o] Error 1
make[2]: *** [drivers/md/bcache] Error 2

Am 12.07.2013 10:31, schrieb Stefan Priebe - Profihost AG:
> Am 12.07.2013 10:19, schrieb Kent Overstreet:
>> On Fri, Jul 12, 2013 at 08:11:45AM +0200, Stefan Priebe - Profihost =
AG wrote:
>>> Am 12.07.2013 03:40, schrieb Kent Overstreet:
>>>> On Thu, Jul 04, 2013 at 01:45:42PM +0200, Stefan Priebe - Profihos=
t AG wrote:
>>>>> fix is this one: http://pastebin.com/raw.php?i=3DLBFJRvEt
>>>>
>>>> Oh I see, the patch that introduced this is an old version of the =
patch
>>>> - the bcache-for-3.11 had this fixed, and I forgot to update that
>>>> branch. Thanks, I'll apply it there.
>>>
>>> thanks - which commit id is the fix in? i can't find it.
>>
>> The patch that introduced it wasn't ever destined for 3.10 anyways, =
and
>> I just deleted the bcache/bcache-3.9 branches because they'd gotten =
out
>> of sync and weren't getting updated with bcache-dev/bcache-for-3.11.
>=20
> Thanks!
>=20
>> So just stick with bcache-for-3.10, I just backported all the import=
ant
>> bugfixes to it - I'll be sending that stuff to Greg K-H for 3.10.1 i=
n
>> the next couple days too.
> Thanks!
>=20
> Stefan
>=20
