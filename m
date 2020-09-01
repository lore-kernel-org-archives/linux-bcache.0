Return-Path: <SRS0=69Q7=CK=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BD4C433E2
	for <linux-bcache@archiver.kernel.org>; Tue,  1 Sep 2020 20:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA572071B
	for <linux-bcache@archiver.kernel.org>; Tue,  1 Sep 2020 20:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DxigDMGe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgIAUnJ (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 1 Sep 2020 16:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgIAUnI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Sep 2020 16:43:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEDCC061244
        for <linux-bcache@vger.kernel.org>; Tue,  1 Sep 2020 13:43:08 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w14so2793399eds.0
        for <linux-bcache@vger.kernel.org>; Tue, 01 Sep 2020 13:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9nftTDPduIjiqfrkWM25umJZz2WWVEH4XDCLDufb8DE=;
        b=DxigDMGe5H3xAVpViFarMeke57sawT9HaFhgcqNLmI+s0G9PcrYmVfp4vg3BSnva92
         1bZBNQyrQ5wG7MlmQ4Dg4+pcXOJt6M/vwpRAZDSkzcK+nRasXku9g5gowEamQ8ENObzF
         oGJAw5bSM5GmNLkq+T1NecYLqXTafdo6YHDnSHSEXXNsEKRI/lCWdPhz+DB0pxmb+87S
         gs8ic37QuKRt5dXs4JdFgqnB4lzQDbBSSIX5//Eq9wfErA2XnhfpXjQiUqQx3/z4dTJI
         6MtkkdVFyJFvFBJAPKhv5w/VbWYSE50Ya0B+KibhE73LoqyBc4YQ98loxRlI/arg/QlG
         Tp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9nftTDPduIjiqfrkWM25umJZz2WWVEH4XDCLDufb8DE=;
        b=JWeLvFfp/XTN/ppY0YW4/XfLO7gMIVBGtL10MsHB88SYhsyGgBs7ZdGEIXm3IT3JqP
         +RIrDsvfed+rnlBP33rjVGvyAiTOsey2Y0vvIyWS+W8rKlp8YKDFy/qa9LYNEdERWbPC
         qDcq34/PHZ9ViXvI9QmruG63E0I72BkdpKaewoSxB1gr2S/HqoglJDK7FjNOP6LWQUTj
         RIK1CiA2plZuRxqf3kHbMAcWNwjH66oU42w5k4B4ldNpiy25nMuNOnAphi7XzatwbOfq
         0RrrzKaOFobhY2k1mwyvsaSB0YfLtK5WLV2DjfmGJ6bn36v8pfyYwmRjp/l+wqhRRXI4
         u6ZA==
X-Gm-Message-State: AOAM533NBkPgzjCnEK8KyqLimCAHhDDqT58YnHS9U5PqKbXxxbnNqC4V
        Ev7V57izKOYw5B3C5UASSk32mUmJPM4A6gXLAhOzCRPTa2c=
X-Google-Smtp-Source: ABdhPJzcqFIMlgAv5L6isTelrM+xSleK3jaNZH+/LZo7EIJlKt8tBv+VgPOX1rg1XozraynS6vYYJg9cpuOj1qUtcR0=
X-Received: by 2002:aa7:d6c6:: with SMTP id x6mr3557803edr.338.1598992985579;
 Tue, 01 Sep 2020 13:43:05 -0700 (PDT)
MIME-Version: 1.0
From:   Brendan Boerner <bboerner.biz@gmail.com>
Date:   Tue, 1 Sep 2020 15:42:54 -0500
Message-ID: <CAKkfZL0FR=PX5roCpB9HQe5=F6T70F7+8EFL_yTZPEbqWWHKPA@mail.gmail.com>
Subject: Bcache in Ubuntu 18.04 kernel panic
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

I spent the weekend verifying and isolating a kernel panic in bcache
on Ubuntu 18.04 (4.15.0-112-generic #113-Ubuntu SMP Thu Jul 9 23:41:39
UTC 2020).

Is this the place to report it? I have kernel crash dumps.

Thanks!
Brendan
