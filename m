From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Date: Tue, 16 Apr 2019 12:12:27 -0700
Message-ID: <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
References: <20190411210834.4105-1-jglisse@redhat.com> <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416185922.GA12818@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Boaz Harrosh <boaz@plexistor.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Alex Elder <elder@kernel.org>, ce
List-Id: linux-bcache@vger.kernel.org

On Tue, Apr 16, 2019 at 11:59 AM Kent Overstreet
<kent.overstreet@gmail.com> wrote:
>
> On Tue, Apr 16, 2019 at 09:35:04PM +0300, Boaz Harrosh wrote:
> > On Thu, Apr 11, 2019 at 05:08:19PM -0400, jglisse@redhat.com wrote:
> > > From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > >
> > > This patchset depends on various small fixes [1] and also on patchset
> > > which introduce put_user_page*() [2] and thus is 5.3 material as thos=
e
> > > pre-requisite will get in 5.2 at best. Nonetheless i am posting it no=
w
> > > so that it can get review and comments on how and what should be done
> > > to test things.
> > >
> > > For various reasons [2] [3] we want to track page reference through G=
UP
> > > differently than "regular" page reference. Thus we need to keep track
> > > of how we got a page within the block and fs layer. To do so this pat=
ch-
> > > set change the bio_bvec struct to store a pfn and flags instead of a
> > > direct pointer to a page. This way we can flag page that are coming f=
rom
> > > GUP.
> > >
> > > This patchset is divided as follow:
> > >     - First part of the patchset is just small cleanup i believe they
> > >       can go in as his assuming people are ok with them.
> >
> >
> > >     - Second part convert bio_vec->bv_page to bio_vec->bv_pfn this is
> > >       done in multi-step, first we replace all direct dereference of
> > >       the field by call to inline helper, then we introduce macro for
> > >       bio_bvec that are initialized on the stack. Finaly we change th=
e
> > >       bv_page field to bv_pfn.
> >
> > Why do we need a bv_pfn. Why not just use the lowest bit of the page-pt=
r
> > as a flag (pointer always aligned to 64 bytes in our case).
> >
> > So yes we need an inline helper for reference of the page but is it not=
 clearer
> > that we assume a page* and not any kind of pfn ?
> > It will not be the first place using low bits of a pointer for flags.
> >
> > That said. Why we need it at all? I mean why not have it as a bio flag.=
 If it exist
> > at all that a user has a GUP and none-GUP pages to IO at the same reque=
st he/she
> > can just submit them as two separate BIOs (chained at the block layer).
> >
> > Many users just submit one page bios and let elevator merge them any wa=
y.
>
> Let's please not add additional flags and weirdness to struct bio - "if t=
his
> flag is set interpret one way, if not interpret another" - or eventually =
bios
> will be as bad as skbuffs. I would much prefer just changing bv_page to b=
v_pfn.

This all reminds of the failed attempt to teach the block layer to
operate without pages:

https://lore.kernel.org/lkml/20150316201640.33102.33761.stgit@dwillia2-desk=
3.amr.corp.intel.com/

>
> Question though - why do we need a flag for whether a page is a GUP page =
or not?
> Couldn't the needed information just be determined by what range the pfn =
is not
> (i.e. whether or not it has a struct page associated with it)?

That amounts to a pfn_valid() check which is a bit heavier than if we
can store a flag in the bv_pfn entry directly.

I'd say create a new PFN_* flag, and make bv_pfn a 'pfn_t' rather than
an 'unsigned long'.

That said, I'm still in favor of Jan's proposal to just make the
bv_page semantics uniform. Otherwise we're complicating this core
infrastructure for some yet to be implemented GPU memory management
capabilities with yet to be determined value. Circle back when that
value is clear, but in the meantime fix the GUP bug.
