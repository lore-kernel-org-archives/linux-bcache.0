From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
Date: Thu, 18 Apr 2019 11:03:16 -0700
Message-ID: <CAPcyv4iSyM2r5fv=p4B=h=1sR8Zok3gxb1BVsQOy6FHmQtjGCg@mail.gmail.com>
References: <20190411210834.4105-1-jglisse@redhat.com> <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel> <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
 <20190416194936.GD21526@redhat.com> <CAPcyv4i-YHH+dH8za1i1aMcHzQXfovVSrRFp_nfa-KYN-XhAvw@mail.gmail.com>
 <20190417222858.GA4146@redhat.com> <20190418104205.GA28541@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418104205.GA28541@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <boaz@plexistor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, John Hubbard <jhubbard@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Alex Elder <elder@kernel>
List-Id: linux-bcache@vger.kernel.org

On Thu, Apr 18, 2019 at 3:42 AM Jan Kara <jack@suse.cz> wrote:
> > Except that this solution (biasing everyone in bio) would _more complex_
> > it is only conceptualy appealing. The changes are on the other hand much
> > deeper and much riskier but you decided to ignore that and focus on some-
> > thing i was just giving as an example.
>
> Yeah, after going and reading several places like fs/iomap.c, fs/mpage.c,
> drivers/md/dm-io.c I agree with you. The places that are not doing direct
> IO usually just don't hold any page reference that could be directly
> attributed to the bio (and they don't drop it when bio finishes). They
> rather use other means (like PageLocked, PageWriteback) to make sure the
> page stays alive so mandating gup-pin reference for all pages attached to a
> bio would require a lot of reworking of places that are not related to our
> problem and currently work just fine. So I withdraw my suggestion. Nice in
> theory, too much work in practice ;).

Is it though? We already have BIO_NO_PAGE_REF, so it seems it would be
a useful cleanup to have all locations that don't participate in page
references use that existing flag and then teach all other locations
to use gup-pinned pages.
