Return-Path: <SRS0=V1bn=AM=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A038C433E0
	for <linux-bcache@archiver.kernel.org>; Wed,  1 Jul 2020 18:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E60207F5
	for <linux-bcache@archiver.kernel.org>; Wed,  1 Jul 2020 18:26:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZwrGxUsJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733015AbgGAS0T (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 1 Jul 2020 14:26:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733010AbgGAS0T (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 14:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593627977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gM4o34lY2Q2Fu9DNpo9nmnqeENsycpsv4CwD0QpSKRo=;
        b=ZwrGxUsJXRw2TeInzKH2KaJeb9JWfx1KCCpvaat4ntHZPxEMPcJvHYoCuuE/LqHFxJiATm
        CMR5wsva05+WpEwBxa2VZABOZwF7xw5v+hOJiZDfIOao/Plpqymv/XDTfhwNJQpla9oVwX
        oJV7CI8PfLVPGrg3qAbF5in+Zc6AIVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-ve54S7gINvapvHMQrfW7sQ-1; Wed, 01 Jul 2020 14:26:14 -0400
X-MC-Unique: ve54S7gINvapvHMQrfW7sQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EE0A80183C;
        Wed,  1 Jul 2020 18:26:11 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 244BF5C1D3;
        Wed,  1 Jul 2020 18:26:08 +0000 (UTC)
Date:   Wed, 1 Jul 2020 13:24:48 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-nvdimm@lists.01.org,
        linux-s390@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, drbd-dev@lists.linbit.com
Subject: Re: [PATCH 10/20] dm: stop using ->queuedata
Message-ID: <20200701172448.GA27528@redhat.com>
References: <20200701085947.3354405-1-hch@lst.de>
 <20200701085947.3354405-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701085947.3354405-11-hch@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200701172448.SaEYjxV6AqG2V8TBxDE1M3w6GLvKtFN0DEaP1XqBmjU@z>

On Wed, Jul 01 2020 at  4:59am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Instead of setting up the queuedata as well just use one private data
> field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

