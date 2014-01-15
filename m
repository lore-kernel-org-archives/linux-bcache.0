From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] mm: Make {,set}page_address() static inline if
 WANT_PAGE_VIRTUAL
Date: Wed, 15 Jan 2014 11:46:31 +0200
Message-ID: <20140115094631.GA2107@redhat.com>
References: <1389778426-14836-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1389778426-14836-1-git-send-email-geert@linux-m68k.org>
Sender: owner-linux-mm@kvack.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, linux-mm@kvack.org, linux-bcache@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>, sparclinux@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 15, 2014 at 10:33:46AM +0100, Geert Uytterhoeven wrote:
> {,set}page_address() are macros if WANT_PAGE_VIRTUAL.
> If !WANT_PAGE_VIRTUAL, they're plain C functions.
>=20
> If someone calls them with a void *, this pointer is auto-converted to
> struct page * if !WANT_PAGE_VIRTUAL, but causes a build failure on
> architectures using WANT_PAGE_VIRTUAL (arc, m68k and sparc):
>=20
> drivers/md/bcache/bset.c: In function =E2=80=98__btree_sort=E2=80=99:
> drivers/md/bcache/bset.c:1190: warning: dereferencing =E2=80=98void *=E2=
=80=99 pointer
> drivers/md/bcache/bset.c:1190: error: request for member =E2=80=98virtu=
al=E2=80=99 in something not a structure or union
>=20
> Convert them to static inline functions to fix this. There are already
> plenty of  users of struct page members inside <linux/mm.h>, so there's=
 no
> reason to keep them as macros.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

FWIW

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/10469287/ (m68k/next)
> http://kisskb.ellerman.id.au/kisskb/buildresult/10469488/ (sparc64/next=
)
> https://lkml.org/lkml/2014/1/13/1044 (m68k & sparc/3.10.27-stable)
>=20
>  include/linux/mm.h |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 35527173cf50..9fac6dd69b11 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -846,11 +846,14 @@ static __always_inline void *lowmem_page_address(=
const struct page *page)
>  #endif
> =20
>  #if defined(WANT_PAGE_VIRTUAL)
> -#define page_address(page) ((page)->virtual)
> -#define set_page_address(page, address)			\
> -	do {						\
> -		(page)->virtual =3D (address);		\
> -	} while(0)
> +static inline void *page_address(const struct page *page)
> +{
> +	return page->virtual;
> +}
> +static inline void set_page_address(struct page *page, void *address)
> +{
> +	page->virtual =3D address;
> +}
>  #define page_address_init()  do { } while(0)
>  #endif
> =20
> --=20
> 1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
