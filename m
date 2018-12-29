From: NeilBrown <neil@brown.name>
Subject: Re: [PATCH v5 1/2] lib: add crc64 calculation routines
Date: Sat, 29 Dec 2018 13:58:09 +1100
Message-ID: <87y3899gzi.fsf@notabene.neil.brown.name>
References: <20180726053352.2781-1-colyli@suse.de> <20180726053352.2781-2-colyli@suse.de> <20180726130210.97450a74c164a02d7cfd79c1@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180726130210.97450a74c164a02d7cfd79c1@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Coly Li <colyli@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-bcache@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 26 2018, Andrew Morton wrote:

> On Thu, 26 Jul 2018 13:33:51 +0800 Coly Li <colyli@suse.de> wrote:
>
>> This patch adds the re-write crc64 calculation routines for Linux kernel.
>> The CRC64 polynomial arithmetic follows ECMA-182 specification, inspired
>> by CRC paper of Dr. Ross N. Williams
>> (see http://www.ross.net/crc/download/crc_v3.txt) and other public domain
>> implementations.

Hi Coly and Andrew,

This patch breaks compilation if linux headers files are not installed
(reported at https://github.com/gnubee-git/GnuBee_Docs/issues/75).
Following fixes it.

Thanks,
NeilBrown

From: NeilBrown <neil@brown.name>
Subject: [PATCH] lib: don't depend on linux headers being installed.

gen_crc64table requires linux include files to be installed
in /usr/include/linux.  This is a new requrement so hosts that
could previously build the kernel, now cannot.

gen_crc64table makes this requirement by including <linux/swab.h>,
but nothing from that header is actaully used.

So remove the #include, so that the linux headers no longer
need to be installed.

Fixes: feba04fd2cf8 ("lib: add crc64 calculation routines")
Signed-off-by: NeilBrown <neil@brown.name>
=2D--
 lib/gen_crc64table.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/gen_crc64table.c b/lib/gen_crc64table.c
index 9011926e4162..094b43aef8db 100644
=2D-- a/lib/gen_crc64table.c
+++ b/lib/gen_crc64table.c
@@ -16,8 +16,6 @@
 #include <inttypes.h>
 #include <stdio.h>
=20
=2D#include <linux/swab.h>
=2D
 #define CRC64_ECMA182_POLY 0x42F0E1EBA9EA3693ULL
=20
 static uint64_t crc64_table[256] =3D {0};
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlwm4sEACgkQOeye3VZi
gbnPcw/+Ju6khZuWMFREuKIm4iD3s/TJI70OINya8wbY0Q+CnwZTUf1nzHrPwb7u
jRchv0puHVPLHtUmiJR/9h/eO+fRaMNTPPUiTMS8FHV+uIYXrhRwGiNdJZE9bVN7
WUkz5qlvUxb++qc115gRAO2LwglkOis8BUyG7oM4kLXH/XdNMQJiX5wub6swLRGz
QzmEIiZaL39393+/arYz7AhY6IZ8VCX7jl8QMqWsDy3xFAFFDI+jj7h0qnmJ+QBp
dwwEzfO7aSnoRodzo58Z869NKhT9TG4xYwzf8++GvPVcExtlWl0X0o54hxP691eD
Ee7MjsPT5hYrNIr8GZJ6sexg8WR+73/CHNgy3jZL+64O031qq+y5XwXUhLSPgwNa
NrlSNlUU/FvzKbtXxDcgcBAVhV/EWuduLRbXTAc8g3c5uXeVUqC2+i/JGyEuQiWD
lredVpk5c06mbjwfUMhO8YV68RdGcuXXUSEm0zCwv+Y8EmBOllhOEiTIH5xoyFtP
DqzRRSKIUJtMgrw0E6cRw12IW/ziOXW/6crZ4I7GovZUzEw3hA67Ol/Sm885pdqa
u4XTL1z212qom5fBsDkRfLbVMtiSQIqmrVQ1Cy5hKNrq/jp9Zgx5QhGK5bpyjmEM
Iz8BzfU5tph28tzu8MrW81kKszOVZLPxXxaQRkcs/lE1qjvYVHo=
=IWQn
-----END PGP SIGNATURE-----
--=-=-=--
