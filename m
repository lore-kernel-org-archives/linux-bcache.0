From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: New bcache compiler warning (was: Re: bcache: Minor fixes from
 kbuild robot)
Date: Mon, 17 Feb 2014 13:06:52 -0800
Message-ID: <530279EC.5010605@infradead.org>
References: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, Kent Overstreet <kmo@daterainc.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 02/17/2014 01:00 PM, Geert Uytterhoeven wrote:
> On Fri, Feb 14, 2014 at 8:04 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>>    bcache: Minor fixes from kbuild robot
>=20
>> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
>> index 4f6b594..3f74b4b 100644
>> --- a/drivers/md/bcache/bset.c
>> +++ b/drivers/md/bcache/bset.c
>> @@ -23,7 +23,7 @@ void bch_dump_bset(struct btree_keys *b, struct bs=
et *i, unsigned set)
>>         for (k =3D i->start; k < bset_bkey_last(i); k =3D next) {
>>                 next =3D bkey_next(k);
>>
>> -               printk(KERN_ERR "block %u key %zi/%u: ", set,
>> +               printk(KERN_ERR "block %u key %li/%u: ", set,
>>                        (uint64_t *) k - i->d, i->keys);
>>
>>                 if (b->ops->key_dump)
>=20
> On 32-bit (m68k):
> drivers/md/bcache/bset.c: In function =E2=80=98bch_dump_bset=E2=80=99=
:
> drivers/md/bcache/bset.c:27: warning: format =E2=80=98%li=E2=80=99 ex=
pects type =E2=80=98long
> int=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
>=20
> What are you trying to print here? It looks a bit strange to me.
> Technically, the difference between two pointers is of type ptrdiff_.
> The kernel had
>=20
> typedef __kernel_ptrdiff_t      ptrdiff_t;
>=20
> and
>=20
> #if __BITS_PER_LONG !=3D 64
> typedef unsigned int    __kernel_size_t;
> typedef int             __kernel_ssize_t;
> typedef int             __kernel_ptrdiff_t;
> #else
> typedef __kernel_ulong_t __kernel_size_t;
> typedef __kernel_long_t __kernel_ssize_t;
> typedef __kernel_long_t __kernel_ptrdiff_t;
> #endif
>=20
> So I'd expect "%zi" to be the right way, and a quick test compile on
> 32-bit (m68k)
> and 64-bit (amd64) comfirms that. What was wrong with it?

The kernel supports 't' (%t) for ptrdiff_t (same as glibc),
so %ti should work (or %tu).

--=20
~Randy
