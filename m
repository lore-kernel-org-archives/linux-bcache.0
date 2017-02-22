From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Drop in Iops with fsync when using NVMe as cache
Date: Wed, 22 Feb 2017 10:40:57 +0100
Message-ID: <20170222094057.GD31967@suse.cz>
References: <CAPntomBf8c6TFBLM5iBuX=OWmfQ-uGCUiDdJnXEn1+-gS7KJaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754654AbdBVJlF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Feb 2017 04:41:05 -0500
Content-Disposition: inline
In-Reply-To: <CAPntomBf8c6TFBLM5iBuX=OWmfQ-uGCUiDdJnXEn1+-gS7KJaw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: shiva rkreddy <shiva.rkreddy@gmail.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org

On Tue, Feb 21, 2017 at 10:48:06AM -0600, shiva rkreddy wrote:

> fio command without fsync:
> 
> # fio -filename=/dev/bcache0 -direct=1 -ioengine=libaio -rw=randwrite
> -bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based
> 
> iops : 35k
> 
> fio command with fsync:
> 
> fio -filename=/dev/bcache0 -direct=1 -ioengine=libaio -rw=randwrite
> -bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based -fsync=1
> 
> iops: 8.1k

> I'm quite surprised by the drop in iops with fsync turned on. Is this
> expected or am I missing some basic setting?

It's not uncommon that fsync would have a huge performance impact.
Without fsync, most of the data never hits the storage and is only
staying in the system memory.

May I suggest that you try to measure the performance of the same tests
when the filesystem is created on the NVMe device directly, without
using bcache? You're likely to observe a similar pattern.

-- 
Vojtech Pavlik
Director SUSE Labs
