From: Ming Lin <mlin@kernel.org>
Subject: Re: bcache and load average
Date: Mon, 18 May 2015 13:27:21 -0700
Message-ID: <CAF1ivSZAkeSAznsoKWFbnMEUFOvYBEK7ZQ8EZrK-aucQ96se6A@mail.gmail.com>
References: <20150515185032.6b129595@harpe.intellique.com>
	<alpine.DEB.2.02.1505151053020.8760@ware.dreamhost.com>
	<20150515203736.GB24997@birch.djwong.org>
	<CAF1ivSb32U+KGfe1EAUsM04ASjYp=qFB8wD+sxqx2-7PJOYuEA@mail.gmail.com>
	<alpine.DEB.2.02.1505181214530.7900@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbbERU1Z (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 18 May 2015 16:27:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F160E203E9
	for <linux-bcache@vger.kernel.org>; Mon, 18 May 2015 20:27:23 +0000 (UTC)
Received: from mail-vn0-f51.google.com (mail-vn0-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id CF5A6203E3
	for <linux-bcache@vger.kernel.org>; Mon, 18 May 2015 20:27:22 +0000 (UTC)
Received: by vnbg190 with SMTP id g190so5165900vnb.4
        for <linux-bcache@vger.kernel.org>; Mon, 18 May 2015 13:27:22 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.02.1505181214530.7900@ware.dreamhost.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Mon, May 18, 2015 at 12:17 PM, Eric Wheeler
<bcache@lists.ewheeler.net> wrote:
>> >> Try the attached patches that I've been collecting over the past year or
>> >> two. I do not believe they have been merged into mainline (BUT SOMEONE
>> >> NEEDS TO).
>
>> I have put the patches here.
>> https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=bcache
>>
>> I'm new to bcache code.
>> I'll read these patches and run some tests.
>>
>> Ming
>
> Excellent! Will these flow into Linus' kernel?

I'm going to reproduce the problems these patches fixed.
Then I'll send these to block layer maintainer Jens Axboe.

Can I add your "Tested-by"?

Thanks.
