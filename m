From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Date: Tue, 16 Apr 2019 10:00:22 +1000
Message-ID: <20190416000022.GA1454@dread.disaster.area>
References: <20190411210834.4105-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190411210834.4105-1-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
List-Id: linux-bcache@vger.kernel.org

On Thu, Apr 11, 2019 at 05:08:19PM -0400, jglisse@redhat.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> This patchset depends on various small fixes [1] and also on patchset
> which introduce put_user_page*() [2] and thus is 5.3 material as those
> pre-requisite will get in 5.2 at best. Nonetheless i am posting it now
> so that it can get review and comments on how and what should be done
> to test things.
> 
> For various reasons [2] [3] we want to track page reference through GUP
> differently than "regular" page reference. Thus we need to keep track
> of how we got a page within the block and fs layer. To do so this patch-
> set change the bio_bvec struct to store a pfn and flags instead of a
> direct pointer to a page. This way we can flag page that are coming from
> GUP.
> 
> This patchset is divided as follow:
>     - First part of the patchset is just small cleanup i believe they
>       can go in as his assuming people are ok with them.
>     - Second part convert bio_vec->bv_page to bio_vec->bv_pfn this is
>       done in multi-step, first we replace all direct dereference of
>       the field by call to inline helper, then we introduce macro for
>       bio_bvec that are initialized on the stack. Finaly we change the
>       bv_page field to bv_pfn.
>     - Third part replace put_page(bv_page(bio_vec)) with a new helper
>       which will use put_user_page() when the page in the bio_vec is
>       coming from GUP.
>     - Fourth part update BIO to use bv_set_user_page() for page that
>       are coming from GUP this means updating bio_add_page*() to pass
>       down the origin of the page (GUP or not).
>     - Fith part convert few more places that directly use bvec_io or
>       BIO.
> 
> Note that after this patchset they are still places in the kernel where
> we should use put_user_page*(). The intention is to separate that task
> in chewable chunk (driver by driver, sub-system by sub-system).
> 
> 
> I have only lightly tested this patchset (branch [4]) on my desktop and
> have not seen anything obviously wrong but i might have miss something.
> What kind of test suite should i run to stress test the vfs/block layer
> around DIO and BIO ?

Such widespread changes need full correctness tests run on them. I'd
suggest fstests (auto group) be run on all the filesystems it
supports that are affected by the changes in the patchset. Given you
touched bio_add_page() here, that's probably all of them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
