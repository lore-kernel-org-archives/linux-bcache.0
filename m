From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Date: Tue, 16 Apr 2019 14:47:11 -0400
Message-ID: <20190416184711.GB21526@redhat.com>
References: <20190411210834.4105-1-jglisse@redhat.com>
 <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
List-Id: linux-bcache@vger.kernel.org

On Tue, Apr 16, 2019 at 09:35:04PM +0300, Boaz Harrosh wrote:
> On Thu, Apr 11, 2019 at 05:08:19PM -0400, jglisse@redhat.com wrote:
> > From: Jérôme Glisse <jglisse@redhat.com>
> > 
> > This patchset depends on various small fixes [1] and also on patchset
> > which introduce put_user_page*() [2] and thus is 5.3 material as those
> > pre-requisite will get in 5.2 at best. Nonetheless i am posting it now
> > so that it can get review and comments on how and what should be done
> > to test things.
> > 
> > For various reasons [2] [3] we want to track page reference through GUP
> > differently than "regular" page reference. Thus we need to keep track
> > of how we got a page within the block and fs layer. To do so this patch-
> > set change the bio_bvec struct to store a pfn and flags instead of a
> > direct pointer to a page. This way we can flag page that are coming from
> > GUP.
> > 
> > This patchset is divided as follow:
> >     - First part of the patchset is just small cleanup i believe they
> >       can go in as his assuming people are ok with them.
> 
> 
> >     - Second part convert bio_vec->bv_page to bio_vec->bv_pfn this is
> >       done in multi-step, first we replace all direct dereference of
> >       the field by call to inline helper, then we introduce macro for
> >       bio_bvec that are initialized on the stack. Finaly we change the
> >       bv_page field to bv_pfn.
> 
> Why do we need a bv_pfn. Why not just use the lowest bit of the page-ptr
> as a flag (pointer always aligned to 64 bytes in our case).
> 
> So yes we need an inline helper for reference of the page but is it not clearer
> that we assume a page* and not any kind of pfn ?
> It will not be the first place using low bits of a pointer for flags.

Yes i can use the lower bit of struct page * pointer it should be safe on
all architecture. I wanted to change the bv_page field name to make sure
that we catch anyone doing any direct dereference. Do you prefer keeping a
page pointer there ?

> 
> That said. Why we need it at all? I mean why not have it as a bio flag. If it exist
> at all that a user has a GUP and none-GUP pages to IO at the same request he/she
> can just submit them as two separate BIOs (chained at the block layer).
> 
> Many users just submit one page bios and let elevator merge them any way.

The issue is that bio_vec is use, on its own, outside of bios and for
those use cases i need to track the GUP status within the bio_vec. Thus
it is easier to use the same mechanisms for bio too as adding a flag to
bio would mean that i also have to audit all code path that could merge
bios. While i believe it should be restrictred to block/blk-merge.c it
seems some block and some fs have spawn some custom bio manipulation
(md comes to mind). So using same mechanism for bio_vec and bio seems
like a safer and easier course of action.

Cheers,
Jérôme
