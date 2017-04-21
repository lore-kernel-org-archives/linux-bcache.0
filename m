From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 09/11] bcache: use kmalloc to allocate bio in bch_data_verify()
Date: Fri, 21 Apr 2017 23:41:18 +0800
Message-ID: <CACVXFVMa_Qo2eFhSnt+URaubsr2VSnhW=ypsyjEo5e=L2FG7_w@mail.gmail.com>
References: <149266645258.27388.14083229348123176454.stgit@noble> <149266673005.27388.9415706764616504556.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34257 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040151AbdDUSbB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 Apr 2017 14:31:01 -0400
In-Reply-To: <149266673005.27388.9415706764616504556.stgit@noble>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>

On Thu, Apr 20, 2017 at 1:38 PM, NeilBrown <neilb@suse.com> wrote:
> This function allocates a bio, then a collection
> of pages.  It copes with failure.
>
> It currently uses a mempool() to allocate the bio,
> but alloc_page() to allocate the pages.  These fail
> in different ways, so the usage is inconsistent.
>
> Change the bio_clone() to bio_clone_kmalloc()
> so that no pool is used either for the bio or the pages.
>
> Signed-off-by: NeilBrown <neilb@suse.com>

Reviewed-by : Ming Lei <ming.lei@redhat.com>


Thanks,
Ming Lei
