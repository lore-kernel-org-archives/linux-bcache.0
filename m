From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Date: Wed, 17 Apr 2019 17:19:43 -0400
Message-ID: <20190417211943.GA24523@redhat.com>
References: <20190411210834.4105-1-jglisse@redhat.com>
 <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel>
 <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
 <ccac6c5a-7120-0455-88de-ca321b01e825@plexistor.com>
 <20190416195735.GE21526@redhat.com>
 <41e2d7e1-104b-a006-2824-015ca8c76cc8@gmail.com>
 <20190416231655.GB22465@redhat.com>
 <fa00a2ff-3664-3165-7af8-9d9c53238245@plexistor.com>
 <20190417020345.GB3330@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190417020345.GB3330@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Boaz Harrosh <openosd@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kent Overstreet <kent.overstreet@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Alex Elder <elder@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, Apr 16, 2019 at 10:03:45PM -0400, Jerome Glisse wrote:
> On Wed, Apr 17, 2019 at 04:11:03AM +0300, Boaz Harrosh wrote:
> > On 17/04/19 02:16, Jerome Glisse wrote:
> > > On Wed, Apr 17, 2019 at 01:09:22AM +0300, Boaz Harrosh wrote:
> > >> On 16/04/19 22:57, Jerome Glisse wrote:

[...]

> > >>
> > >> BTW: Are you aware of the users of iov_iter_get_pages_alloc() Do they need fixing too?
> > > 
> > > Yeah and that patchset should address those already, i do not think
> > > i missed any.
> > > 
> > 
> > I could not find a patch for nfs/direct.c where a put_page is called
> > to balance the iov_iter_get_pages_alloc(). Which takes care of for example of
> > the blocklayout.c pages state
> > 
> > So I think the deep Audit needs to be for iov_iter_get_pages and get_user_pages
> > and the balancing of that. And the all of bio_alloc and bio_add_page should stay
> > agnostic to any pege-refs taking/putting
> 
> Will try to get started on that and see if i hit any roadblock. I will
> report once i get my feet wet, or at least before i drown ;)

So far it does not look too bad:

https://cgit.freedesktop.org/~glisse/linux/log/?h=gup-bio-v2

they are few things that will be harder to fit in like splice
and pipe that are populated from GUP.

Cheers,
Jérôme
