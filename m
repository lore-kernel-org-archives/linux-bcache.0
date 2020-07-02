From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 17/20] block: rename generic_make_request to submit_bio_noacct
Date: Thu, 2 Jul 2020 11:22:12 -0700
Message-ID: <CAPhsuW4=eiN2-_cy5vCn_RGwmYRf37jOX4DWTvUCDWAqRzU+pw@mail.gmail.com>
References: <20200701085947.3354405-1-hch@lst.de> <20200701085947.3354405-18-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgGBSW0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Jul 2020 14:22:26 -0400
In-Reply-To: <20200701085947.3354405-18-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>, linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org

On Wed, Jul 1, 2020 at 2:01 AM Christoph Hellwig <hch@lst.de> wrote:
>
> generic_make_request has always been very confusingly misnamed, so rename
> it to submit_bio_noacct to make it clear that it is submit_bio minus
> accounting and a few checks.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
[...]

>  drivers/md/md-faulty.c                        |  4 +--
>  drivers/md/md-linear.c                        |  4 +--
>  drivers/md/md-multipath.c                     |  4 +--
>  drivers/md/raid0.c                            |  8 ++---
>  drivers/md/raid1.c                            | 14 ++++----
>  drivers/md/raid10.c                           | 28 ++++++++--------
>  drivers/md/raid5.c                            | 10 +++---

For md part:

Acked-by: Song Liu <song@kernel.org>
