Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8A7C64E8A
	for <linux-bcache@archiver.kernel.org>; Mon, 30 Nov 2020 14:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23CD222242
	for <linux-bcache@archiver.kernel.org>; Mon, 30 Nov 2020 14:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgK3Owe (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 30 Nov 2020 09:52:34 -0500
Received: from verein.lst.de ([213.95.11.211]:44636 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgK3Owd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Nov 2020 09:52:33 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3C4A86736F; Mon, 30 Nov 2020 15:51:50 +0100 (CET)
Date:   Mon, 30 Nov 2020 15:51:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Jan Kara <jack@suse.com>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 30/45] block: remove the nr_sects field in struct
 hd_struct
Message-ID: <20201130145150.GA24694@lst.de>
References: <20201128161510.347752-1-hch@lst.de> <20201128161510.347752-31-hch@lst.de> <20201130094421.GD11250@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130094421.GD11250@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 30, 2020 at 10:44:21AM +0100, Jan Kara wrote:
> I know I'm like a broken record about this but I still don't understand
> here... I'd expect the new code to be:
> 
> 	if (size == capacity ||
> 	    (disk->flags & (GENHD_FL_UP | GENHD_FL_HIDDEN)) != GENHD_FL_UP)
> 		return false;
> 	pr_info("%s: detected capacity change from %lld to %lld\n",
> 		disk->disk_name, size, capacity);
> +	if (!capacity || !size)
> +		return false;
> 	kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
> 	return true;
> 
> At least that would be equivalent to the original functionality of
> set_capacity_and_notify(). And if you indeed intend to change when
> "RESIZE=1" events are sent, then I'd expect an explanation in the changelog
> why this cannot break userspace (I remember we've already broken some udev
> rules in the past by generating unexpected events and we had to revert
> those changes in the partition code so I'm more careful now). The rest of
> the patch looks good to me.

I explained that I think the GENHD_FL_UP is the more useful one here in
reply to your last comment.   If the size changes to or from 0 during
runtime we probably do want an event.

But I'll add your hunk for now and we can discuss this separately.
