From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: New bcache compiler warning (was: Re: bcache: Minor fixes from
 kbuild robot)
Date: Mon, 17 Feb 2014 22:11:51 +0100
Message-ID: <CAMuHMdUnCdEoyD+seYXJD+e4bED9=ceUCC7NYsoRa1_vc3g4Hw@mail.gmail.com>
References: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
	<530279EC.5010605@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54803 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaBQVLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 17 Feb 2014 16:11:52 -0500
In-Reply-To: <530279EC.5010605@infradead.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org

On Mon, Feb 17, 2014 at 10:06 PM, Randy Dunlap <rdunlap@infradead.org> =
wrote:
> On 02/17/2014 01:00 PM, Geert Uytterhoeven wrote:
>> On Fri, Feb 14, 2014 at 8:04 PM, Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org> wrote:
>>>    bcache: Minor fixes from kbuild robot
>>
>>> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
>>> index 4f6b594..3f74b4b 100644
>>> --- a/drivers/md/bcache/bset.c
>>> +++ b/drivers/md/bcache/bset.c
>>> @@ -23,7 +23,7 @@ void bch_dump_bset(struct btree_keys *b, struct b=
set *i, unsigned set)
>>>         for (k =3D i->start; k < bset_bkey_last(i); k =3D next) {
>>>                 next =3D bkey_next(k);
>>>
>>> -               printk(KERN_ERR "block %u key %zi/%u: ", set,
>>> +               printk(KERN_ERR "block %u key %li/%u: ", set,
>>>                        (uint64_t *) k - i->d, i->keys);
>>>
>>>                 if (b->ops->key_dump)
>>
>> On 32-bit (m68k):
>> drivers/md/bcache/bset.c: In function =E2=80=98bch_dump_bset=E2=80=99=
:
>> drivers/md/bcache/bset.c:27: warning: format =E2=80=98%li=E2=80=99 e=
xpects type =E2=80=98long
>> int=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
>>
>> What are you trying to print here? It looks a bit strange to me.
>> Technically, the difference between two pointers is of type ptrdiff_=
=2E
>> The kernel had
>>
>> typedef __kernel_ptrdiff_t      ptrdiff_t;
>>
>> and
>>
>> #if __BITS_PER_LONG !=3D 64
>> typedef unsigned int    __kernel_size_t;
>> typedef int             __kernel_ssize_t;
>> typedef int             __kernel_ptrdiff_t;
>> #else
>> typedef __kernel_ulong_t __kernel_size_t;
>> typedef __kernel_long_t __kernel_ssize_t;
>> typedef __kernel_long_t __kernel_ptrdiff_t;
>> #endif
>>
>> So I'd expect "%zi" to be the right way, and a quick test compile on
>> 32-bit (m68k)
>> and 64-bit (amd64) comfirms that. What was wrong with it?
>
> The kernel supports 't' (%t) for ptrdiff_t (same as glibc),
> so %ti should work (or %tu).

Yes, that compiles without warnings, too.

And after more decyphering, "(uint64_t *) k - i->d" seems to be positiv=
e,
so "%tu" should be OK.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
