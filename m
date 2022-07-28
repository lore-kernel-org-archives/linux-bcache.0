Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57C0C04A68
	for <linux-bcache@archiver.kernel.org>; Thu, 28 Jul 2022 17:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiG1RNh (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 28 Jul 2022 13:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiG1RNh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jul 2022 13:13:37 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93EB606B8
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jul 2022 10:13:32 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w185so2465508pfb.4
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jul 2022 10:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Dj+XIt7Kj/l6SD7NCw4yNqTfM/YIqZrgS8oOYqSBuoE=;
        b=yX4s3CPW2g+H8VBBLsI5c66y7C/LZRcm+IWZLfhi6lIILHs08nhnDYvLlR4sOZBDCa
         xYDsO0jYk9XtAp6jQ9BQn+MmsbIH3jCmgeuWt97oiKGRQqbZ9e0offpVoLbbJfb2TuHx
         i8EXF3akanD/KYVWm6zj7i6fJQgbVbelFgse0SVcw5tVDdiiPrk/d6jCcam6tt21/HV/
         9a18bB8xW+0GhgKDQPrrMFRcM7vzFhKO41beeOsAYPrhwcZ9O9eItAldguXOp/rin4Wx
         ml/Z2699/jcWpP27HZLF4Lb9T/rI/1ephgvi7DA42EwN7nRyFcYkF92hn//rpdNdjAY1
         QXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Dj+XIt7Kj/l6SD7NCw4yNqTfM/YIqZrgS8oOYqSBuoE=;
        b=yE1uZXgORSiYfXHwvrifEYjzqP+zu7a/UMML1sqbedMZbNZADCarRdGhNW/JC7QghX
         XbGYT2gC/NuWU5Duhqv3X2LRgBPg57SAroH0GMlnKw48lBZ6nnfg4nrF9eI91NUj/59i
         66N7SggjzJRWBWCm0d1xd0vPVp3RdQ4TibvPGQuh5Havh/WrzHIVW1dYNW+SfCXLP2K8
         33q95RH6j3mg0SAO010v3kmrnfMetzIaGk+CVdpjzP0QAjyr2HTfD25fSFLfrNewu32c
         08oekujefBCZxavE+D69CZ2qmac004v1tvCktfKgrhKQHxFVMEgaIWRMpp1Vaf74ELqt
         bpQw==
X-Gm-Message-State: AJIora8c/k4OwVy26qK+d9VPEDxDphmvBzVfWUBXCDuNYGgJl/sF3NpL
        3nUZ60i7wS+7/8xQrY7stED1KQ==
X-Google-Smtp-Source: AGRyM1u7Vc3bXmnuiSyRSxMJY17A/G0gmjQi4SlVhO5pOwLxcvvlwIKUSgPLbTYYdCgQ2BUOZUFZUQ==
X-Received: by 2002:a05:6a00:1705:b0:525:4cac:fa65 with SMTP id h5-20020a056a00170500b005254cacfa65mr27500342pfc.40.1659028412306;
        Thu, 28 Jul 2022 10:13:32 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902a38e00b0016c20d40ee7sm1534523pla.174.2022.07.28.10.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 10:13:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     colyli@suse.de
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
In-Reply-To: <20220719042724.8498-1-colyli@suse.de>
References: <20220719042724.8498-1-colyli@suse.de>
Subject: Re: [PATCH 0/1] bcache patche for Linux v5.20
Message-Id: <165902841159.13194.11814918605797804157.b4-ty@kernel.dk>
Date:   Thu, 28 Jul 2022 11:13:31 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 19 Jul 2022 12:27:23 +0800, Coly Li wrote:
> There is 1 patch from bcache submission, which removes 'EXPERIMENTAL'
> from the bcache Kconfig item, now 'Asynchronous device registration'
> option is not experimental anymore.
> 
> Please take it for v5.20. Thank you in advance to taking care of this.
> 
> Coly Li
> 
> [...]

Applied, thanks!

[1/1] bcache: remove EXPERIMENTAL for Kconfig option 'Asynchronous device registration'
      commit: 508e357579f07d43cb3feabe93b46bc1648ca5d9

Best regards,
-- 
Jens Axboe


