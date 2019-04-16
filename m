From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Date: Tue, 16 Apr 2019 19:16:56 -0400
Message-ID: <20190416231655.GB22465@redhat.com>
References: <20190411210834.4105-1-jglisse@redhat.com>
 <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel>
 <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
 <ccac6c5a-7120-0455-88de-ca321b01e825@plexistor.com>
 <20190416195735.GE21526@redhat.com>
 <41e2d7e1-104b-a006-2824-015ca8c76cc8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41e2d7e1-104b-a006-2824-015ca8c76cc8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: Boaz Harrosh <boaz@plexistor.com>, Dan Williams <dan.j.williams@intel.com>, Kent Overstreet <kent.overstreet@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Alex Elder <elder@kernel.or>
List-Id: linux-bcache@vger.kernel.org

On Wed, Apr 17, 2019 at 01:09:22AM +0300, Boaz Harrosh wrote:
> On 16/04/19 22:57, Jerome Glisse wrote:
> <>
> > 
> > A very long thread on this:
> > 
> > https://lkml.org/lkml/2018/12/3/1128
> > 
> > especialy all the reply to this first one
> > 
> > There is also:
> > 
> > https://lkml.org/lkml/2019/3/26/1395
> > https://lwn.net/Articles/753027/
> > 
> 
> OK I have re-read this patchset and a little bit of the threads above (not all)
> 
> As I understand the long term plan is to keep two separate ref-counts one
> for GUP-ref and one for the regular page-state/ownership ref.
> Currently looking at page-ref we do not know if we have a GUP currently held.
> With the new plan we can (Still not sure what's the full plan with this new info)
> 
> But if you make it such as the first GUP-ref also takes a page_ref and the
> last GUp-dec also does put_page. Then the all of these becomes a matter of
> matching every call to get_user_pages or iov_iter_get_pages() with a new
> put_user_pages or iov_iter_put_pages().
> 
> Then if much below us an LLD takes a get_page() say an skb below the iscsi
> driver, and so on. We do not care and we keep doing a put_page because we know
> the GUP-ref holds the page for us.
> 
> The current block layer is transparent to any page-ref it does not take any
> nor put_page any. It is only the higher users that have done GUP that take care of that.
> 
> The patterns I see are:
> 
>   iov_iter_get_pages()
> 
> 	IO(sync)
> 
>   for(numpages)
> 	put_page()
> 
> Or
> 
>   iov_iter_get_pages()
> 
> 	IO (async)
> 		->	foo_end_io()
> 				put_page
> 
> (Same with get_user_pages)
> (IO need not be block layer. It can be networking and so on like in NFS or CIFS
>  and so on)

They are also other code that pass around bio_vec and the code that
fill it is disconnected from the code that release the page and they
can mix and match GUP and non GUP AFAICT.

On fs side they are also code that fill either bio or bio_vec and
use some extra mechanism other than bio_end to submit io through
workqueue and then release pages (cifs for instance). Again i believe
they can mix and match GUP and non GUP (i have not spotted something
obvious indicating otherwise).

> 
> The first pattern is easy just add the proper new api for
> it, so for every iov_iter_get_pages() you have an iov_iter_put_pages() and remove
> lots of cooked up for loops. Also the all iov_iter_get_pages_use_gup() just drops.
> (Same at get_user_pages sites use put_user_pages)

Yes this patchset already convert some of this first pattern.

> The second pattern is a bit harder because it is possible that the foo_end_io()
> is currently used for GUP as well as none-GUP cases. this is easy to fix. But the
> even harder case is if the same foo_end_io() call has some pages GUPed and some not
> in the same call.
> 
> staring at this patchset and the call sites I did not see any such places. Do you know
> of any?
> (We can always force such mixed-case users to always GUP-ref the pages and code
>  foo_end_io() to GUP-dec)

I believe direct-io.c is such example thought in that case i believe it
can only be the ZERO_PAGE so this might easily detectable. They are also
lot of fs functions taking an iterator and then using iov_iter_get_pages*()
to fill a bio. AFAICT those functions can be call with pipe iterator or
iovec iterator and probably also with other iterator type. But it is all
common code afterward (the bi_end_io function is the same no matter the
iterator).

Thought that can probably be solve that way:

From:
    foo_bi_end_io(struct bio *bio) {
        ...
        for (i = 0; i < npages; ++i) {
            put_page(pages[i]);
        }
    }

To:
    foo_bi_end_io_common(struct bio *bio) {
        ...
    }

    foo_bi_end_io_normal(struct bio *bio)
        foo_bi_end_io_common(bio);
        for (i = 0; i < npages; ++i) {
            put_page(pages[i]);
        }
    }

    foo_bi_end_io_gup(struct bio *bio)
        foo_bi_end_io_common(bio);
        for (i = 0; i < npages; ++i) {
            put_user_page(pages[i]);
        }
    }

Then when filling in the bio i either pick foo_bi_end_io_normal() or
foo_bi_end_io_gup(). I am assuming that bio with different bi_end_io
function never get merge.

The issue is that some bio_add_page*() call site are disconnected
from where the bio is allocated and initialized (and also where the
bi_end_io function is set). This make it quite hard to ascertain
that GUPed page and non GUP page can not co-exist in same bio.

Also in some cases it is not clear that the same iter is use to
fill the same bio ie it might be possible that some code path fill
the same bio from different iterator (and thus some pages might
be coming from GUP and other not).

It would certainly seems to require more careful review from the
maintainers of such fs. I tend to believe that putting the burden
on the reviewer is a harder sell :)

From quick glance:
   - nilfs segment thing
   - direct-io same bio accumulate pages over multiple call but
     it should always be from same iterator and thus either always
     be from GUP or non GUP. Also the ZERO_PAGE case should be easy
     to catch.
   - fs/nfs/blocklayout/blocklayout.c
   - gfs2 log buffer, that should never be page from GUP but i could
     not ascertain that easily from quick review

This is not extensive, i was just grepping for bio_add_page() and
they are 2 other variant to check and i tended to discard places
where bio is allocated in same function as bio_add_page() but this
might not be a valid assumption either. Some bio might be allocated
and only if there is no default bio already and then set as default
bio which might be use latter on with different iterator.

> 
> So with a very careful coding I think you need not touch the block / scatter-list layers
> nor any LLD drivers. The only code affected is the code around the get_user_pages and friends.
> Changing the API will surface all those.
> (IE. introduce a new API, convert one by one, Remove old API)
> 
> Am I smoking?

No, i thought about it seemed more dangerous and harder to get right
because some code add page in one place and setup bio in another. I
can dig some more on that front but this still leave the non-bio user
of bio_vec and those IIRC also suffer from same disconnect issue.

> 
> BTW: Are you aware of the users of iov_iter_get_pages_alloc() Do they need fixing too?

Yeah and that patchset should address those already, i do not think
i missed any.

Cheers,
Jérôme
