From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v5 1/2] lib: add crc64 calculation routines
Date: Sat, 29 Dec 2018 11:57:16 +0800
Message-ID: <5084b641-0a9e-aeb3-4956-247b45eeffd2@suse.de>
References: <20180726053352.2781-1-colyli@suse.de>
 <20180726053352.2781-2-colyli@suse.de>
 <20180726130210.97450a74c164a02d7cfd79c1@linux-foundation.org>
 <87y3899gzi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87y3899gzi.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neil@brown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-bcache@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 12/29/18 10:58 上午, NeilBrown wrote:
> On Thu, Jul 26 2018, Andrew Morton wrote:
> 
>> On Thu, 26 Jul 2018 13:33:51 +0800 Coly Li <colyli@suse.de>
>> wrote:
>> 
>>> This patch adds the re-write crc64 calculation routines for
>>> Linux kernel. The CRC64 polynomial arithmetic follows ECMA-182
>>> specification, inspired by CRC paper of Dr. Ross N. Williams 
>>> (see http://www.ross.net/crc/download/crc_v3.txt) and other
>>> public domain implementations.
> 
> Hi Coly and Andrew,
> 
> This patch breaks compilation if linux headers files are not
> installed (reported at
> https://github.com/gnubee-git/GnuBee_Docs/issues/75). Following
> fixes it.
> 
> Thanks, NeilBrown
> 

Hi Neil,

Thanks for the fix. I add by Acked-by.

Coly Li


> From: NeilBrown <neil@brown.name> Subject: [PATCH] lib: don't
> depend on linux headers being installed.
> 
> gen_crc64table requires linux include files to be installed in
> /usr/include/linux.  This is a new requrement so hosts that could
> previously build the kernel, now cannot.
> 
> gen_crc64table makes this requirement by including <linux/swab.h>, 
> but nothing from that header is actaully used.
> 
> So remove the #include, so that the linux headers no longer need to
> be installed.
> 
> Fixes: feba04fd2cf8 ("lib: add crc64 calculation routines") 
> Signed-off-by: NeilBrown <neil@brown.name>

Acked-by: Coly Li <colyli@suse.de>

> --- lib/gen_crc64table.c | 2 -- 1 file changed, 2 deletions(-)
> 
> diff --git a/lib/gen_crc64table.c b/lib/gen_crc64table.c index
> 9011926e4162..094b43aef8db 100644 --- a/lib/gen_crc64table.c +++
> b/lib/gen_crc64table.c @@ -16,8 +16,6 @@ #include <inttypes.h> 
> #include <stdio.h>
> 
> -#include <linux/swab.h> - #define CRC64_ECMA182_POLY
> 0x42F0E1EBA9EA3693ULL
> 
> static uint64_t crc64_table[256] = {0};
> 

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEE6j5FL/T5SGCN6PrQxzkHk2t9+PwFAlwm8JsACgkQxzkHk2t9
+PxELA//U8FohU56Xty9Yfe/5IX0WXHzpLk8efz34xNodo1bavy9yIlpzG8l9cX5
c2vaM4hYvc2rrYokgkxHcANSpFkRzD9TjkwNbij7wd37lEJYzPWr0Qk1Ttuojs7b
iJYLis0pbu6WTeUpM4NwdkKzylqWXg0dRrf3tNpF5ttN+LZOSEzbIiP8P2rnQUmD
a9WCM6Ka/E9dP5H2CIvR6gAJL/BwsVyFgd6PiYy8ElMVYBpIu2uG34eO0tx6ebSE
TPxWrSXY92jWCggJUBNr5zDXyBQADBQfy0YIv36zsplcolF/4mN4LWF2WCC4jp0c
XLBrvSslzombjxq3h+zE4GNXsDNiKtaNQy1N30b1+N3ilXa4uav1wVvaBQBMwf4I
QQDM8ZZ2alS5zAyzgtnbIr0AhlNEya+GO+42+rY0yrWG2Ffg3ONHSgylQ7hANVdk
2qAWugdXZLw/pqustIodIR3hjsWLc4zZDF+d6BywdB5WqSiS54u7ENSPkbGInKRR
8zprb2tjjjgwxL1MXF+6J1HG+GoTvEjjwjh26XDSiFbWCIX3hRjej+EjltKDARIo
RWfX6/hTVnljkNUEpBfsi7DaiDVwkgo1OLQ3OSXgG9rZxs50ASMb4dBuN8wGdRrX
jK3PF5m3ddVxCW2I5CFltd3qHlUFn+fmQojXtU6VSACgw0roQhw=
=qnbZ
-----END PGP SIGNATURE-----
