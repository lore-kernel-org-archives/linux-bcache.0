From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Date: Tue, 16 Apr 2019 19:34:03 -0400
Message-ID: <20190416233402.GC22465@redhat.com>
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

So sorry forgot to answer that part. So idea is to do:
    GUP() {
        ...
-       page_ref_inc(page);
+       page_ref_add(page, GUP_BIAS);
        ...
    }

with GUP_BIAS = 1024 or something big but not too big to avoid risk of
overflow by GUP. Then put_user_page() just ref_sub instead of ref_dec
the same amount.

We can have false GUP positive if a page is map so many time or reference
so many time that its refcount reach the GUP_BIAS value but considering
such page as GUPed should not be too harmful (not more harmful than what
we do with GUPed page).

So we want to call put_user_page() for GUPed page and only GUPed page so
that we keep the reference count properly balance.

Cheers,
Jérôme
