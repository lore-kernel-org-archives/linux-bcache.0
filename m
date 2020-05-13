Return-Path: <SRS0=cmwX=63=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6282DC433DF
	for <linux-bcache@archiver.kernel.org>; Wed, 13 May 2020 18:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16AE5205CB
	for <linux-bcache@archiver.kernel.org>; Wed, 13 May 2020 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589395545;
	bh=y3uf4cDEBcGin/ahVjDWwwqBbdeSBPGoaou/iCBc+Ng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=CwnBEHEWQRnwIvZlHL43AMzDVufmODZ7QXc+A1IGU6bUSyuHHZUOKHj629nqztZEm
	 hauMF7XzSzW5KXZqBO2t5BIEW+HmzS9BfqIoL5J7PSaC9PbLCFF2hAnIv5kWCc4+fV
	 kZv4yKQ1wOtRPaFGEUTwOPqEqXf64yu7krRDJQxk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390206AbgEMSpl (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 13 May 2020 14:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390103AbgEMSpk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 May 2020 14:45:40 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7363207D3;
        Wed, 13 May 2020 18:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589395541;
        bh=y3uf4cDEBcGin/ahVjDWwwqBbdeSBPGoaou/iCBc+Ng=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RLQfxHVcrn6lWhWEu0DDrnMIHIoZ+37WfrxEpZxqiKdV1WCyAtQwcUcFu2SvS2080
         VTE5vGbKGPtkrp13IOlhl2+f6sYzR7NeAlwZhvD/+sHUP7ta5YnAY2Vdmt9jo9N04s
         CEpGnXvJbsQIZi+fuoRT8dDY4nvc1HnFSDyGGc2w=
Received: by mail-lj1-f178.google.com with SMTP id b6so770046ljj.1;
        Wed, 13 May 2020 11:45:40 -0700 (PDT)
X-Gm-Message-State: AOAM531+iZhLTB954FET0kCVxVWSa8Hs2pbAp42TG+jOxmggUAmbBj1y
        E8U4afU7mhM23CHroVG7HuETX3YdgdLjfQPZbTA=
X-Google-Smtp-Source: ABdhPJzyHaUiiK2XwtDLa9MHZHs3wyCWyuE6aX0bNKMPXZmRZyv4SYSAs5m7n5jeU7J7JeAy2/ppnnbYCoByE6/YYa8=
X-Received: by 2002:a2e:9258:: with SMTP id v24mr280263ljg.109.1589395538071;
 Wed, 13 May 2020 11:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200508161517.252308-1-hch@lst.de> <20200508161517.252308-13-hch@lst.de>
 <CAPhsuW6_Y53_XLFeVxhTDpTi_PKNLqqnrXLn+M2fJW268eE6_w@mail.gmail.com> <20200513183304.GA29895@lst.de>
In-Reply-To: <20200513183304.GA29895@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 13 May 2020 11:45:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6pG+-EAa-FW96r+LEP=j1nWEK0Zqk_fJeaAu2Hn9AqeA@mail.gmail.com>
Message-ID: <CAPhsuW6pG+-EAa-FW96r+LEP=j1nWEK0Zqk_fJeaAu2Hn9AqeA@mail.gmail.com>
Subject: Re: [PATCH 12/15] md: stop using ->queuedata
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvdimm@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200513184526.busc6dirUwE7Muq5C_nKuNA3T2AMXKErilrkSV6c4Qk@z>

On Wed, May 13, 2020 at 11:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, May 13, 2020 at 11:29:17AM -0700, Song Liu wrote:
> > On Fri, May 8, 2020 at 9:17 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > Thanks for the cleanup. IIUC, you want this go through md tree?
>
> Yes, please pick it up though the md tree.

Thanks for the clarification. Applied to md-next.
