From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different types
Date: Thu, 6 Feb 2014 10:00:35 +0100
Message-ID: <CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	<1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	<1389783998.14001.22.camel@joe-AO722>
	<CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Feb 3, 2014 at 2:47 PM, Geert Uytterhoeven <geert@linux-m68k.or=
g> wrote:
> On Wed, Jan 15, 2014 at 12:06 PM, Joe Perches <joe@perches.com> wrote=
:
>> On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
>>> drivers/md/bcache/btree.c: In function =E2=80=98insert_u64s_remaini=
ng=E2=80=99:
>>> drivers/md/bcache/btree.c:1816: warning: comparison of distinct poi=
nter types lacks a cast
>> []
>>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> []
>>> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct bt=
ree *b)
>>>       if (b->keys.ops->is_extents)
>>>               ret -=3D KEY_MAX_U64S;
>>>
>>> -     return max(ret, 0L);
>>> +     return max_t(ssize_t, ret, 0L);
>>
>> why not
>>         return max(ret, 0);
>
> Indeed, that also works, on both 32-bit and 64-bit.
> Will resend, now all the issues moved from -next to Linus' tree.

However, sparse doesn't like it, so we'll have to go for v1?

=46rom kbuild test robot fengguang.wu@intel.com:

>> drivers/md/bcache/btree.c:1816:16: sparse: incompatible types in com=
parison expression (different type sizes)
   In file included from arch/x86/include/asm/percpu.h:44:0,
                    from arch/x86/include/asm/preempt.h:5,
                    from include/linux/preempt.h:18,
                    from include/linux/spinlock.h:50,
                    from include/linux/wait.h:8,
                    from include/linux/fs.h:6,
                    from include/linux/highmem.h:4,
                    from include/linux/bio.h:23,
                    from drivers/md/bcache/bcache.h:181,
                    from drivers/md/bcache/btree.c:23:
   drivers/md/bcache/btree.c: In function 'insert_u64s_remaining':
   include/linux/kernel.h:718:17: warning: comparison of distinct
pointer types lacks a cast [enabled by default]
     (void) (&_max1 =3D=3D &_max2);  \
                    ^
   drivers/md/bcache/btree.c:1816:9: note: in expansion of macro 'max'
     return max(ret, 0);
            ^

vim +1816 drivers/md/bcache/btree.c

  1800                                                status);
  1801                  return true;
  1802          } else
  1803                  return false;
  1804  }
  1805
  1806  static size_t insert_u64s_remaining(struct btree *b)
  1807  {
  1808          ssize_t ret =3D bch_btree_keys_u64s_remaining(&b->keys)=
;
  1809
  1810          /*
  1811           * Might land in the middle of an existing extent and
have to split it
  1812           */
  1813          if (b->keys.ops->is_extents)
  1814                  ret -=3D KEY_MAX_U64S;
  1815
> 1816          return max(ret, 0);
  1817  }
  1818
  1819  static bool bch_btree_insert_keys(struct btree *b, struct btree=
_op *op,
  1820                                    struct keylist *insert_keys,
  1821                                    struct bkey *replace_key)
  1822  {
  1823          bool ret =3D false;
  1824          int oldsize =3D bch_count_data(&b->keys);

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
