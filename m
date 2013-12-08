From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: md-raid5 with bcache member devices => kernel panic
Date: Mon, 9 Dec 2013 00:53:06 +0100
Message-ID: <20131208235306.GJ1848@teapot>
References: <20131205212913.GE1848@teapot>
 <20131205225234.GA4054@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41429 "EHLO sw.mfedv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab3LHXxM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 8 Dec 2013 18:53:12 -0500
Content-Disposition: inline
In-Reply-To: <20131205225234.GA4054@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: nks@daterainc.com, linux-bcache@vger.kernel.org

On Thu, Dec 05, 2013 at 02:52:34PM -0800, Kent Overstreet wrote:
> that's a null pointer deref; if Matthias could get the exact line number it
> happened on we could tell what variable was null. I _think_ it's *sg because
> it's running off the end of the scatterlist; if that's the case (and you should
> verify that that is what's happening, then what's going on is bcache is sending
> down a bio larger than what the device expects.

found the kernel config value CONFIG_DEBUG_BUGVERBOSE, tried again with
3.12.3 and 3.13-rc3. The backtrace now spells the line number:

    kernel BUG at drivers/scsi/scsi_lib.c:1048!

1028 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
1029                              gfp_t gfp_mask)
1030 {
1031         int count;
1032
1033         /*
1034          * If sg table allocation fails, requeue request later.
1035          */
1036         if (unlikely(scsi_alloc_sgtable(sdb, req->nr_phys_segments,
1037                                         gfp_mask))) {
1038                 return BLKPREP_DEFER;
1039         }
1040
1041         req->buffer = NULL;
1042
1043         /*
1044          * Next, walk the list, and fill in the addresses and sizes of
1045          * each segment.
1046          */
1047         count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
1048         BUG_ON(count > sdb->table.nents);
1049         sdb->table.nents = count;
1050         sdb->length = blk_rq_bytes(req);
1051         return BLKPREP_OK;
1052 }

Regards
Matthias
