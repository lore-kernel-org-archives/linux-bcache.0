Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D149DC63798
	for <linux-bcache@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D4EF208CA
	for <linux-bcache@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4BrkAke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403945AbgKXRjQ (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403933AbgKXRjP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Nov 2020 12:39:15 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCBAC0613D6;
        Tue, 24 Nov 2020 09:39:15 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id z188so10070978qke.9;
        Tue, 24 Nov 2020 09:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1gf+uZOc59XzmKEaDiZtFHdLCUgfXw7pOt3g9dTtDNI=;
        b=M4BrkAkexyVnkGUjwXdFjVYmVA9LVLj6ookNf5Ar0M5rW60FOFaco8NOC5V53XdKf3
         QJEfLqRZiaD+6aOYpsb7R05SzbB3BGYlmBRdin+nnS7Rl2/BZJIjCGem3ORrY6o5M9QB
         v9ss2oYhE9tLgFZfLE3LUECIa1myAFcsarnIGBk9Ar+eH0Bp+cdl7ZRZkZZx50CbTsHE
         K2VguikHFXg5qBSb0ELsCBeZfhaX/wrxj8/wztYcWOB/MjJmdrILJmWyfS//vV8R3Onf
         0IRpZT97EaMt3VXXj+9C8TX6D4SZ8wZliFCO/qY/oBmhfCgjCD7BmPqTXEJzXRSaVyYm
         sdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1gf+uZOc59XzmKEaDiZtFHdLCUgfXw7pOt3g9dTtDNI=;
        b=HRpwfmA4pWXy5c98Uugt+jQKMWq2fnpoibLZgSWa/MG/yf6dPWtwgMKdZ1aSLzReeS
         vm8HBqtkxFXgQXp6T6fNoHgUfZ/4AQd2LUdH1rvjVcyKAG6v3CMayzbm4/h9rNQEXguI
         wBNpYHfKwiK+A1Z6BfjhiiNR5N/5vBrYC2Jr857PAgUxRXP4eECaO+phzntRerWQspzv
         iPzJsrE25dQ/e8AFNmexj+57C+mylcUSS8cgoarWXaJpgKnQhWVRjvLR2VJl2y95w2sC
         XTJPrr3TAtNr96AH7/3CdjsDJuthHyvPpUsNjVhQillFtBHKTNsZXUrEhnCiJI0fo6cC
         Za+Q==
X-Gm-Message-State: AOAM53343i+zE3Ta6CYPaqGuCxq0E2jdxxijM45REMKZiD78gP22SBsu
        k3maYIQFIh0C9SdLPj+HuxM=
X-Google-Smtp-Source: ABdhPJw/9uU36tM4rV+p5Q1FKg2O4RrQNewNe3FrRSf3D7AKvxn62XJtfvC4G0F74E53WmoixHdIOg==
X-Received: by 2002:a05:620a:569:: with SMTP id p9mr5395902qkp.119.1606239554812;
        Tue, 24 Nov 2020 09:39:14 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
        by smtp.gmail.com with ESMTPSA id o125sm13142963qke.56.2020.11.24.09.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 09:39:14 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 24 Nov 2020 12:38:50 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Richard Weinberger <richard@nod.at>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 18/45] init: refactor devt_from_partuuid
Message-ID: <X71FKqT9KtO4zTvw@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
 <20201124132751.3747337-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124132751.3747337-19-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Nov 24, 2020 at 02:27:24PM +0100, Christoph Hellwig wrote:
> The code in devt_from_partuuid is very convoluted.  Refactor a bit by
> sanitizing the goto and variable name usage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
