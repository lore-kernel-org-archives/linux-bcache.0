From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Thu, 1 May 2014 11:38:48 +0200
Message-ID: <CAHnuAexAx_QK3tycB_2o60JDYZAHUgbec=fu3i47ZSXrL4nARg@mail.gmail.com>
References: <20140411002636.GB9176@birch.djwong.org> <20140411004649.GA4817@kmo>
 <20140411014135.GA18933@birch.djwong.org> <20140412023101.GC9176@birch.djwong.org>
 <CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com> <20140430172455.GA3029@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:60248 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaEAJj3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 1 May 2014 05:39:29 -0400
Received: by mail-oa0-f47.google.com with SMTP id i11so3348047oag.6
        for <linux-bcache@vger.kernel.org>; Thu, 01 May 2014 02:39:28 -0700 (PDT)
In-Reply-To: <20140430172455.GA3029@birch.djwong.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Sam Fulcomer <enotty@brown.edu>, Francis Moreau <francis.moro@gmail.com>, Daniel J Blueman <daniel@quora.org>, linux-bcache@vger.kernel.org

On Wed, Apr 30, 2014 at 7:24 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> I haven't spent time on figuring out the other source of load average.  Kent
> didn't seem to like the patch to convert the bcache_writeback thread to
> interruptible sleep (I recall he said it was 'wrong', but didn't elaborate).
>

Sorry to hear that... Would be really nice to be able to go back to
normal load. And I cannot revert to an older kernel, as I need
3.15-rc2 or greater to fix a different problem concerning Oracle Java
:/
